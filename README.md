# corradepi

install script for a corrade bot on a raspberrypi2 (raspberry pi 2)  
2019-09-26-raspbian-buster-lite.zip  
https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2019-09-30/2019-09-26-raspbian-buster-lite.zip  

Add the latest mono sources-list to your system:
------------------------------------------------
```
sudo apt-get install apt-transport-https dirmngr gnupg ca-certificates -y
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/debian stable-raspbianbuster main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt-get update
```

Get the script and make it executable:
--------------------------------------
```
cd ~
wget https://raw.githubusercontent.com/freddii/corradepi/master/corradepi-setup.sh && chmod +x corradepi-setup.sh
```

run the script:
---------------
if you install more than one bot, every bot you install must have a different BotFolderName  
for CorradeZipfileName you can use corrade-7.115.zip [compiling_corrade 7.115](https://github.com/freddii/Corrade-New) ~~or corrade-7.122.zip (conservative) or corrade-9.163.zip (progressive)  
7.x can be used for modelbot, avagreeterbot, groupbot(notice, message)..  
9.x has some new features [progressive changelog](http://archive.is/Ga8kI)~~
maybe put a space in the beginning of the command so it will not be saved in .bash_history  
(cause you write the password in terminal)  
```
 sudo ./corradepi-setup.sh BotFolderName BotSlFirstName BotSlLastName 'BotPassword' MasterFirstName MasterLastName 'GroupName' GroupUUID 'GroupPassword' CorradeZipfileName
```
for example:
```
 sudo ./corradepi-setup.sh MyFirstBot Corrade Resident 'goodbotsecret' Testuser Resident 'THE BEST OF SL Magazine Readers' aeb9e510-3e8d-ae5f-90b1-b491109d7590 'goodgroupsecret' corrade-7.115.zip
```
took round about 60 min for the first bot (most time took the installation of mono-complete cause it had to precompile things for arm..) Second bot took only 2 minutes.  

delete a command from bash history:
-----------------------------------
view the history:  
```
history
```
delete the line of entry that is critical (for example 10):  
```
history -d 10
```


Change default password "goodusersecret" for user corrade:
------------------------------------------------------
Change default password "goodusersecret" for user corrade:
```
su corrade
```
enter old password "goodusersecret"
change the password:
```
passwd
```
after changing the password exit user corrade with:
```
exit
```

check the status of your bot:
-----------------------------
```
sudo monit status
#or systemctl status monit
```

based on:
------------------
[install_guide_raspberry_pi](http://archive.is/BUqQD)  
[install_guide_raspberry_pi2](http://archive.is/VeXJ9)  
[install_guide_raspberry_pi3](http://archive.is/twNVh)  

api documentation:
------------------
[commands](http://archive.is/PMLxZ)  
[configuration](http://archive.is/qRBBS)  
[notification](http://archive.is/CmEcB)  
[permission](http://archive.is/9nCCb)  
[tutorials](http://archive.fo/FxRfg)  
[progressive changelog](http://archive.is/Ga8kI)  
[outdated documentation](http://archive.is/h9F8p)  
[bash_corrade_manager](http://archive.is/lcUEh)  
[was functions](https://pastebin.com/7D9tSSjZ)  
[compiling_corrade 7.115](https://github.com/freddii/Corrade-New)  
[compiling_corrade](http://archive.is/DBDK7)  
[tutorial](https://archive.is/FxRfg)
[inworld projects](https://archive.fo/jpcJA)

http server:
------------

enable http server to be able to send commands to 'http://192.168.1.10:8080/':  
```
cd ~
wget https://raw.githubusercontent.com/freddii/corradepi/master/enablehttp.sh && chmod +x enablehttp.sh
```

usage:  
```
 sudo ./enablehttp.sh BotFolderName 8080
```

example to send a command to http server:  
```
curl -d "command=version&group=<group>&password=<password>" http://192.168.1.10:8080  
```

example use of xmlstarlet from terminal:  
----------------------------------------
[starlet docs](http://xmlstar.sourceforge.net/doc/xmlstarlet.txt)

example use of xmlstarlet from terminal:  
for conservative 7.x:  
```
BotFolderName="BotFolderName"
botuser="corrade"
sudo xmlstarlet edit --inplace --update 'config/groups/group/permissions/talk' --value 'true' /home/$botuser/$BotFolderName/Corrade.ini
sudo xmlstarlet edit --inplace --update 'config/groups/group/permissions/group' --value 'true' /home/$botuser/$BotFolderName/Corrade.ini
sudo xmlstarlet edit --inplace --update 'config/groups/group/permissions/movement' --value 'true' /home/$botuser/$BotFolderName/Corrade.ini
sudo xmlstarlet edit --inplace --update 'config/groups/group/permissions/notifications' --value 'true' /home/$botuser/$BotFolderName/Corrade.ini
#
sudo xmlstarlet edit --inplace --update 'config/groups/group/notifications/group' --value 'true' /home/$botuser/$BotFolderName/Corrade.ini
sudo xmlstarlet edit --inplace --update 'config/groups/group/notifications/membership' --value 'true' /home/$botuser/$BotFolderName/Corrade.ini
```

for progressive 9.x  
```
sudo xmlstarlet edit --inplace --update 'Configuration/EnableMultipleSimulators' --value 'false' /home/$botuser/$BotFolderName/Corrade.ini
sudo xmlstarlet edit --inplace --subnode 'Configuration/Groups/Group/Permissions' --type elem -n Permissions --value database /home/$botuser/$BotFolderName/Corrade.ini
sudo xmlstarlet edit --inplace --subnode 'Configuration/Groups/Group/Notifications' --type elem -n Notifications --value group /home/$botuser/$BotFolderName/Corrade.ini
```



to be able to login into osgrid with conservative:  
```
BotFolderName="BotFolderName"
botuser="corrade"
sudo xmlstarlet edit --inplace --update 'config/client/loginurl' --value 'http://login.osgrid.org' /home/$botuser/$BotFolderName/Corrade.ini
```

to be able to login into osgrid with progressive:  
```
BotFolderName="BotFolderName"
botuser="corrade"
sudo xmlstarlet edit --inplace --update 'Configuration/LoginURL' --value 'http://login.osgrid.org' /home/$botuser/$BotFolderName/Corrade.ini
```


disable a bot script:  
---------------------
```
cd ~
wget https://raw.githubusercontent.com/freddii/corradepi/master/disablebot.sh && chmod +x disablebot.sh
```

usage:  
```
 sudo ./disablebot.sh BotFolderName
```

enable a bot script:  
---------------------
```
cd ~
wget https://raw.githubusercontent.com/freddii/corradepi/master/enablebot.sh && chmod +x enablebot.sh
```

usage:  
```
 sudo ./enablebot.sh BotFolderName
```

uninstall a bot:
----------------
```
cd ~
wget https://raw.githubusercontent.com/freddii/corradepi/master/uninstallbot.sh && chmod +x uninstallbot.sh
```

usage:  
```
 sudo ./uninstallbot.sh BotFolderName
```

uninstall corradepi:
-------------------
```
cd ~
wget https://raw.githubusercontent.com/freddii/corradepi/master/uninstallcorradepi.sh && chmod +x uninstallcorradepi.sh
```

usage:  
```
sudo ./uninstallcorradepi.sh
```
