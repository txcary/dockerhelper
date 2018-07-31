#!/bin/bash
rm -f ../ip.txt
vmname=`cat vm/name.conf`
VBoxManage controlvm $vmname acpipowerbutton
