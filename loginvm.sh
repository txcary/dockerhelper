#!/bin/bash

until [ -f "../ip.txt" ];
do
	echo "waiting ip..."
	sleep 1
done
ip=`cat ../ip.txt`
if [ $# == 0 ]; then
ssh -x root@$ip -t "cd /workspace/dockerhelper; /bin/sh"
else
ssh -x root@$ip -t "cd /workspace/dockerhelper; $@"
fi
