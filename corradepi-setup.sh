#!/bin/bash
#
#usage: 
#sudo ./corradepi-setup.sh BotFolderName BotFirstName BotLastName 'BotPassword' MasterFirstName MasterLastName 'GroupName' GroupUUID 'GroupPassword' CorradeZipfileName
#sudo ./corradepi-setup.sh bot3 Mybot Resident botspassword Philipp Linden 'SL lsl Scripters Network' 2923bf6f-7336-ba9a-b827-b6453c85cfc4 'mygoodpassword' corrade-7.115.zip
#
botuser="corrade"  #user that will be created to operate the bot
#
#
BotFolderName=$1   #for example: "MyFirstBot"
BotFirstName=$2   #for example: "Mypersonalbot"
BotLastName=$3   #for example: "Resident"
BotPassword=$(echo -n "$4" | md5sum | cut -d ' ' -f 1)
MasterFirstName=$5   #for example: "Philip"
MasterLastName=$6   #for example: "Linden"
GroupName=$7
GroupNameFixed=group_$(echo "$GroupName" | sed 's/[^a-zA-Z0-9]//g')
GroupUUID=$8
GroupPassword=$9
CorradeDownloadPath="https://raw.githubusercontent.com/freddii/Corrade-New/master/"
#CorradeDownloadPath="/home/pi" #offline fix
CorradeZipfileName="${10}"  #for example: "corrade-7.115.zip"
#
pathtologfile=/home/$botuser/install$BotFolderName.log
#
has() {
  [[ -x "$(command -v "$1")" ]];
}
#
#
has_not() {
  ! has "$1" ;
}
#
#
check_install() {
if has_not $1; then
  echo "installing $1 "
  sudo apt-get install $1 -y
  else
  echo "already installed $1 "
fi
}
#
#
function_start () {
   echo "===starting $1"
   echo "===starting $1" >> $pathtologfile
   date
   date >> $pathtologfile
}
#
function_end () {
   echo "=======done $1"
   echo "=======done $1" >> $pathtologfile
   date
   date >> $pathtologfile
}
#
#
#download_file(){
#  pathtothisscript="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#  cd $pathtothisscript
#  file_link=$1
#  file_link_name="${file_link##*/}"
#if [ ! -f "$pathtothisscript/$file_link_name" ]; then
#  function_start "Begin downloading $1"
#  #wget $file_link >> $pathtologfile
#  cp $file_link $pathtothisscript #offline fix
#  chmod +x $file_link_name
#  function_end "downloaded $1"
#  else
#  function_end "already existing file $file_link_name"
#fi
#}
#
# create the user based on the variable botuser you setup at the beginning of the script and create its homedir
   useradd $botuser
   echo $botuser':goodusersecret' | sudo chpasswd
   mkhomedir_helper $botuser
#   usermod -a -G 1000,4,20,24,27,29,44,46,60,100,101,108,997,998,999 $botuser  #was in an instruction for progressive 9.x, not tested yet
   sudo -u $botuser touch $pathtologfile
function_end "creating logfile"
#
#
#function_start "downloading files"
#   download_file https://raw.githubusercontent.com/freddii/corradepi/master/disablebot.sh >> $pathtologfile #/home/pi/programs_setup/corradepi #offline fix
#   download_file https://raw.githubusercontent.com/freddii/corradepi/master/enablebot.sh >> $pathtologfile
#   download_file https://raw.githubusercontent.com/freddii/corradepi/master/uninstallbot.sh >> $pathtologfile
#   download_file https://raw.githubusercontent.com/freddii/corradepi/master/uninstallcorradepi.sh >> $pathtologfile
#   download_file https://raw.githubusercontent.com/freddii/corradepi/master/enablehttp.sh >> $pathtologfile
#   download_file https://raw.githubusercontent.com/freddii/corradepi/master/log2imv2.sh >> $pathtologfile
#function_end "downloading files"
#
#
function_start "update"
   apt-get update >> $pathtologfile
function_end "update"
#
#
function_start "install mono-complete"
   check_install mono-complete >> $pathtologfile 
function_end "install mono-complete"
#
#
function_start "install unp"
   check_install unp >> $pathtologfile
function_end "install unp"
#
#
function_start "get corrade and unzip it and rename the folder"
   cd /home/$botuser/
   sudo -u $botuser wget $CorradeDownloadPath/$CorradeZipfileName >> $pathtologfile
#   sudo -u $botuser cp $CorradeDownloadPath/$CorradeZipfileName /home/$botuser/ #offline fix
   check_install unzip
   sudo -u $botuser unp corrade*.zip >> $pathtologfile
   rm corrade*.zip
   sudo -u $botuser mv Corrade $BotFolderName
function_end "get corrade and unzip it and rename the folder"
#
#
function_start "create a database folder and others"
   mkdir -pv /home/$botuser/$BotFolderName/logs/{region,local,im,groupchat}
   mkdir /home/$botuser/$BotFolderName/cache
   mkdir /home/$botuser/$BotFolderName/databases
function_end "create a database folder and others"
#
#
function_start "make the user the owner of all files"
   sudo chown -R $botuser:$botuser /home/$botuser/$BotFolderName/*
function_end "make the user the owner of all files"
#
#
function_start "install xmlstarlet"
   check_install xmlstarlet >> $pathtologfile
function_end "install xmlstarlet"
#
#
function_start "setup the Corrade.ini for conservative" #for conservative 7.x
   cd /home/$botuser/$BotFolderName/
   xmlstarlet edit --inplace --update 'config/client/firstname' --value $BotFirstName Corrade.ini
   xmlstarlet edit --inplace --update 'config/client/lastname' --value $BotLastName Corrade.ini
   xmlstarlet edit --inplace --update 'config/client/password' --value \$1\$$BotPassword Corrade.ini
   xmlstarlet edit --inplace --update 'config/client/tosaccepted' --value 'true' Corrade.ini
   xmlstarlet edit --inplace --update 'config/limits/range' --value '0' Corrade.ini
   xmlstarlet edit --inplace --delete "config/groups/group[name='Lucky Stars']" Corrade.ini
   xmlstarlet edit --inplace --update 'config/groups/group/name' --value "$GroupName" Corrade.ini
   xmlstarlet edit --inplace --update 'config/groups/group/uuid' --value $GroupUUID Corrade.ini
   xmlstarlet edit --inplace --update 'config/groups/group/password' --value "$GroupPassword" Corrade.ini
   xmlstarlet edit --inplace --update 'config/groups/group/chatlog/file' --value 'logs/groupchat/'$GroupNameFixed'.log' Corrade.ini
   xmlstarlet edit --inplace --update 'config/groups/group/database' --value 'databases/'$GroupNameFixed'.db' Corrade.ini
   xmlstarlet edit --inplace --delete "config/masters/agent[firstname='Laynnage']" Corrade.ini
   xmlstarlet edit --inplace --update "config/masters/agent[firstname='Swiak']/firstname" --value $MasterFirstName Corrade.ini
   xmlstarlet edit --inplace --update "config/masters/agent[lastname='Oado']/lastname" --value $MasterLastName Corrade.ini
   cd ..
function_end "setup the Corrade.ini for conservative"
#
#
function_start "setup the Corrade.ini for progressive" #for progressive 9.x
   cd /home/$botuser/$BotFolderName/
   sudo -u $botuser cp Corrade.ini.default Corrade.ini
   xmlstarlet edit --inplace --update 'Configuration/FirstName' --value $BotFirstName Corrade.ini
   xmlstarlet edit --inplace --update 'Configuration/LastName' --value $BotLastName Corrade.ini
   xmlstarlet edit --inplace --update 'Configuration/Password' --value \$1\$$BotPassword Corrade.ini
   xmlstarlet edit --inplace --update 'Configuration/TOSAccepted' --value 'true' Corrade.ini
   xmlstarlet edit --inplace --update 'Configuration/EnableNucleusServer' --value 'false' Corrade.ini
   xmlstarlet edit --inplace --update 'Configuration/Range' --value '0' Corrade.ini
   xmlstarlet edit --inplace --update 'Configuration/Groups/Group/Name' --value "$GroupName" Corrade.ini
   xmlstarlet edit --inplace --update 'Configuration/Groups/Group/UUID' --value $GroupUUID Corrade.ini
   xmlstarlet edit --inplace --update 'Configuration/Groups/Group/Password' --value "$GroupPassword" Corrade.ini
   xmlstarlet edit --inplace --update 'Configuration/Groups/Group/ChatLog' --value 'logs/groupchat/'$GroupNameFixed'.log' Corrade.ini
   xmlstarlet edit --inplace --update 'Configuration/Groups/Group/DatabaseFile' --value 'databases/'$GroupNameFixed'.db' Corrade.ini
   xmlstarlet edit --inplace --delete "Configuration/Masters/Master[FirstName='Laynnage']" Corrade.ini
   xmlstarlet edit --inplace --update "Configuration/Masters/Master[FirstName='Swiak']/FirstName" --value $MasterFirstName Corrade.ini
   xmlstarlet edit --inplace --update "Configuration/Masters/Master[LastName='Oado']/LastName" --value $MasterLastName Corrade.ini
   xmlstarlet edit --inplace --delete "Configuration/HordePeers/HordePeer[Name='Ecto']" Corrade.ini
   xmlstarlet edit --inplace --delete "Configuration/HordePeers/HordePeer[Name='Betty']" Corrade.ini
   cd ..
function_end "setup the Corrade.ini for progressive"
#
#
function_start "clean ini file" #for conservative 7.x
   sudo mv /home/$botuser/$BotFolderName/Corrade.ini /home/$botuser/$BotFolderName/Corrade.ini.backup
   #delete all lines not beginning with < and delete all lines with <!--
   sudo sed '/</!d' /home/$botuser/$BotFolderName/Corrade.ini.backup | sed '/<!--/d'  | sudo tee /home/$botuser/$BotFolderName/Corrade.ini
   sudo chown $botuser:$botuser /home/$botuser/$BotFolderName/Corrade.ini
function_end "clean ini file"
#
#
function_start "create an init.d entry for the bot"
   SRC='CORRADE_USER="corrade"'
   DST='CORRADE_USER="'$botuser'"'
   #
   SRC2='BOT_PATH="CorradeBots/MyFirstBot"'
   DST2='BOT_PATH="'$BotFolderName'"'
   #
   SRC3='# Provides:          MyFirstBot'
   DST3='# Provides:          '$BotFolderName
   #
   cd /etc/init.d/
#   wget -O $botuser$BotFolderName http://grimore.org/_export/code/secondlife/scripted_agents/corrade/install_guides/raspberry_pi?codeblock=22 >> $pathtologfile
	#https://raw.githubusercontent.com/freddii/corradepi/master
   #wget -O $botuser$BotFolderName /home/pi/programs_setup/corradepi/MyFirstBot >> $pathtologfile
   wget -O $botuser$BotFolderName https://raw.githubusercontent.com/freddii/corradepi/master/MyFirstBot >> $pathtologfile
   #cp /home/pi/MyFirstBot $botuser$BotFolderName #offline fix
   sed -i "s:$SRC:$DST:g" $botuser$BotFolderName
   sed -i "s:$SRC2:$DST2:g" $botuser$BotFolderName
   sed -i "s/$SRC3/$DST3/g" $botuser$BotFolderName
   chmod +x $botuser$BotFolderName
   chown root:root $botuser$BotFolderName
   update-rc.d $botuser$BotFolderName defaults
   cd /home/$botuser
function_end "create an init.d entry for the bot"
#
#
function_start "install monit"
   check_install monit >> $pathtologfile
function_end "install monit"
#
#
function_start "create a monit file for corrade"
   touch /etc/monit/conf.d/$botuser$BotFolderName
   cat <<EOT >> /etc/monit/conf.d/$botuser$BotFolderName
check process $botuser$BotFolderName with pidfile /home/$botuser/$BotFolderName/Corrade.exe.lock
    start program = "/etc/init.d/$botuser$BotFolderName start"
    stop program = "/etc/init.d/$botuser$BotFolderName stop"
#   if 5 restarts within 5 cycles then timeout
EOT
function_end "create a monit file for corrade"
#
#
function_start "change monitrc"  #otherwise i was not able to run: sudo monit status
   cd /etc/monit/
   sed -i "s:# set httpd port 2812 and:set httpd port 2812 and:g" monitrc
   sed -i "s:#     use address localhost:    use address localhost:g" monitrc
   sed -i "s:#     allow localhost:    allow localhost:g" monitrc
   sed -i "s/#     allow admin:monit/    allow admin:monit/g" monitrc
   cd /home/$botuser/
function_end "change monitrc"
#
#
function_start "restart monit service"
   service monit restart >> $pathtologfile
   systemctl reload monit >> $pathtologfile
function_end "restart monit service"
#
#
function_start "add a corrade specific sudo entry"
   touch /etc/sudoers.d/mainbot$botuser
   cat <<EOT >> /etc/sudoers.d/mainbot$botuser
%$botuser ALL=(root) NOPASSWD:/usr/bin/monit
EOT
function_end "add a corrade specific sudo entry"
#
#
echo "script has finished."
echo "script has finished." >> $pathtologfile
date
date >> $pathtologfile
#
#
