#!/bin/sh
geth -datadir ~/data/ --networkid 0 --rpc --rpcaddr "172.18.0.50" --rpcapi admin,eth,miner,web3 --etherbase "0x4c283287839fd441b8c8d18771321bc06a81edae" --mine --minerthreads=1