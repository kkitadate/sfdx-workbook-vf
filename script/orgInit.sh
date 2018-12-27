#!/bin/bash
sfdx force:org:create -s -f config/project-scratch-def.json -a workbook-vf -d 30
sfdx force:source:push
# custom settings setup.  Modify for your username
# sfdx force:user:permset:assign -n Warehouse_Manager
# sfdx force:user:permset:assign -n Warehouse_Salesperson

sfdx force:org:open -p /lightning/setup/SetupOneHome/home