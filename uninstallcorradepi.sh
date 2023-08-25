#!/bin/bash
#
#usage: 
#sudo ./uninstallcorradepi.sh
#
botuser="corrade"
#
sudo monit stop all
sudo passwd -l $botuser #lock useraccount
sudo userdel -r -f $botuser #home, mail, other users files there
sudo crontab -r -u $botuser #remove crontab
sudo rm /etc/init.d/$botuser*
sudo rm /etc/monit/conf.d/$botuser*
sudo service monit restart
#sudo nano /etc/monit/monitrc #and reverse the changes the script made
sudo rm /etc/sudoers.d/mainbot$botuser
#
pathtothisscript="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $pathtothisscript
sudo rm corradepi-setup.sh
sudo rm enablebot.sh
sudo rm disablebot.sh
sudo rm uninstallbot.sh
sudo rm uninstallcorradepi.sh
echo "also revert the changes the installer did in /etc/monit/monitrc"
echo "uninstalling corradepi done"