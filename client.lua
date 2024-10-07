--- @class CLStateManager
local CLStateManager = require 'modules.statemanager.client'

local stateManager = CLStateManager:new()
stateManager:init()

local function addToState(state, value)
  return lib.callback.await('ss_playerstates:server:addToState', false, state, value)
end
exports('AddToState', addToState)

local function clearState(state)
  return lib.callback.await('ss_playerstates:server:clearState', false, state)
end
exports('ClearState', clearState)

local function clearAllStates()
  return lib.callback.await('ss_playerstates:server:clearAllStates', false)
end
exports('ClearAllStates', clearAllStates)
