#!/bin/sh
git config --global user.name "Tan Xiang"
git config --global user.email tx-cary@163.com
git -C dockerhelper pull
git -C dockerfiles pull
git -C traceability pull
