#!/bin/bash

## Retrieve Available Balance and Claimable Rewards
## Written by JP @ theklevernator.com - 2022

BALANCE='curl <YOUR_IP_ADDRESS:8080/address/<YOUR_ADDRESS>'
bal=.data.account.
var1=Balance
var2=Allowance
balance=$($BALANCE | jq $bal$var1/1000000)
allowance=$($BALANCE | jq $bal$var2/1000000)

echo "Available Balance: " $balance
echo "Claimable Rewards: " $allowance
