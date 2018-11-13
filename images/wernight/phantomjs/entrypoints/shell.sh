#!/bin/bash
if [  $# -lt 1 ]; then 
  exec "/bin/bash"
else
  exec /bin/bash -c "$@"
fi


