-- Stress Gain : Speeding
local stressConfig = require 'config.states.stress'
local stressData = stressConfig.effectData or {}

local stressSpeed = stressData.stressSpeed
local speedStressRange = stressData.speedStressRange
local speedStressInterval = stressData.speedStressInterval

local function isSpeedStressWhitelistedJob()
  local playerJob = QBX.PlayerData.job.name
  for _, v in pairs(stressData.speedStressWhitlistedJobs) do
    if playerJob == v then
      return true
    end
  end
  return false
end

CreateThread(function()
  while true do
    if LocalPlayer.state.isLoggedIn and not isSpeedStressWhitelistedJob() and not LocalPlayer.state.isDead then
      if cache.vehicle then
        local vehClass = GetVehicleClass(cache.vehicle)
        local speed = GetEntitySpeed(cache.vehicle)
        if vehClass ~= 13 and vehClass ~= 14 and vehClass ~= 15 and vehClass ~= 16 and vehClass ~= 21 then
          if speed >= stressSpeed then
            exports.ss_playerstates:AddToState('stress', math.random(speedStressRange.min, speedStressRange.max))
          end
        end
      end
    end
    Wait(speedStressInterval)
  end
end)

-- Stress Gain : Shooting
local hasWeapon = false
local whitelistedWeapons = stressData.whitelistedWeapons
local stressChance = stressData.stressChance
local weaponStressRange = stressData.weaponStressRange

local function isWhitelistedWeaponStress(weapon)
  if weapon then
    for _, v in pairs(whitelistedWeapons) do
      if
        type(v) == 'string' and
        type(weapon) == 'string' and
        weapon:lower() == v:lower()
      then
        return true
      end
    end
  end
  return false
end

local function startWeaponStressThread(weapon)
  if isWhitelistedWeaponStress(weapon) then return end
  hasWeapon = true
  CreateThread(function()
    while hasWeapon and not LocalPlayer.state.isDead do
      if IsPedShooting(cache.ped) then
        if math.random() <= stressChance then
          exports.ss_playerstates:AddToState('stress', math.random(weaponStressRange.min, weaponStressRange.max))
        end
      end
      Wait(0)
    end
  end)
end

AddEventHandler('ox_inventory:currentWeapon', function(currentWeapon)
  hasWeapon = false
  Wait(0)
  if not currentWeapon then return end
  startWeaponStressThread(currentWeapon.name)
end)

-- Stress Effects --

local minForShaking = stressData.minForShaking
local blurIntensity = stressData.blurIntensity
local effectInterval = stressData.effectInterval

local function getBlurIntensity(stresslevel)
  for _, v in pairs(blurIntensity) do
    if stresslevel >= v.min and stresslevel <= v.max then
      return v.intensity
    end
  end
  return 1500
end

local function getEffectInterval(stresslevel)
  for _, v in pairs(effectInterval) do
    if stresslevel >= v.min and stresslevel <= v.max then
      return v.timeout
    end
  end
  return 60000
end

CreateThread(function()
  while true do
    if LocalPlayer.state.isLoggedIn and not LocalPlayer.state.isDead and not LocalPlayer.state.onEffect then
      local stress = LocalPlayer.state.stress or stressConfig.value.default
      local effectWaitInterval = getEffectInterval(stress)
      if stress >= stressConfig.value.max then
        LocalPlayer.state.onEffect = true
        local blurIntensityInterval = getBlurIntensity(stress)
        local fallRepeat = math.random(2, 4)
        local ragdollTimeout = fallRepeat * 1750
        TriggerScreenblurFadeIn(1000.0)
        Wait(blurIntensityInterval)
        TriggerScreenblurFadeOut(1000.0)
        if not IsPedRagdoll(cache.ped) and IsPedOnFoot(cache.ped) and not IsPedSwimming(cache.ped) then
          local forwardVector = GetEntityForwardVector(cache.ped)
          SetPedToRagdollWithFall(cache.ped, ragdollTimeout, ragdollTimeout, 1, forwardVector.x, forwardVector.y, forwardVector.z, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        end
        Wait(1000)
        for _ = 1, fallRepeat, 1 do
          Wait(750)
          DoScreenFadeOut(200)
          Wait(1000)
          DoScreenFadeIn(200)
          TriggerScreenblurFadeIn(1000.0)
          Wait(blurIntensityInterval)
          TriggerScreenblurFadeOut(1000.0)
        end
        LocalPlayer.state.onEffect = false
      elseif stress >= minForShaking then
        LocalPlayer.state.onEffect = true
        local blurIntensityInterval = getBlurIntensity(stress)
        TriggerScreenblurFadeIn(1000.0)
        Wait(blurIntensityInterval)
        TriggerScreenblurFadeOut(1000.0)
        LocalPlayer.state.onEffect = false
      end
      Wait(effectWaitInterval)
    else
      Wait(1000)
    end
  end
end)
