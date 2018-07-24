# AMC_Install_Guide
Java Advanced Management Console Installation Guide

## OVERVIEW
The Java Advanced Management Console can be tricky to install.  Some of the
more important steps include:

1. Local or remote installation of a supported Relational Database (Oracle DB 
   or MySQL)

2. Installation of Oracle Fusion Middleware WebLogic application server

3. Deployment of the Java Advanced Management Console Java EE application

4. Configuration and integartion of these components.

This project contains versions of an Installation Guide (MS-Word) documents
that walks you through the steps, with screenshots included, needed to install
the various Java Advanced Management Console components.

This tag specifically contains an install guides for Java AMC 2.11 on Windows
(desktop or server) with either a MySQL or Oracle 12c database. The
specific install guides can be found in the ...with_mysql/... and
...with_oracledb/... directories respectively.

Additionally,  scripts are provided to ease the task of creating the necessary
Windows services that will start up the Java AMC components at boot time.
They are referenced in the install documents and can be found in the
...scripts/...  directory.
