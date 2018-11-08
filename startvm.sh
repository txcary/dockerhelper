#!/bin/bash
vmname=`cat vm/name.conf`
VBoxManage startvm $vmname --type headless
