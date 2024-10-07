# Player States

## Overview

Player States is a FiveM resource designed for QBX Core framework that manages various player states such as stress, hunger, thirst, drug effects and more. It provides a flexible and extensible system for tracking and manipulating player states, with features like decay, notifications, and custom effects.

## Features

- Multiple player states (stress, hunger, thirst, THC, alcohol, meth, cocaine, bleed level, painkiller)
- Configurable state properties (min/max values, decay rates, notifications)
- Custom effects for each state (e.g., screen blur, camera shake, movement speed changes)
- Overdose and puke mechanics for applicable states
- Notification system for state changes
- Integration with QBX Core and ox_lib

## Dependencies

- qbx_core
- ox_lib

## Installation

1. Ensure you have QBX Core and ox_lib installed and configured in your FiveM server.
2. Clone or download this repository.
3. Place the `ss_playerstates` folder in your FiveM `resources` directory.
4. Add `ensure ss_playerstates` to your `server.cfg` file.

## Usage

### Client-side

To modify a player's state from the client-side:

```lua
exports.ss_playerstates:AddToState('hunger', 10)  -- Increases hunger by 10
exports.ss_playerstates:ClearState('stress')      -- Resets stress to default value
exports.ss_playerstates:ClearAllStates()          -- Resets all states to default values
```

### Server-side

To modify a player's state from the server-side:

```lua
exports.ss_playerstates:SetPlayerState(playerId, 'thirst', 50)  -- Sets thirst to 50
exports.ss_playerstates:AddToPlayerState(playerId, 'alcohol', 5)  -- Increases alcohol by 5
```

## Configuration

Each state is configured in its own file within the `config/states` directory. Here's an example configuration for the hunger state:

```lua
return {
  id = 'hunger',
  label = 'Hunger',
  permanent = true,
  decay = {
    interval = 60*1000,
    value = -2,
  },
  value = {
    min = 0,
    max = 100,
    default = 100,
  },
  notification = {
    up = {
      id = 'state-hunger-up-notif',
      title = 'Hunger',
      description = 'You relieved your hunger',
      duration = 2000,
      icon = 'drumstick-bite',
      iconColor = '#4CAF50',
      style = {
        backgroundColor = '#141517',
        color = '#FFFFFF',
      },
      value = 50,
    },
    down = {
      id = 'state-hunger-down-notif',
      title = 'Hunger',
      description = 'You feel hungry',
      duration = 1000,
      icon = 'bone',
      iconColor = '#C53030',
      style = {
        backgroundColor = '#141517',
        color = '#FFFFFF',
      },
      value = -10,
    },
  },
  effectData = {
    statusInterval = 60*1000,
    decreaseHealthRange = {min = 5, max = 10},
  },
}
```

## Project Structure

The resource is structured as follows:

```
ss_playerstates/
├── client.lua
├── server.lua
├── fxmanifest.lua
├── config/
│   ├── shared.lua
│   └── states/
│       ├── alcohol.lua
│       ├── bleedLevel.lua
│       ├── cocaine.lua
│       ├── hunger.lua
│       ├── meth.lua
│       ├── painkiller.lua
│       ├── stress.lua
│       ├── thc.lua
│       └── thirst.lua
├── client/
│   ├── alcohol.lua
│   ├── cocaine.lua
│   ├── hunger.lua
│   ├── meth.lua
│   ├── painkiller.lua
│   ├── stress.lua
│   ├── thc.lua
│   └── thirst.lua
└── modules/
    ├── playerstate/
    │   ├── client.lua
    │   └── server.lua
    └── statemanager/
        ├── client.lua
        └── server.lua
```

- `client.lua` and `server.lua`: Main entry points for client-side and server-side code.
- `config/`: Contains configuration files for each state and shared configurations.
- `client/`: Contains individual client-side scripts for each state, implementing custom effects and behaviors.
- `modules/`: Contains the core functionality of the resource.
  - `playerstate/`: Defines the PlayerState class for both client and server.
  - `statemanager/`: Implements the StateManager class for managing multiple player states.

## Custom Effects

Custom effects for each state are implemented in individual files within the `client/` folder. Here's an example of how the hunger effect is implemented in `client/hunger.lua`:

```lua
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
```

Each state's custom effects and behaviors are encapsulated in their respective files within the `client/` folder, allowing for better organization and modularity.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.
