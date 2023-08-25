#!/bin/bash
#
#usage: 
#sudo ./disablebot.sh BotFolderName
#
BotFolderName=$1
botuser="corrade"
sudo monit stop $botuser$BotFolderName
sudo -u $botuser /etc/init.d/$botuser$BotFolderName stop
sudo mv /etc/init.d/$botuser$BotFolderName /home/$botuser/$BotFolderName/InitD_$botuser$BotFolderName
sudo mv /etc/monit/conf.d/$botuser$BotFolderName /home/$botuser/$BotFolderName/Monit_$botuser$BotFolderName
sudo service monit restart
sudo monit status
#kill $(sudo cat /home/$botuser/$BotFolderName/Corrade.exe.lock)
#sudo reboot
sudo kill -9 $(ps ax | grep "mono-serv" | grep "usr/bin/mono" | grep $BotFolderName"/Corrade.exe.lock" | awk '{print $1;}' | head -n 1)

#Port=808x
#sudo kill -9 $(ps ax | grep "xsp4.exe" | grep "usr/bin/mono" | grep $Port | awk '{print $1;}' | head -n 1)
