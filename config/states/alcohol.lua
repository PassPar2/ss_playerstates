--- @type PlayerStateConfig
local alcoholStateConfig = {
  id = 'alcohol',
  label = 'alcohol',
  permanent = false,
  value = {
    min = 0,
    max = 100,
    default = 0,
  },
  decay = {
    interval = 60*1000,
    value = -2,
  },
  puke = {
    chance = 10,
    threshold = 40,
  },
  overdose = {
    chance = 10,
    threshold = 60,
  },
  clear = {
    swimming = true,
  },
  effectData = {
    interval = 60*1000,
    levels = {
      {min = 20, duration = 10000, intensity = 1, message = 'You feel a little drunk'},
      {min = 30, duration = 20000, intensity = 2, message = 'You feel drunk'},
      {min = 40, duration = 30000, intensity = 3, message = 'You feel very drunk'},
      {min = 50, duration = 40000, intensity = 4, message = 'You feel extremely drunk'},
      {min = 60, duration = 50000, intensity = 5, message = 'You are completely wasted'},
    },
  },
}

return alcoholStateConfig
