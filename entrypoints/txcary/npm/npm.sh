#!/bin/sh
npm config set registry https://registry.npm.taobao.org

if [  $# -lt 1 ]; then 
  exec "/bin/sh"
else
  exec /bin/sh -c "$@"
fi



