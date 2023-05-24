fx_version 'cerulean'
game 'gta5'

client_script 'client.lua'
server_script '@oxmysql/lib/MySQL.lua'
server_script 'server.lua'
shared_scripts {
    'shared.lua',
    'config.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/index.js',
    'html/billing.js',
    'html/style.css',
    'html/yj.jpg'
}