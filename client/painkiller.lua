local painDisabled = false

local function disablePain()
  if not painDisabled then
    painDisabled = true
    exports.ss_medical:DisableDamageEffects()
    exports.qbx_core:Notify('Painkillers effects have started', 'info')
  end
end

local function enablePain()
  if painDisabled then
    painDisabled = false
    exports.ss_medical:EnableDamageEffects()
    exports.qbx_core:Notify('Painkillers effects have ended', 'info')
  end
end

CreateThread(function()
  while true do
    Wait(10 * 1000)
    if LocalPlayer.state.isLoggedIn and not LocalPlayer.state.isDead then
      if LocalPlayer.state.painkiller then
        if LocalPlayer.state.painkiller > 0 then
          disablePain()
        else
          enablePain()
        end
      else
        enablePain()
      end
    end
  end
end)
