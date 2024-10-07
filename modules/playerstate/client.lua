--- @class CLPlayerState
local CLPlayerState = {}

--- @param options PlayerStateConfig
--- @return CLPlayerState instance
function CLPlayerState:new(options)
  local instance = setmetatable({}, { __index = self })
  instance.id = options.id
  instance.label = options.label
  instance.value = nil
  instance.valueConfig = options.value
  instance.clearConfig = options.clear
  instance.pukeConfig = options.puke
  instance.overdoseConfig = options.overdose
  instance.notificationConfig = options.notification

  return instance
end

--- @param value number
--- @return number
function CLPlayerState:adaptValue(value)
  if value < self.valueConfig.min then
    return self.valueConfig.min
  elseif value > self.valueConfig.max then
    return self.valueConfig.max
  end
  return value
end

function CLPlayerState:addStateBagChangeHandler()
  AddStateBagChangeHandler(self.id, ('player:%s'):format(cache.serverId), function(_bagName, _key, value, _reserved, _replicated)
    SetTimeout(100, function()
      value = tonumber(value) or self.valueConfig.default
      value = self:adaptValue(value)
      self:playerStateChanged(value)
    end)
  end)
end

--- @param newValue number
function CLPlayerState:playerStateChanged(newValue)
  if not newValue then return end
  local oldValue = self.value
  self.value = newValue
  if not oldValue then return end
  self:showStateChangedNotification(oldValue, newValue)
end

--- @param oldValue number
--- @param newValue number
function CLPlayerState:showStateChangedNotification(oldValue, newValue)
  if not self.notificationConfig then return end
  local diff = newValue - oldValue
  local notifyData = nil
  if diff > 0 and self.notificationConfig.up.value and diff >= self.notificationConfig.up.value then
    notifyData = self.notificationConfig.up
  elseif diff < 0 and self.notificationConfig.down.value and diff <= self.notificationConfig.down.value then
    notifyData = self.notificationConfig.down
  end
  if notifyData then
    lib.notify(notifyData)
  end
end

function CLPlayerState:clearState()
  return lib.callback.await('ss_playerstates:server:clearState', false, self.id)
end

function CLPlayerState:checkClear()
  if not self.clearConfig or not self.clearConfig.swimming then return end
  if IsPedSwimming(cache.ped) and self.value and self.value ~= self.valueConfig.default then
    if self:clearState() then
      lib.notify({
        title = self.label,
        description = 'Swimming cleared the state ' .. self.label,
        duration = 3000,
        type = 'success',
      })
    end
  end
end

function CLPlayerState:overDose()
  lib.notify({
    title = self.label,
    description = 'You feel dizzy and fall to the ground',
    duration = 3000,
    type = 'error',
  })
  local forwardVector = GetEntityForwardVector(cache.ped)
  SetPedToRagdollWithFall(cache.ped, 1750, 1750, 1, forwardVector.x, forwardVector.y, forwardVector.z, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
  Wait(1000)
  DoScreenFadeOut(200)
  Wait(1000)
  DoScreenFadeIn(200)
  Wait(2000)
  lib.notify({
    title = self.label,
    description = 'You have overdosed and died from the effects of ' .. self.label,
    duration = 3000,
    type = 'error',
  })
  SetEntityHealth(cache.ped, 0)
end

function CLPlayerState:checkOverDose()
  if not self.overdoseConfig then return false end
  if not IsPedOnFoot(cache.ped) then return false end
  if not self.value or self.value < self.overdoseConfig.threshold then return false end
  local playerOverdoseChance = math.random(0, 100)
  if playerOverdoseChance > self.overdoseConfig.chance then return false end
  self:overDose()
  return true
end

function CLPlayerState:puke()
  lib.notify({
    title = self.label,
    description = 'You feel sick and will puke',
    duration = 3000,
    type = 'error',
  })
  Wait(1000)
  DoScreenFadeOut(200)
  Wait(1000)
  DoScreenFadeIn(200)
  Wait(1000)
  lib.progressCircle({
    duration = 10000,
    label = 'Puking',
    useWhileDead = false,
    allowRagdoll = false,
    allowSwimming = false,
    allowCuffed = false,
    allowFalling = false,
    canCancel = false,
    anim = {
      dict = 'anim@scripted@freemode@throw_up_toilet@male@',
      clip = 'vomit',
      flag = 1,
    },
  })
end

function CLPlayerState:checkPuke()
  if not self.pukeConfig then return false end
  if not IsPedOnFoot(cache.ped) then return false end
  if not self.value or self.value < self.pukeConfig.threshold then return false end
  local playerPukeChance = math.random(0, 100)
  if playerPukeChance > self.pukeConfig.chance then return false end
  self:puke()
  return true
end

function CLPlayerState:checkState()
  self:checkClear()
  if self:checkPuke() then return true end
  if self:checkOverDose() then return true end
  return false
end

function CLPlayerState:init()
  self:addStateBagChangeHandler()
end

return CLPlayerState
