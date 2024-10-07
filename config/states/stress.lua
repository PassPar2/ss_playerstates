--- @type PlayerStateConfig
return {
  id = 'stress',
  label = 'Stress',
  permanent = true,
  value = {
    min = 0,
    max = 100,
    default = 0,
  },
  notification = {
    up = {
      id = 'state-stress-up-notif',
      title = 'Stress',
      description = 'You feel stressed',
      duration = 1000,
      icon = 'brain',
      iconColor = '#C53030',
      style = {
        backgroundColor = '#141517',
        color = '#FFFFFF',
      },
      value = 2,
    },
    down = {
      id = 'state-stress-down-notif',
      title = 'Stress',
      description = 'You feel relaxed',
      duration = 1000,
      icon = 'brain',
      iconColor = '#4CAF50',
      style = {
        backgroundColor = '#141517',
        color = '#FFFFFF',
      },
      value = -2,
    },
  },
  -- custom effect data
  effectData = {
    speedStressWhitlistedJobs = {'ambulance', 'civilprotection'},
    stressSpeed = 30,
    speedStressRange = {min = 1, max = 3},
    speedStressInterval = 10000,
    whitelistedWeapons = {
      'weapon_petrolcan',
      'weapon_hazardcan',
      'weapon_fireextinguisher',
    },
    stressChance = 0.1,
    weaponStressRange = {min = 1, max = 5},
    minForShaking = 50,
    blurIntensity = {
      [1] = {min = 50, max = 60, intensity = 1500},
      [2] = {min = 60, max = 70, intensity = 2000},
      [3] = {min = 70, max = 80, intensity = 2500},
      [4] = {min = 80, max = 90, intensity = 2700},
      [5] = {min = 90, max = 100, intensity = 3000},
    },
    effectInterval = {
      [1] = {min = 50, max = 60, timeout = math.random(50000, 60000)},
      [2] = {min = 60, max = 70, timeout = math.random(40000, 50000)},
      [3] = {min = 70, max = 80, timeout = math.random(30000, 40000)},
      [4] = {min = 80, max = 90, timeout = math.random(20000, 30000)},
      [5] = {min = 90, max = 100, timeout = math.random(15000, 20000)},
    },
  },
}
