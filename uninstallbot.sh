#!/bin/bash
#
#usage: 
#sudo ./uninstallbot.sh BotFolderName
#
botuser="corrade"
#ls /home/$botuser/ #to get your BotFolderName
BotFolderName=$1
#
sudo monit stop $botuser$BotFolderName 
sudo -u $botuser /etc/init.d/$botuser$BotFolderName stop
sudo rm /etc/monit/conf.d/$botuser$BotFolderName  
sudo rm /etc/init.d/$botuser$BotFolderName 
sudo rm -r /home/$botuser/$BotFolderName
sudo service monit restart
sudo monit status
sudo kill -9 $(ps ax | grep "mono-serv" | grep "usr/bin/mono" | grep $BotFolderName"/Corrade.exe.lock" | awk '{print $1;}' | head -n 1)
