#!/bin/bash

## Written by JP @ theklevernator.com - 2022

echo -e "\n"

echo "##############################################
Hi! Welcome to the KDA Creator! Lets get started! 
Please enter the information as prompted. This does
not contain all available input options at this time. 
More will be added soon. 
##############################################"

echo -e "\n"

read -p 'Please enter "1" for NFT or "0" for FT: ' kda_type
read -p 'Enter KDA name: ' name
read -p 'Enter ticker in UPPERCASE: ' tick
read -p 'Enter the Owner Address: ' address
read -p 'Can the KDA be burned? (true/false): ' burn
read -p 'Can the KDA be sent? (true/false): ' sent
read -p 'Can the KDA be frozen? (true/false): ' freeze
read -p 'Can the KDA be minted? (true/false): ' mint
read -p 'Enter the Max Supply: ' max
read -p 'Enter the Cirulating Supply: ' circ
read -p 'Enter the precision: ' prec

  sudo docker run -it --rm --user "$(id -u):$(id -g)" \
  -v $(pwd)/wallet:/opt/klever-blockchain \
  --network=host \
  --entrypoint=/usr/local/bin/operator \
  kleverapp/klever-go-testnet:latest \
  --key-file=./walletKey.pem \
  --node=https://node.testnet.klever.finance kda create $kda_type\
  --canChangeOwner=$sent\
  --canBurn=$burn\
  --canFreeze=$freeze\
  --canMint=$mint\
  --circulatingSupply=$circ\
  --maxSupply=$max\
  --name=$name\
  --ownerAddress=$address\
  --precision $prec
  --ticker=$tick

echo -e "\n"

echo 'Your transaction has been completed. Please check the Klever Explorer for the address:' $address ' to check if it was successfull or not.'

echo -e "\n"
