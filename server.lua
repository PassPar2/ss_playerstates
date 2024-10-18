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

RegisterNetEvent('qbx_core:server:onSetMetaData', function(key, _, newValue, source)
  if not key or not newValue or not source then return end
  stateManager:correctStateValue(key, newValue, source)
end)

AddStateBagChangeHandler('', '', function(bagName, key, value)
  if not bagName or not key or not value then return end
  local playerSrc = GetPlayerFromStateBagName(bagName)
  if not playerSrc then return end
  stateManager:correctStateValue(key, value, playerSrc)
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
