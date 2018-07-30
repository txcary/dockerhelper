#!/bin/sh
npm config set registry http://registry.cnpmjs.org

if [  $# -lt 1 ]; then 
  exec "/bin/sh"
else
  exec /bin/sh -c "$@"
fi



