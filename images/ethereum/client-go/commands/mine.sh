#!/bin/sh
cp -r /workspace/dapp/miner/data/keystore/* ~/data/keystore/
geth -datadir ~/data/ --networkid 88 --rpc --rpcaddr "172.18.0.50" --rpcapi admin,eth,miner,web3,personal,net,txpool --unlock "0x4c283287839fd441b8c8d18771321bc06a81edae" --etherbase "0x4c283287839fd441b8c8d18771321bc06a81edae" console