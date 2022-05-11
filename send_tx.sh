#!/bin/bash

## Written by JP @ theklevernator.com - 2022

echo -e "\n"

echo "###########################################################
Hi! Welcome to the script to send KLV. Lets get started! 
Please enter the information as prompted.
###########################################################"

echo -e "\n"

echo "Let's get started!!"

PS3="Please select '1' to Send Tx or select '2' and Quit: "

select opt in 'Send KLV' 'Quit'; do
echo -e "\n"
  case $opt in
    'Send KLV')
      read -p "Enter the recieving address: " n1
      read -p "Enter the amount to send: " n2
      echo -e "You are about to send '$n2' KLV to '$n1'\n"
      read -p "Are you sure you want to continue?(yes/no) " choice
      echo -e "\n"
      ans='yes'
        if [[ $choice == $ans ]]; then
            docker run -it --rm --user "$(id -u):$(id -g)" \
            -v $(pwd)/wallet:/opt/klever-blockchain \
            --network=host \
            --entrypoint=/usr/local/bin/operator \
            kleverapp/klever-go-testnet:latest \
            --key-file=./walletKey.pem \
            --node=https://node.testnet.klever.finance \
            account send $n1 $n2                
        else 
            echo "Ok we will exit"
        fi
   echo -e "\n"
    ;;
    'Quit')
      break
      ;;
     *) 
      echo "Invalid option $REPLY"
      ;;
  esac
done
