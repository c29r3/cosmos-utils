#!/bin/bash

WALLET_NAME="YOUR_WALLET_NAME"
CHAIN_ID="sentinel-turing-3a"
DENOMINATION="tsent"
WALLET_PWD="YOUR_WALLET_PASSWORD"
BINPATH="/root/sentinel/sentinel-hub-cli"

while true; 
do 
    OPERATOR=$($BINPATH q staking delegations $($BINPATH keys list | jq -r .[0].address) | jq -r .[].validator_address)
    STATUS=$($BINPATH query staking validator $OPERATOR --trust-node -o json | jq -r .status)
    echo "Status $STATUS"
    if [[ $STATUS != "2" ]]; then
        echo "UNJAIL"
        echo -e "$WALLET_PWD\n$WALLET_PWD\n" | $BINPATH tx slashing unjail --from $WALLET_NAME --gas-adjustment="1.5" --gas="200000" --gas-prices="0.003$DENOMINATION" --chain-id=$CHAIN_ID -y
    fi
    sleep 300
done
