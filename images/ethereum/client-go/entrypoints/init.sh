#!/bin/sh
geth -datadir ~/data/ init /workspace/traceability/genesis.json

if [  $# -lt 1 ]; then 
  exec "/bin/sh"
else
  exec /bin/sh -c "$@"
fi


