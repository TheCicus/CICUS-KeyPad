-- Generated automaticly by RB Generator.
fx_version('cerulean')
games({ 'gta5' })

author 'CICUS DEVELOPMENT'

description 'CICUS_KeyPad, Sistema innovativo di doorlock'

version '1.0'


shared_script('config.lua');

client_scripts({
    "client/animations.lua",
    "client/function.lua",
    "client/main.lua"
});

server_scripts({
    "server.lua"
});

dependencies {
	'es_extended',
	'cicus_lib'
}
