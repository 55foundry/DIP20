#!/bin/bash

set -e

echo PATH = $PATH
echo vessel @ `which vessel`

dfx start --clean --background
dfx identity use default
dfx deploy WasabiRouter --no-wallet

dfx identity use alice
ALICE_PUBLIC_KEY=$( \
    dfx identity get-principal \
        | awk -F '"' '{printf $0}' \
)
echo $ALICE_PUBLIC_KEY

dfx identity use bob
BOB_PUBLIC_KEY=$( \
    dfx identity get-principal \
        | awk -F '"' '{printf $0}' \
)
echo $BOB_PUBLIC_KEY

dfx identity use dan
DAN_PUBLIC_KEY=$( \
    dfx identity get-principal \
        | awk -F '"' '{printf $0}' \
)
echo $DAN_PUBLIC_KEY

dfx identity use alice
dfx deploy COOLCOIN --no-wallet --argument '("CoolCoin", "CC", 4)'

dfx identity use bob
dfx deploy HOTCOIN --no-wallet --argument '("HOTCOIN", "HC", 4)'

echo
echo == Initial token balances for Alice and Bob.
echo

echo Alice = $( \
    eval dfx canister call COOLCOIN balanceOf "'(principal \"$ALICE_PUBLIC_KEY\")'" \
)
echo Bob = $( \
    eval dfx canister call HOTCOIN balanceOf "'(principal \"$BOB_PUBLIC_KEY\")'" \
)

dfx identity use alice
echo TransferToBob = $( \
    eval dfx canister call WasabiRouter swapExactTokensForTokens "'(100:nat, 100:nat, [principal \"$ALICE_PUBLIC_KEY\"], principal \"$BOB_PUBLIC_KEY\", 0:nat)'" \
)

dfx identity use bob
echo TransferToAlice = $( \
    eval dfx canister call WasabiRouter swapExactTokensForTokens "'(100:nat, 100:nat, [principal \"$BOB_PUBLIC_KEY\"], principal \"$ALICE_PUBLIC_KEY\", 0:nat)'" \
)

dfx stop