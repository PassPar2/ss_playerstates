local alcoholEffect= require 'config.states.alcohol'
local alcoholEffectData = alcoholEffect.effectData or {}

local function getAlcoholLevel()
  local playerAlcohol = LocalPlayer.state.alcohol or 0
  local currentLevel = nil
  for _, level in pairs(alcoholEffectData.levels) do
    if playerAlcohol >= level.min then
      currentLevel = level
    end
  end
  return currentLevel
end

local function applyAlcoholEffect(level)
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
  SetTimecycleModifierStrength(0.0)
  ClearTimecycleModifier()
  LocalPlayer.state.onEffect = false
end

CreateThread(function()
  while true do
    if LocalPlayer.state.isLoggedIn and not LocalPlayer.state.isDead and not LocalPlayer.state.onEffect then
      local alcoholLevel = getAlcoholLevel()
      if alcoholLevel then
        SetTimeout(10, function()
          applyAlcoholEffect(alcoholLevel)
        end)
      end
    end
    Wait(alcoholEffectData.interval)
  end
end)
