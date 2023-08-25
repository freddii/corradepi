#!/bin/bash
#
#usage: 
#sudo ./enablebot.sh BotFolderName
#
BotFolderName=$1
botuser="corrade"
sudo mv /home/$botuser/$BotFolderName/InitD_$botuser$BotFolderName /etc/init.d/$botuser$BotFolderName && sudo update-rc.d $botuser$BotFolderName defaults
sudo mv /home/$botuser/$BotFolderName/Monit_$botuser$BotFolderName /etc/monit/conf.d/$botuser$BotFolderName
sudo service monit restart
sudo monit status
#sudo reboot
