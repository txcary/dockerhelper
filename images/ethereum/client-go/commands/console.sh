#!/bin/sh
geth -datadir ~/data/ --networkid 0 --rpc --rpcaddr "172.18.0.50" --rpcapi admin,eth,miner,web3 console