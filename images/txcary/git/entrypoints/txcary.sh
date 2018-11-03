#!/bin/sh
git config --global user.name "Tan Xiang"
git config --global user.email tx-cary@163.com

if [  $# -lt 1 ]; then 
  exec "/bin/sh"
else
  exec /bin/sh -c "$@"
fi


