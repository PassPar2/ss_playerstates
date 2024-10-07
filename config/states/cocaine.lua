--- @type PlayerStateConfig
return {
  id = 'cocaine',
  label = 'Cocaine',
  permanent = false,
  value = {
    min = 0,
    max = 100,
    default = 0,
  },
  decay = {
    interval = 60*1000,
    value = -15,
  },
  puke = {
    chance = 0,
    threshold = 100,
  },
  overdose = {
    chance = 100,
    checkInterval = 1*60*1000,
    threshold = 70,
  },
  clear = {
    swimming = true,
  },
  -- custom effect data
  effectData = {
    interval = 60*1000,
    levels = {
      {min = 10, duration = 10000, intensity = 1, message = 'You feel a little euphoria'},
      {min = 20, duration = 20000, intensity = 2, message = 'You feel euphoric'},
      {min = 30, duration = 30000, intensity = 3, message = 'You feel very euphoric'},
      {min = 40, duration = 40000, intensity = 4, message = 'You feel extremely euphoric'},
      {min = 50, duration = 50000, intensity = 5, message = 'You feel like you are in space'},
    },
  },
}
