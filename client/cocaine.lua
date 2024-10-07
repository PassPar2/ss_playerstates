local cocaineConfig = require 'config.states.cocaine'
local cocaineEffectData = cocaineConfig.effectData
if not cocaineEffectData then return end

local function getCocaineLevel()
  local playerCocaine = LocalPlayer.state.cocaine or cocaineConfig.value.default
  local currentLevel = nil
  for _, level in pairs(cocaineEffectData.levels) do
    if playerCocaine >= level.min then
      currentLevel = level
    end
  end
  return currentLevel
end

local function applyCocaineEffect(level)
  LocalPlayer.state.onEffect = true
  lib.notify({description = level.message})
  AnimpostfxPlay("DrugsTrevorClownsFightIn", 3.0, true)
  Wait(3000)
  AnimpostfxPlay("DrugsTrevorClownsFight", level.duration + 1, true)
  Wait(level.duration)
  AnimpostfxPlay("DrugsTrevorClownsFightOut", 3.0, true)
  AnimpostfxStop("DrugsTrevorClownsFight")
  AnimpostfxStop("DrugsTrevorClownsFightIn")
  AnimpostfxStop("DrugsTrevorClownsFightOut")
  LocalPlayer.state.onEffect = false
end

CreateThread(function()
  while true do
    if LocalPlayer.state.isLoggedIn and not LocalPlayer.state.isDead and not LocalPlayer.state.onEffect then
      local cocaineLevel = getCocaineLevel()
      if cocaineLevel then
        SetTimeout(10, function()
          applyCocaineEffect(cocaineLevel)
        end)
      end
    end
    Wait(cocaineEffectData.interval)
  end
end)
