@ECHO OFF
SETLOCAL
REM This script depends on a similarly named companion Powershell file with .ps1 extention in the same directory.
REM It also depends on our standard svcsetup.cmd file being in the same directory as this script.

REM This script can be run multiple times without harming an original WLS installation.  All original WLS .cmd files affected are backed up, however any existing  "Oracle\scripts\install{web,node,AMC}.cmd" scripts or their counterparts in ...WLSserver/server/bin will get over-written.

echo Checking file locations
if exist .\svcsetup.cmd (
	call .\svcsetup.cmd
) else (
	echo  svcsetup.cmd cannot be found.  It must exist in this directory.  Exiting...
	goto :eof
)

REM The 2 primary directories (AMC_HOME & MW_HOME) must exist.  
if not exist %AMC_HOME% (
	echo  %AMC_HOME%  does not exist.    
	echo Exiting...
	goto :eof
)
if not exist %MW_HOME%\wlserver\server\bin (
	echo Some element of path: %MW_HOME%\wlserver\server\bin does not exist.  Check svcsetup.cmd and actual filesystem paths.
	echo Exiting...
	goto :eof
)

REM 		 +_+_  make some changes to the scripts in ...wlserver\server\bin.  +_+
REM The .PS1 scripts handle backing up the 3 .cmd files except for installNodeMgrSvc.cmd, so do it here
REM cd %MW_HOME%\wlserver\server\bin

REM if this is the first run after a clean WLS install, make a backup copy of installNodeMgr, else carry on
if not exist %MW_HOME%\wlserver\server\bin\installNodeMgrSvc.cmd.wls-orig (
	copy %MW_HOME%\wlserver\server\bin\installNodeMgrSvc.cmd %MW_HOME%\wlserver\server\bin\installNodeMgrSvc.cmd.wls-orig
)

echo Editing scripts in %MW_HOME%\wlserver\server\bin
REM The Powershell script (.ps1) makes the required edits to 3 .cmd files in %AMC_HOME%\Middleware\Oracle_Home\wlserver\server\bin
REM see http://www.howtogeek.com/204088/how-to-use-a-batch-file-to-make-powershell-scripts-easier-to-run/


PowerShell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%~dpn0.ps1'"
PAUSE


REM		  +_+_ Create the Services Installation scripts in C:\Oracle\scripts (AMC_HOME\scripts) +_+_

if exist %AMC_HOME%\scripts (
	echo Found existing scripts directory: %AMC_HOME%\scripts.
) else (
	mkdir %AMC_HOME%\scripts
)
cd %AMC_HOME%\scripts

set AMCSERVER=AMC-Server
set WLSUSERNAME=weblogic
set WLSPASSWORD=weblogic1
set WLSADMIN_IPADDR=
set WLSADMIN_PORT=7001

:whileNotY
set Yn=Y
set /p AMCSERVER=Type a new server name or press enter to accept: [%AMCSERVER%]
set /p WLSUSERNAME=Type a new user name or press enter to accept: [%WLSUSERNAME%]
set /p WLSPASSWORD=Type a new password or press enter to accept: [%WLSPASSWORD%]
if [%WLSADMIN_IPADDR%] == []  (
set /p WLSADMIN_IPADDR=Enter the correct hostname or IP Address: 
)else (
set /p WLSADMIN_IPADDR=Type a new hostname/IP Address or press enter to accept: [%WLSADMIN_IPADDR%] : 
)
set /p WLSADMIN_PORT=Type a new port number or press enter to accept: [%WLSADMIN_PORT%] : 
echo You've chosen to set
echo the Admin Server name to: %AMCSERVER%
echo the username to:          %WLSUSERNAME%
echo the password to:          %WLSPASSWORD%
echo the hostname/IP to:       %WLSADMIN_IPADDR%
echo and the port to:          %WLSADMIN_PORT%
set /p Yn=are these values correct? [Y/n]
if not [%Yn%]==[Y] goto whileNotY

echo @echo off>installAMCServerSvc.cmd
echo SETLOCAL>>installAMCServerSvc.cmd
echo if not exist .\svcsetup.cmd (>>installAMCServerSvc.cmd
echo 	echo svcsetup.cmd cannot be found.  It must exist in this directory.  Exiting...>>installAMCServerSvc.cmd
echo 	goto :eof>>installAMCServerSvc.cmd
echo )>>installAMCServerSvc.cmd
echo call svcsetup.cmd>>installAMCServerSvc.cmd
echo set SERVER_NAME=%AMCSERVER%>>installAMCServerSvc.cmd
echo set WLS_USER=%WLSUSERNAME%>>installAMCServerSvc.cmd
echo set WLS_PW=%WLSPASSWORD%>>installAMCServerSvc.cmd
echo set ADMIN_URL=http://%WLSADMIN_IPADDR%:%WLSADMIN_PORT%>>installAMCServerSvc.cmd
echo set USER_MEM_ARGS=-Xmx4096m>>installAMCServerSvc.cmd
echo cd %%DOMAIN_HOME%%>>installAMCServerSvc.cmd
echo call "%MW_HOME%\wlserver\server\bin\installAMCServerSvc.cmd">>installAMCServerSvc.cmd
echo ENDLOCAL>>installAMCServerSvc.cmd 
echo Created installAMCServerSvc.cmd in %AMC_HOME%\scripts

echo @echo off>installWebLogicSvc.cmd
echo SETLOCAL>>installWebLogicSvc.cmd
echo if not exist .\svcsetup.cmd (>>installWebLogicSvc.cmd
	echo echo svcsetup.cmd cannot be found.  It must exist in this directory.  Exiting...>>installWebLogicSvc.cmd
	echo goto :eof>>installWebLogicSvc.cmd
echo )>>installWebLogicSvc.cmd
echo call svcsetup.cmd>>installWebLogicSvc.cmd
echo set MAX_CONNECT_RETRIES=4>>installWebLogicSvc.cmd
echo call "%USERDOMAIN_HOME%\bin\setDomainEnv.cmd">>installWebLogicSvc.cmd
echo call "%MW_HOME%\wlserver\server\bin\installWebLogicSvc.cmd">>installWebLogicSvc.cmd
echo ENDLOCAL>>installWebLogicSvc.cmd
echo Created installWebLogicSvc.cmd in %AMC_HOME%\scripts

echo @echo off>installNodeMgrSvc.cmd
echo SETLOCAL>>installNodeMgrSvc.cmd
echo if not exist .\svcsetup.cmd (>>installNodeMgrSvc.cmd
	echo echo svcsetup.cmd cannot be found.  It must exist in this directory.  Exiting...>>installNodeMgrSvc.cmd
	echo goto :eof>>installNodeMgrSvc.cmd
echo )>>installNodeMgrSvc.cmd
echo call svcsetup.cmd>>installNodeMgrSvc.cmd
echo call "%USERDOMAIN_HOME%\bin\setDomainEnv.cmd">>installNodeMgrSvc.cmd
echo call "%USERDOMAIN_HOME%\bin\installNodeMgrSvc.cmd">>installNodeMgrSvc.cmd
echo ENDLOCAL>>installNodeMgrSvc.cmd
echo Created installNodeMgrSvc.cmd in %AMC_HOME%\scripts

REM 		 _+_+_ Create the uninstall scripts in C:\Oracle\scripts (AMC_HOME\scripts) +_+_

echo @echo off>uninstallAMCServerSvc.cmd
echo SETLOCAL>>uninstallAMCServerSvc.cmd
echo if not exist .\svcsetup.cmd (>>uninstallAMCServerSvc.cmd
	echo echo svcsetup.cmd cannot be found.  It must exist in this directory.  Exiting... >>uninstallAMCServerSvc.cmd
	echo goto :eof>>uninstallAMCServerSvc.cmd
echo )>>uninstallAMCServerSvc.cmd
echo call svcsetup.cmd>>uninstallAMCServerSvc.cmd
echo set SERVER_NAME=%AMCSERVER%>>uninstallAMCServerSvc.cmd
echo cd %%DOMAIN_HOME%%>>uninstallAMCServerSvc.cmd
echo call "%MW_HOME%\wlserver\server\bin\uninstallSvc.cmd">>uninstallAMCServerSvc.cmd
echo ENDLOCAL>>uninstallAMCServerSvc.cmd
echo Created uninstallAMCServerSvc.cmd in %AMC_HOME%\scripts

echo @echo off>uninstallWebLogicSvc.cmd
echo SETLOCAL>>uninstallWebLogicSvc.cmd
echo if not exist .\svcsetup.cmd (>>uninstallWebLogicSvc.cmd
	echo echo svcsetup.cmd cannot be found.  It must exist in this directory.  Exiting... >>uninstallWebLogicSvc.cmd
	echo goto :eof>>uninstallWebLogicSvc.cmd>>uninstallWebLogicSvc.cmd
echo )	>>uninstallWebLogicSvc.cmd
echo call svcsetup.cmd>>uninstallWebLogicSvc.cmd
echo set SERVER_NAME=AdminServer>>uninstallWebLogicSvc.cmd
echo cd %%DOMAIN_HOME%%>>uninstallWebLogicSvc.cmd
echo call "%MW_HOME%\wlserver\server\bin\uninstallSvc.cmd">>uninstallWebLogicSvc.cmd
echo ENDLOCAL>>uninstallWebLogicSvc.cmd
echo Created uninstallWebLogicSvc.cmd in %AMC_HOME%\scripts

echo @echo off>uninstallNodeMgrSvc.cmd
echo SETLOCAL>>uninstallNodeMgrSvc.cmd
echo if not exist .\svcsetup.cmd (>>uninstallNodeMgrSvc.cmd
	echo echo svcsetup.cmd cannot be found.  It must exist in this directory.  Exiting... >>uninstallNodeMgrSvc.cmd
	echo goto :eof>>uninstallNodeMgrSvc.cmd
echo )>>uninstallNodeMgrSvc.cmd
echo call svcsetup.cmd>>uninstallNodeMgrSvc.cmd
echo call "%USERDOMAIN_HOME%%\bin\setDomainEnv.cmd">>uninstallNodeMgrSvc.cmd
echo call "%USERDOMAIN_HOME%%\bin\uninstallNodeMgrSvc.cmd">>uninstallNodeMgrSvc.cmd
echo ENDLOCAL>>uninstallNodeMgrSvc.cmd
echo Created uninstallNodeMgrSvc.cmd in %AMC_HOME%\scripts

echo Finished






