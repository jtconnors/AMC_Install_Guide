
REM
REM AMC_HOME must point to the AMC Master directory from which all WebLogic
REM software is installed.
REM
set AMC_HOME=C:\Oracle

REM
REM JAVA_HOME location is better off having a directory name like "jdk8" as 
REM opposed to a specific version (like "jdk1.8.0_161), so that it can easily
REM be replaced with a newer update, keeping the generic "jdk8" name.
REM For organization's sake, it might make sense to have a jdk directly under
REM the AMC_HOME directory.
REM
set JAVA_HOME=%AMC_HOME%\jdk8

REM
REM This option has been handy in the past where the WebLogic server had
REM multiple network interfaces with both IPv4 and Ipv6 stacks.  In the case
REM where network irregularities take place, try uncommenting the
REM JAVA_OPTIONS line that follows.
REM
REM set JAVA_OPTIONS=-Djava.net.preferIPv4Stack=true

REM
REM These Variables are set relative to AMC_Home and in most cases should be
REM left alone
REM
set MW_HOME=%AMC_HOME%\Middleware\Oracle_Home
set WL_HOME=%MW_HOME%\wlserver
set DOMAIN_NAME=base_domain
set DOMAIN_HOME=%MW_HOME%\user_projects\domains\%DOMAIN_NAME%
set USERDOMAIN_HOME=%DOMAIN_HOME%