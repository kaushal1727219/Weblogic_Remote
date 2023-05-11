#!/usr/bin/python
import os, sys
readTemplate('/opt/app/oracle/middleware/wlserver/common/templates/wls/wls.jar')
cd('/Security/base_domain/User/weblogic')
cmo.setPassword('password123')
setOption('ServerStartMode', 'prod')
setOption('OverwriteDomain', 'true')
cd('/Server/AdminServer')
setOption('ServerStartMode', 'prod')
cmo.setName('AdminServer')
cmo.setListenPort(7001)
cmo.setListenAddress('')
writeDomain('/opt/app/oracle/middleware/user_projects/domains/blaze_admin')
closeTemplate()
exit()
