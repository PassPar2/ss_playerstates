--- @class SVPlayerState
local SVPlayerState = require 'modules.playerstate.server'

local sharedConf = require 'config.shared'

--- @class SVStateManager
local SVStateManager = {}

--- @return SVStateManager instance
function SVStateManager:new()
  local instance = setmetatable({}, { __index = self })
  instance.states = {}
  return instance
end

--- @param stateConfig PlayerStateConfig
function SVStateManager:addState(stateConfig)
  if self.states[stateConfig.id] then
    print("State with id " .. stateConfig.id .. " already exists")
    return
  end
  self.states[stateConfig.id] = SVPlayerState:new(stateConfig)
end

function SVStateManager:startDecayLoops()
  for _, state in pairs(self.states) do
    state:startDecayLoop()
  end
end

function SVStateManager:init()
  for _, stateConf in pairs(sharedConf) do
    self:addState(stateConf)
  end
  self:startDecayLoops()
end

--- @param src any
--- @param state any
--- @param value any
--- @return boolean
function SVStateManager:addToState(src, state, value)
  if not src or not state or not value then return false end
  if not type(src) == 'number' or not type(state) == 'string' or not type(value) == 'number' then return false end
  local stateInstance = self.states[state]
  if not stateInstance then return false end
  return stateInstance:addToPlayerState(src, value)
end

--- @param src any
--- @param state any
--- @return boolean
function SVStateManager:clearState(src, state)
  if not src or not state then return false end
  if not type(src) == 'number' or not type(state) == 'string' then return false end
  local stateInstance = self.states[state]
  if not stateInstance then return false end
  return stateInstance:clearPlayerState(src)
end

--- @param src any
--- @return boolean
function SVStateManager:clearAllStates(src)
  if not src then return false end
  if not type(src) == 'number' then return false end
  for _, state in pairs(self.states) do
    state:clearPlayerState(src)
  end
  return true
end

--- @param src any
function SVStateManager:initPlayerStates(src)
  if not src then return end
  if not type(src) == 'number' then return end
  for _, state in pairs(self.states) do
    state:initPlayerState(src)
  end
end

--- @param src any
function SVStateManager:resetPlayerStates(src)
  if not src then return end
  if not type(src) == 'number' then return end
  for _, state in pairs(self.states) do
    state:destroyPlayerState(src)
  end
end

function SVStateManager:initAllPlayersStates()
  local players = exports.qbx_core:GetQBPlayers()
  for playerSrc, _ in pairs(players) do
    self:initPlayerStates(playerSrc)
  end
end

--- @param src any
--- @param state any
--- @param value any
--- @return boolean
function SVStateManager:setState(src, state, value)
  if not src or not state or not value then return false end
  if not type(src) == 'number' or not type(state) == 'string' or not type(value) == 'number' then return false end
  local stateInstance = self.states[state]
  if not stateInstance then return false end
  return stateInstance:setPlayerState(src, value)
end

--- @param key any
--- @param value any
--- @param src any
function SVStateManager:correctStateValue(key, value, src)
  if not key or not value or not src then return end
  local stateInstance = self.states[key]
  if not stateInstance then return end
  stateInstance:correctValue(src, value)
end

return SVStateManager
