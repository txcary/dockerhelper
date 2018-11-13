#!/bin/sh
git config --global user.name "Tan Xiang"
git config --global user.email tx-cary@163.com
git -C dockerhelper pull
git -C dockerfiles pull
git -C traceability pull
git -C go/src/github.com/txcary/lixinger pull
git -C go/src/github.com/txcary/securejson pull
git -C go/src/github.com/txcary/investment pull
git -C go/src/github.com/txcary/goutils pull
git -C go/src/github.com/txcary/pplatform pull
