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
#./log2im.sh /path/to/logfile.log

PathToFile=$1
filebase=$(basename "$PathToFile")
groupname=$(echo $filebase | cut -c7- | rev | cut -c5- | rev)
#
localip=$(hostname -I | awk '{print $1}')
url="http://"$localip":"$ServerPort"/"
#

#check if programs are installed, else install them.
dpkg -l | grep -qw curl || sudo apt-get install curl -y

log_to_im(){
	declare inputx=${1:-$(</dev/stdin)};
	curl -d "command=tell&group=$GroupUUID&password=$GroupPassword&entity=avatar&agent=$AgentToMessageUUID&message=[$groupname] $inputx" $url
}

length=0
while sleep 1  # use wanted delay here
do
  new_length=$(find "$PathToFile" -printf "%s")
  if [ $length -lt $new_length ]
  then
	tail --bytes=$[new_length-length] "$PathToFile"
	tail --bytes=$[new_length-length] "$PathToFile" | log_to_im
  fi
  length=$new_length
done

