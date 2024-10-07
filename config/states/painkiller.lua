--- @type PlayerStateConfig
return {
  id = 'painkiller',
  label = 'Pain Killer Effect',
  permanent = false,
  value = {
    min = 0,
    max = 10,
    default = 0,
  },
  decay = {
    interval = 30*1000,
    value = -1,
  },
  overdose = {
    chance = 100,
    checkInterval = 10*1000,
    threshold = 8,
  },
}
