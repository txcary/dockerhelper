#!/bin/sh
project=dockerfiles
git config --global user.name "Tan Xiang"
git config --global user.email tx-cary@163.com
git -C $project pull
git -C $project add -A
git -C $project commit
git -C $project push
