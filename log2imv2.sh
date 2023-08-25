#!/bin/bash
#################################################
#CHANGE THIS VARIABLES                          #
#################################################
GroupUUID="YourGroupUUID"                       #
GroupPassword="YourGroupSecret"                 #
ServerPort="8080"                               #
AgentToMessageUUID="AvatarToGetTheMessage"      #
#################################################
#enable talk permission                         #
#enable server                                  #
#################################################
#usage:
#./log2imv2.sh /path/to/dir/
#./log2imv2.sh /home/corrade/bot1/logs/groupchat/
#or:
#./log2imv2.sh /path/to/logfile.log

PathToFile=$1
filebase=""
groupname=""

localip=$(hostname -I | awk '{print $1}')
url="http://"$localip":"$ServerPort"/"

#check if programs are installed, else install them.
dpkg -l | grep -qw inotify-tools || sudo apt-get install inotify-tools -y
dpkg -l | grep -qw curl || sudo apt-get install curl -y

log_to_im(){
	declare inputx=${1:-$(</dev/stdin)};
	curl -d "command=tell&group=$GroupUUID&password=$GroupPassword&entity=avatar&agent=$AgentToMessageUUID&message=[$groupname] $inputx" $url
}

inotifywait -m -r -e modify,create --format '%w%f' "${PathToFile}" | while read NEWFILE
do
	tail -n 1 "${NEWFILE}"
	filebase=$(basename "$NEWFILE")
	groupname=$(echo $filebase | cut -c7- | rev | cut -c5- | rev)
	tail -n 1 "${NEWFILE}" | log_to_im
done
