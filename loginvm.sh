#!/bin/bash

until [ -f "../ip.txt" ];
do
	echo "waiting ip..."
	sleep 1
done

ssh root@`cat ../ip.txt`
