--- @class SVStateManager
local SVStateManager = require 'modules.statemanager.server'

local stateManager = SVStateManager:new()
stateManager:init()

lib.callback.register('ss_playerstates:server:addToState', function(source, state, value)
  local src = source
  return stateManager:addToState(src, state, value)
end)

lib.callback.register('ss_playerstates:server:clearState', function(source, state)
  local src = source
  return stateManager:clearState(src, state)
end)

lib.callback.register('ss_playerstates:server:clearAllStates', function(source)
  local src = source
  return stateManager:clearAllStates(src)
end)

RegisterNetEvent("QBCore:Server:OnPlayerLoaded", function ()
  local src = source
  stateManager:initPlayerStates(src)
end)

AddEventHandler("QBCore:Server:OnPlayerUnload", function ()
  local src = source
  stateManager:resetPlayerStates(src)
end)

AddEventHandler('onResourceStart', function(resourceName)
  if resourceName == GetCurrentResourceName() then
    stateManager:initAllPlayersStates()
  end
end)

exports('SetPlayerState', function(src, state, value)
  return stateManager:setState(src, state, value)
end)

exports('AddToPlayerState', function(src, state, value)
  return stateManager:addToState(src, state, value)
end)
