local thcConfig = require 'config.states.thc'
local thcEffectData = thcConfig.effectData or {}

local function getThcLevel()
  local playerThc = LocalPlayer.state.thc or thcConfig.value.default
  local currentLevel = nil
  for _, level in pairs(thcEffectData.levels) do
    if playerThc >= level.min then
      currentLevel = level
    end
  end
  return currentLevel
end

local function applyThcEffect(level)
  LocalPlayer.state.onEffect = true
  lib.notify({description = level.message})
  SetTimecycleModifier("spectator6")
  SetPedMotionBlur(cache.ped, true)
  AnimpostfxPlay("ChopVision", level.duration + 1, true)
  ShakeGameplayCam("DRUNK_SHAKE", level.intensity)
  local speedRate = 1.0 / level.intensity
  SetPedMoveRateOverride(cache.ped, speedRate)
  SetRunSprintMultiplierForPlayer(cache.playerId, speedRate)
  Wait(level.duration)
  SetPedMoveRateOverride(cache.ped, 1.0)
  SetRunSprintMultiplierForPlayer(cache.playerId, 1.0)
  SetPedMotionBlur(cache.ped, false)
  AnimpostfxStop("ChopVision")
  ShakeGameplayCam("DRUNK_SHAKE", 0.0)
  ClearTimecycleModifier()
  LocalPlayer.state.onEffect = false
end

CreateThread(function()
  while true do
    if LocalPlayer.state.isLoggedIn and not LocalPlayer.state.isDead and not LocalPlayer.state.onEffect then
      local thcLevel = getThcLevel()
      if thcLevel then
        SetTimeout(10, function()
          applyThcEffect(thcLevel)
        end)
      end
    end
    Wait(thcEffectData.interval)
  end
end)
