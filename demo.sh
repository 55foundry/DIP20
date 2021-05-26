#!/bin/bash

set -e

echo PATH = $PATH
echo vessel @ `which vessel`

dfx start --clean --background


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
dfx deploy DIP20 --no-wallet --argument '("cool coin","cc",4)'



echo
echo == Initial token balances for Alice and Bob.
echo

echo Alice = $( \
    eval dfx canister call DIP20 balanceOf "'(principal \"$ALICE_PUBLIC_KEY\")'" \
)
echo Bob = $( \
    eval dfx canister call DIP20 balanceOf "'(principal \"$BOB_PUBLIC_KEY\")'" \
)

echo
echo == Transfer 42 tokens from Alice to Bob.
echo

eval dfx canister --no-wallet call DIP20 transfer "'(principal \"$BOB_PUBLIC_KEY\", 42)'"

echo
echo == Final token balances for Alice and Bob.
echo

echo Alice = $( \
    eval dfx canister call DIP20 balanceOf "'(principal \"$ALICE_PUBLIC_KEY\")'" \
)
echo Bob = $( \
    eval dfx canister call DIP20 balanceOf "'(principal \"$BOB_PUBLIC_KEY\")'" \
)

echo
echo == Alice grants Dan permission to spend 50 of her tokens
echo

eval dfx canister --no-wallet call DIP20 approve "'(principal \"$DAN_PUBLIC_KEY\", 50)'"

echo
echo == Alices allowances
echo

echo Alices allowance for Dan = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$ALICE_PUBLIC_KEY\",principal  \"$DAN_PUBLIC_KEY\")'" \
)
echo Alices allowance for Bob = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$ALICE_PUBLIC_KEY\",principal  \"$BOB_PUBLIC_KEY\")'" \
)

echo
echo == Dan transfers 40 tokens from Alice to Bob
echo

dfx identity use dan
eval dfx canister --no-wallet call DIP20 transferFrom "'(principal \"$ALICE_PUBLIC_KEY\",principal  \"$BOB_PUBLIC_KEY\", 40)'"

echo
echo == Token balance for Bob and Alice
echo

echo Alice = $( \
    eval dfx canister call DIP20 balanceOf "'(principal \"$ALICE_PUBLIC_KEY\")'" \
)
echo Bob = $( \
    eval dfx canister call DIP20 balanceOf "'(principal \"$BOB_PUBLIC_KEY\")'" \
)

echo
echo == Alice allowances
echo

echo Alices allowance for Bob = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$ALICE_PUBLIC_KEY\",principal \"$BOB_PUBLIC_KEY\")'" \
)
echo Alices allowance for Dan = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$ALICE_PUBLIC_KEY\",principal  \"$DAN_PUBLIC_KEY\")'" \
)

echo
echo == Dan tries to transfer 20 tokens more from Alice to Bob: Should fail, remaining allowance = 10
echo

eval dfx canister --no-wallet call DIP20 transferFrom "'(principal \"$ALICE_PUBLIC_KEY\",principal  \"$BOB_PUBLIC_KEY\", 20)'"

echo
echo == Alice grants Bob permission to spend 100 of her tokens
echo

dfx identity use alice
eval dfx canister --no-wallet call DIP20 approve "'(principal \"$BOB_PUBLIC_KEY\", 100)'"

echo
echo == Alice allowances
echo

echo Alices allowance for Bob = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$ALICE_PUBLIC_KEY\",principal  \"$BOB_PUBLIC_KEY\")'" \
)
echo Alices allowance for Dan = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$ALICE_PUBLIC_KEY\",principal  \"$DAN_PUBLIC_KEY\")'" \
)

echo
echo == Bob transfers 99 tokens from Alice to Dan
echo

dfx identity use bob
eval dfx canister --no-wallet call DIP20 transferFrom "'(principal \"$ALICE_PUBLIC_KEY\",principal  \"$DAN_PUBLIC_KEY\", 99)'"

echo
echo == Balances
echo

echo Alice = $( \
    eval dfx canister call DIP20 balanceOf "'(principal \"$ALICE_PUBLIC_KEY\")'" \
)
echo Bob = $( \
    eval dfx canister call DIP20 balanceOf "'(principal \"$BOB_PUBLIC_KEY\")'" \
)
echo Dan = $( \
    eval dfx canister call DIP20 balanceOf "'(principal \"$DAN_PUBLIC_KEY\")'" \
)

echo
echo == Alice allowances
echo

echo Alices allowance for Bob = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$ALICE_PUBLIC_KEY\",principal  \"$BOB_PUBLIC_KEY\")'" \
)
echo Alices allowance for Dan = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$ALICE_PUBLIC_KEY\",principal  \"$DAN_PUBLIC_KEY\")'" \
)

echo
echo == Dan grants Bob permission to spend 100 of this tokens: Should fail, dan only has 99 tokens
echo

dfx identity use dan
eval dfx canister --no-wallet call DIP20 approve "'(principal \"$BOB_PUBLIC_KEY\", 100)'"

echo
echo == Dan grants Bob permission to spend 50 of this tokens
echo

eval dfx canister --no-wallet call DIP20 approve "'(principal \"$BOB_PUBLIC_KEY\", 50)'"

echo
echo == Dan allowances
echo

echo Dan allowance for Bob = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$DAN_PUBLIC_KEY\",principal  \"$BOB_PUBLIC_KEY\")'" \
)
echo Dan allowance for Alice = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$DAN_PUBLIC_KEY\",principal  \"$ALICE_PUBLIC_KEY\")'" \
)

echo
echo == Dan change Bobs permission to spend 40 of this tokens instead of 50
echo

eval dfx canister --no-wallet call DIP20 approve "'(principal \"$BOB_PUBLIC_KEY\", 40)'"

echo
echo == Dan allowances
echo

echo Dan allowance for Bob = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$DAN_PUBLIC_KEY\",principal  \"$BOB_PUBLIC_KEY\")'" \
)
echo Dan allowance for Alice = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$DAN_PUBLIC_KEY\",principal  \"$ALICE_PUBLIC_KEY\")'" \
)

echo
echo == Dan grants Alice permission to spend 60 of this tokens: Should fail, bob can already spend 40 so there is only 59 left
echo

eval dfx canister --no-wallet call DIP20 approve "'(principal \"$ALICE_PUBLIC_KEY\", 60)'"

echo
echo == Dan allowances
echo

echo Dan allowance for Bob = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$DAN_PUBLIC_KEY\",principal  \"$BOB_PUBLIC_KEY\")'" \
)
echo Dan allowance for Alice = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$DAN_PUBLIC_KEY\",principal  \"$ALICE_PUBLIC_KEY\")'" \
)

echo
echo == Dan grants Alice permission to spend 59 of his tokens
echo

eval dfx canister --no-wallet call DIP20 approve "'(principal \"$ALICE_PUBLIC_KEY\", 59)'"

echo
echo == Dan allowances
echo

echo Dan allowance for Bob = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$DAN_PUBLIC_KEY\",principal  \"$BOB_PUBLIC_KEY\")'" \
)
echo Dan allowance for Alice = $( \
    eval dfx canister call DIP20 allowance "'(principal \"$DAN_PUBLIC_KEY\",principal  \"$ALICE_PUBLIC_KEY\")'" \
)

dfx stop