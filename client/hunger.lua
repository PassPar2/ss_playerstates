local hungerConfig = require 'config.states.hunger'
local hungerEffectData = hungerConfig.effectData
if not hungerEffectData then return end

local statusInterval = hungerEffectData.statusInterval
local decreaseHealthRange = hungerEffectData.decreaseHealthRange

CreateThread(function()
  while true do
    Wait(statusInterval)
    if LocalPlayer.state.isLoggedIn and not LocalPlayer.state.isDead then
      local hunger = LocalPlayer.state.hunger or hungerConfig.value.default
      if hunger <= 0 then
        local currentHealth = GetEntityHealth(cache.ped)
        local decreaseThreshold = math.random(decreaseHealthRange.min, decreaseHealthRange.max)
        SetEntityHealth(cache.ped, currentHealth - decreaseThreshold)
      end
    end
  end
end)
