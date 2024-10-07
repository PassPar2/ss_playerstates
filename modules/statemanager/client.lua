--- @class CLPlayerState
local CLPlayerState = require 'modules.playerstate.client'

local sharedConf = require 'config.shared'
local LOOP_INTERVAL <const> = 10000
local EFFECT_TIMEOUT <const> = 30000

--- @class CLStateManager
local CLStateManager = {}

--- @return CLStateManager instance
function CLStateManager:new()
  local instance = setmetatable({}, { __index = self })
  instance.states = {}
  return instance
end

--- @param stateConfig PlayerStateConfig
function CLStateManager:initState(stateConfig)
  if self.states[stateConfig.id] then
    print("State with id " .. stateConfig.id .. " already exists")
    return
  end
  self.states[stateConfig.id] = CLPlayerState:new(stateConfig)
  self.states[stateConfig.id]:init()
end

function CLStateManager:startCheckLoop()
  CreateThread(function()
    while true do
      Wait(LOOP_INTERVAL)
      if LocalPlayer.state.isLoggedIn and not LocalPlayer.state.isDead and not LocalPlayer.state.onEffect then
        for _, state in pairs(self.states) do
          local onEffect = state:checkState()
          if onEffect then
            LocalPlayer.state.onEffect = true
            SetTimeout(EFFECT_TIMEOUT, function()
              LocalPlayer.state.onEffect = false
            end)
            break
          end
        end
      end
    end
  end)
end

function CLStateManager:init()
  for _, stateConf in pairs(sharedConf) do
    self:initState(stateConf)
  end
  self:startCheckLoop()
end

return CLStateManager
