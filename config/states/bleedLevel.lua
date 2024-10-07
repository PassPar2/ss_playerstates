--- @type PlayerStateConfig
return {
  id = 'bleedLevel',
  label = 'Blood loss',
  permanent = false,
  value = {
    min = 0,
    max = 4,
    default = 0,
  },
  notification = {
    up = {
      id = 'state-bleedLevel-up-notif',
      title = 'Blood loss',
      description = 'You got hurt and are bleeding',
      duration = 2000,
      icon = 'tint',
      iconColor = '#C53030',
      style = {
        backgroundColor = '#141517',
        color = '#FFFFFF',
      },
      value = 1,
    },
    down = {
      id = 'state-bleedLevel-down-notif',
      title = 'Blood loss',
      description = 'You stopped bleeding',
      duration = 2000,
      icon = 'tint-slash',
      iconColor = '#4CAF50',
      style = {
        backgroundColor = '#141517',
        color = '#FFFFFF',
      },
      value = -1,
    },
  },
}
