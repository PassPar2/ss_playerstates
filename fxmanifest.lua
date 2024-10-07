fx_version 'cerulean'
game 'gta5'

author 'SaharaScripters'
description 'Player States'
version '1.0.0'

shared_script '@ox_lib/init.lua'

client_scripts {
	'@qbx_core/modules/playerdata.lua',
	'client.lua',
	'client/*.lua',
}

server_scripts {
	'server.lua'
}

files {
	'config/states/*.lua',
	'config/shared.lua',
	'modules/**/client.lua',
}

dependencies {
	'ox_lib',
	'qbx_core',
}

lua54 'yes'
