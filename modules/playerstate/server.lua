--- @class SVPlayerState
local SVPlayerState = {}

--- @param options PlayerStateConfig
--- @return SVPlayerState instance
function SVPlayerState:new(options)
  local instance = setmetatable({}, { __index = self })
  instance.id = options.id
  instance.label = options.label
  instance.permanent = options.permanent
  instance.values = {}
  instance.valueConfig = options.value
  instance.decayConfig = options.decay
  return instance
end

--- @param value number
--- @return number
function SVPlayerState:validateValue(value)
  if value < self.valueConfig.min then
    return self.valueConfig.min
  elseif value > self.valueConfig.max then
    return self.valueConfig.max
  end
  return value
end

--- @param playerSrc number
--- @param value number
--- @return boolean
function SVPlayerState:setPlayerState(playerSrc, value)
  local player = exports.qbx_core:GetPlayer(playerSrc)
  if not player then return false end
  local playerEntity = Player(playerSrc)
  if not playerEntity then return false end
  local newValue = self:validateValue(value)
  self.values[playerSrc] = newValue
  playerEntity.state:set(self.id, newValue, true)
  if self.permanent then
    player.Functions.SetMetaData(self.id, newValue)
  end
  return true
end

--- @param playerSrc number
--- @param value number
--- @return boolean
function SVPlayerState:addToPlayerState(playerSrc, value)
  local playerEntity = Player(playerSrc)
  if not playerEntity then return false end
  local currentStateValue = playerEntity.state[self.id] or self.valueConfig.default
  local newValue = self:validateValue(currentStateValue + value)
  return self:setPlayerState(playerSrc, newValue)
end

--- @param playerSrc number
--- @return boolean
function SVPlayerState:clearPlayerState(playerSrc)
  return self:setPlayerState(playerSrc, self.valueConfig.default)
end

--- @param playerSrc number
function SVPlayerState:destroyPlayerState(playerSrc)
  local playerEntity = Player(playerSrc)
  if not playerEntity then return end
  self.values[playerSrc] = nil
  playerEntity.state:set(self.id, nil, true)
end

--- @param playerSrc number
function SVPlayerState:initPlayerState(playerSrc)
  local player = exports.qbx_core:GetPlayer(playerSrc)
  if not player then return end
  local playerEntity = Player(playerSrc)
  if not playerEntity then return end
  local stateValue = self.valueConfig.default
  if self.permanent then
    stateValue = self:validateValue(player.Functions.GetMetaData(self.id))
  end
  self.values[playerSrc] = stateValue
  playerEntity.state:set(self.id, stateValue, true)
end

function SVPlayerState:startDecayLoop()
  if not self.decayConfig then return end
  CreateThread(function()
    while true do
      Wait(self.decayConfig.interval)
      local players = exports.qbx_core:GetQBPlayers()
      for playerSrc, _ in pairs(players) do
        self:addToPlayerState(playerSrc, self.decayConfig.value)
      end
    end
  end)
end

--- @param playerSrc number
--- @param newValue number
function SVPlayerState:correctValue(playerSrc, newValue)
  if self.values[playerSrc] == newValue then return end
  self:setPlayerState(playerSrc, newValue)
end

return SVPlayerState
