rm -f ../ip.txt
if [  $# -lt 1 ]; then 
echo -e "\nUsage:\n$0 [virtual machine] \n" 
exit 1
fi
/drives/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe startvm $1 --type headless
