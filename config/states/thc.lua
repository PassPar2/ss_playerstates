--- @type PlayerStateConfig
return {
  id = 'thc',
  label = 'Tetrahydrocannabinol',
  permanent = false,
  value = {
    min = 0,
    max = 100,
    default = 0,
  },
  decay = {
    interval = 5*60*1000,
    value = -10,
  },
  puke = {
    chance = 10,
    threshold = 50,
  },
  overdose = {
    chance = 0,
    checkInterval = 5*60*1000,
    threshold = 100,
  },
  clear = {
    swimming = true,
  },
  -- custom effect data
  effectData = {
    interval = 60*1000,
    levels = {
      {min = 10, duration = 10000, intensity = 1, message = 'You feel a little high'},
      {min = 30, duration = 20000, intensity = 2, message = 'You feel high'},
      {min = 50, duration = 30000, intensity = 3, message = 'You feel very high'},
      {min = 70, duration = 40000, intensity = 4, message = 'You feel extremely high'},
      {min = 90, duration = 50000, intensity = 5, message = 'You feel like you are in space'},
    },
  },
}
