--- @type table<string, PlayerStateConfig>
local allStates = {}
allStates.stress = require 'config.states.stress'
allStates.hunger = require 'config.states.hunger'
allStates.thirst = require 'config.states.thirst'
allStates.thc = require 'config.states.thc'
allStates.alcohol = require 'config.states.alcohol'
allStates.meth = require 'config.states.meth'
allStates.cocaine = require 'config.states.cocaine'
allStates.bleedLevel = require 'config.states.bleedLevel'
allStates.painkiller = require 'config.states.painkiller'

return allStates
