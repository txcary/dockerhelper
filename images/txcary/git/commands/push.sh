#!/bin/sh
pushAll(){
	project=$1
	git -C $project pull
	git -C $project add -A
	git -C $project commit
	git -C $project push
}
git config --global user.name "Tan Xiang"
git config --global user.email tx-cary@163.com

pushAll dockerhelper
pushAll dockerfiles
pushAll traceability
pushAll go/src/github.com/txcary/lixinger
pushAll go/src/github.com/txcary/securejson
pushAll go/src/github.com/txcary/investment
