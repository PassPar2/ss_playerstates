local methConfig = require 'config.states.meth'
local methEffectData = methConfig.effectData
if not methEffectData then return end

local function getMethLevel()
  local playerMeth = LocalPlayer.state.meth or methConfig.value.default
  local currentLevel = nil
  for _, level in pairs(methEffectData.levels) do
    if playerMeth >= level.min then
      currentLevel = level
    end
  end
  return currentLevel
end

local function applyMethEffect(level)
  LocalPlayer.state.onEffect = true
  lib.notify({description = level.message})
  AnimpostfxPlay('RaceTurbo', level.duration + 1, true)
  SetTimecycleModifier('rply_motionblur')
  ShakeGameplayCam('SKY_DIVING_SHAKE', level.intensity)
  Wait(level.duration)
  StopGameplayCamShaking(true)
  SetTransitionTimecycleModifier('default', 0.35)
  Wait(1000)
  ClearTimecycleModifier()
  AnimpostfxStop('RaceTurbo')
  LocalPlayer.state.onEffect = false
end

CreateThread(function()
  while true do
    if LocalPlayer.state.isLoggedIn and not LocalPlayer.state.isDead and not LocalPlayer.state.onEffect then
      local methLevel = getMethLevel()
      if methLevel then
        SetTimeout(10, function()
          applyMethEffect(methLevel)
        end)
      end
    end
    Wait(methEffectData.interval)
  end
end)
