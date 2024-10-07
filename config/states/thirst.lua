--- @type PlayerStateConfig
return {
  id = 'thirst',
  label = 'Thirst',
  permanent = true,
  value = {
    min = 0,
    max = 100,
    default = 100,
  },
  decay = {
    interval = 60*1000,
    value = -2,
  },
  notification = {
    up = {
      id = 'state-thirst-up-notif',
      title = 'Thirst',
      description = 'You relieved your thirst',
      duration = 2000,
      icon = 'wine-glass',
      iconColor = '#4CAF50',
      style = {
        backgroundColor = '#141517',
        color = '#FFFFFF',
      },
      value = 50,
    },
    down = {
      id = 'state-thirst-down-notif',
      title = 'Thirst',
      description = 'You feel thirsty',
      duration = 1000,
      icon = 'wine-glass-empty',
      iconColor = '#C53030',
      style = {
        backgroundColor = '#141517',
        color = '#FFFFFF',
      },
      value = -10,
    },
  },
  effectData = {
    statusInterval = 5*1000,
    decreaseHealthRange = {min = 5, max = 10},
  },
}
