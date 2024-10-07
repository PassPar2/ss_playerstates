--- @type PlayerStateConfig
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
