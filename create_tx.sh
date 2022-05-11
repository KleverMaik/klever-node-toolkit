#!/bin/bash

## Written by JP @ theklevernator.com - 2022

echo -e "\n"

echo "###########################################################
Hi! Welcome to the script to send KLV. Lets get started! 
Please enter the information as prompted. This uses your 
MAIN Klever Wallet. Ensure that you are in the correct 
Directory when you run this. If not, modify the docker
wallet location and replace $(pwd) with an absolute path
###########################################################"

echo -e "\n"

echo "Let's get started!!"

PS3="Please select a value or hit 'enter' to see values if not showing: "

select opt in 'Freeze and Delegate KLV' 'Claim Rewards' 'Send KLV' 'Quit'; do
echo -e "\n"
  case $opt in
    'Freeze and Delegate KLV')
        read -p "Enter how much you want to FREEZE: " amt
        echo -e "You are about to FREEZE '$amt' KLV.\n"
        read -p "Are you sure you want to continue? (yes/no) " choice
        echo -e "\n"
        ans='yes'
        if [[ $choice == $ans ]]; then
            docker run -it --rm --user "$(id -u):$(id -g)" \
            -v $(pwd)/wallet:/opt/klever-blockchain \
            --network=host \
            --entrypoint=/usr/local/bin/operator \
            kleverapp/klever-go-testnet:latest \
            --key-file=./walletKey.pem \
            --node=https://node.testnet.klever.finance account freeze $amt

            echo -e "\n"
            read -p "Enter the txHash from the FREEZE output above: " txhash
            echo -e "\n"

            docker run -it --rm --user "$(id -u):$(id -g)" \
            -v $(pwd)/wallet:/opt/klever-blockchain \
            --network=host \
            --entrypoint=/usr/local/bin/operator \
            kleverapp/klever-go-testnet:latest \
            --key-file=./walletKey.pem \
            tx-by-id \
            $txhash

            echo -e "\n"
            read -p "Enter the ADDRESS you want to delegate to: " addr
            read -p "Enter the BUCKET ID from the output above: " bucket
            echo -e "\n"

            docker run -it --rm --user "$(id -u):$(id -g)" \
            -v $(pwd)/wallet:/opt/klever-blockchain \
            --network=host \
            --entrypoint=/usr/local/bin/operator \
            kleverapp/klever-go-testnet:latest \
            --key-file=./walletKey.pem \
            --node=https://node.testnet.klever.finance \
            account delegate \
            $addr \
            --bucketID=$bucket
        else
            echo "Ok we will exit"
        fi
   echo -e "\n"
      ;;
     'Claim Rewards')
             docker run -it --rm --user "$(id -u):$(id -g)" \
             -v $(pwd)/wallet:/opt/klever-blockchain \
             --network=host \
             --entrypoint=/usr/local/bin/operator \
             kleverapp/klever-go-testnet:latest \
             --key-file=./walletKey.pem \
             --node=https://node.testnet.klever.finance \
             account claim 1
             echo -e "\n"
      ;;
      'Send KLV')
      read -p "Enter the recieving address: " n1
      read -p "Enter the amount to send: " n2
      echo -e "You are about to send '$n2' KLV to '$n1'\n"
      read -p "Are you sure you want to continue? (yes/no) " choice
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
done                                                                                               54,5-12       Top
