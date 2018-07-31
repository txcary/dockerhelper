#!/bin/bash
rm -f ../ip.txt
vmname=`cat vm/name.conf`
VBoxManage startvm $vmname --type headless
