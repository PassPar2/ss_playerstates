local thirstConfig = require 'config.states.thirst'
local thirstEffectData = thirstConfig.effectData
if not thirstEffectData then return end

local statusInterval = thirstEffectData.statusInterval
local decreaseHealthRange = thirstEffectData.decreaseHealthRange

CreateThread(function()
  while true do
    Wait(statusInterval)
    if LocalPlayer.state.isLoggedIn and not LocalPlayer.state.isDead then
      local thirst = LocalPlayer.state.thirst or thirstConfig.value.default
      if thirst <= 0 then
        local currentHealth = GetEntityHealth(cache.ped)
        local decreaseThreshold = math.random(decreaseHealthRange.min, decreaseHealthRange.max)
        SetEntityHealth(cache.ped, currentHealth - decreaseThreshold)
      end
    end
  end
end)
