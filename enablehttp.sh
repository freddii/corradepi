#!/bin/bash
#
#usage: 
#sudo ./enablehttp.sh BotFolderName port
#
BotFolderName=$1
Port=$2
localip=$(hostname -I | awk '{print $1}')
url="http://"$localip":$Port/"
botuser="corrade"
#for progressive(9.x)
sudo xmlstarlet edit --inplace --update 'Configuration/HTTPServerPrefix' --value $url /home/$botuser/$BotFolderName/Corrade.ini
sudo xmlstarlet edit --inplace --update 'Configuration/EnableHTTPServer' --value 'true' /home/$botuser/$BotFolderName/Corrade.ini
#for conservative (7.x)
sudo xmlstarlet edit --inplace --update 'config/server/prefix' --value $url /home/$botuser/$BotFolderName/Corrade.ini
sudo xmlstarlet edit --inplace --update 'config/server/http' --value 'true' /home/$botuser/$BotFolderName/Corrade.ini
echo "done  setting up httpserver on $url"
echo "example:"
echo 'curl -d "command=version&group=<groupid>&password=<password>" '$url
