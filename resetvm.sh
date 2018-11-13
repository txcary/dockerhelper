rm -f ../ip.txt
vmname=`cat vm/name.conf`
/drives/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe controlvm $vmname reset
