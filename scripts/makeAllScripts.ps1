# This sequence converts the variables defined in svcsetup.cmd to Powershell environment variables
get-content .\svcsetup.cmd | select-string -pattern '^REM' -notmatch `
 | %{$_ -replace '(^set )(.*?)(=)(.*?)($)','Set-Variable -scope global -name $2 -value "$4"'} `
 | %{$_ -replace '(.*?)(%)(.*?)(%)(.*?)','$1$$$3$5'} | Out-File -Encoding ASCII svcsetup.ps1

. .\svcsetup.ps1

# Convert AMC_HOME (typically something like C:\Oracle) to a string that removes the
# ':' character and relaces '\' with the '_' character
# Examples:  C:\Oracle => C_Oracle
#            d:\Oracle => D_Oracle
# This is used to construct part of the NodeManager Svc name
$BAR_WL_HOME = $AMC_HOME -replace ':',''
$BAR_WL_HOME = $BAR_WL_HOME -replace '\\','_'

cd $MW_HOME\wlserver\server\bin
cat .\installSvc.cmd | %{$_ -replace "-svcdescription","-delay:15000 -svcdescription"} | Out-File -Encoding ASCII installWebLogicSvc.cmd
cat .\installNodeMgrSvc.cmd.wls-orig | %{$_ -replace "-svcdescription",'-depend:"wlsvc base_domain_AdminServer" -svcdescription'} | Out-File -Encoding ASCII installNodeMgrSvc.cmd
#$DEPEND="-depend:`"wlsvc base_domain_AdminServer`",`"Oracle Weblogic base_domain NodeManager " + "(" + $BAR_WL_HOME + "_MIDDLE~1_ORACLE~1_wlserver)`""
$DEPEND="-depend:`"wlsvc base_domain_AdminServer`""
cat .\installSvc.cmd | %{$_ -replace "-svcdescription","$DEPEND -svcdescription"} | Out-File -Encoding ASCII installAMCServerSvc.cmd
