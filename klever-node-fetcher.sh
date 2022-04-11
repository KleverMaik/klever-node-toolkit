#!/bin/bash

# Retrieve status of Validator node (eligible, elected, jailed)
# Written by Maik @ community-node.ath.cx - 2022
# Written by JP @ theklevernator.com - 2022
# Version 0.3.5

# Update the WEBLINK to the path where the status.json file should be stored
WEBLINK='/var/www/localhost/htdocs/status.json'
XSTATS='/var/www/localhost/htdocs/xstats.json'
#Clear out the file
truncate -s 0 $WEBLINK

# Modify the IP or enter your full path to the web address of your server
METRICS='curl http://YOURIP:8080/node/status'
PEERS='curl http://YOURIP:8080/validator/statistics'
BALANCE='curl http://YOURIP:8080/address/YOUR_ADDRESS'
OUTPUT=`
curl -H "Accept: application/json" \
     -H "Content-Type: application/json" \
     -i "http://YOURIP:8080/node/status"` 

# Gather YOUR current Node Status
if echo "$OUTPUT" | grep -oP 'elected'; 
then
    echo "klv_peer_type 1" >> $WEBLINK 

elif echo "$OUTPUT" | grep -oP 'eligible';
then
    echo "klv_peer_type 2" >> $WEBLINK

elif echo "$OUTPUT" | grep -oP 'jailed';
then
    echo "klv_peer_type 3" >> $WEBLINK

elif echo "$OUTPUT" | grep -oP 'observer';
then
    echo "klv_peer_type 4" >> $WEBLINK

else
    echo "klv_peer_type 0" >> $WEBLINK
fi

# Get Node Consensus Slot State
if echo "$OUTPUT" | grep -oP 'signed';
then
    echo "klv_slot_state 1" >> $WEBLINK
else
    echo "klv_slot_stats 2" >> $WEBLINK
fi

# From here start to fetch values of the node status
# - just extent as needed
# hnonce=$($METRICS | jq '.data.metrics.klv_probable_highest_nonce')
# echo "klv_probable_highest_nonce $hnonce" >> $WEBLINK

# From here start to fetch values of Validator statistics
# -> Modify YOUR_BLSKEY with your own node key

struct=.data.statistics.
bal=.data.account
var1=.Rating
var2=.TotalNumValidatorSuccess
var3=.TotalNumLeaderFailure
var4=.TotalNumLeaderSuccess
var5=.TotalNumValidatorIgnoredSignatures
var6=.Balance
var7=.Allowance
var8=.data.metrics.
var9=.TotalNumValidatorFailure
BLSkey=YOUR_BLSKEY
BLSkey=\"$BLSkey\"
kversion=klv_app_version
NVersion=\"$kversion\"
temp=''

rating=$($PEERS | jq $struct$BLSkey$var1)
valisuccess=$($PEERS | jq $struct$BLSkey$var2)
missed=$($PEERS | jq $struct$BLSkey$var3)
leadsuccess=$($PEERS | jq $struct$BLSkey$var4)
ignored=$($PEERS | jq $struct$BLSkey$var5)
balance=$($BALANCE | jq $bal$var6/1000000)
allowance=$($BALANCE | jq $bal$var7)
allowvalue=$(($allowance/1000000))
valifailure=$($PEERS | jq $struct$BLSkey$var9)

# Version export to be activated if needed
#nversion=$($METRICS | jq $var8$kversion | grep -oP '.*?(?=/go)' | sed 's/"//g')
#echo "Node_Version $nversion" >> $XSTATS

# Push metrics to status.json
echo "Rating $rating"  >> $WEBLINK 
echo "TotalNumValidatorSuccess $valisuccess" >> $WEBLINK
echo "TotalNumValidatorFailure $valifailure" >> $WEBLINK
echo "TotalNumLeaderFailure $missed" >> $WEBLINK
echo "TotalNumLeaderSuccess $leadsuccess" >> $WEBLINK
echo "TotalNumValidatorIgnoredSignatures $ignored" >> $WEBLINK
echo "AvailableBalance $balance" >> $WEBLINK
if [ -z "$allowance" ];
    then echo "ClaimableRewards 1" >> $WEBLINK
    else echo "ClaimableRewards $allowvalue" >> $WEBLINK
fi

# Uncomment below commands if making use of the validators-status.py script also provided. Do not uncomment if not using the script.
# Create validator.txt file to store complete validator status's (elected, eligible, jailed, waiting, inactive).
#rm <PATH_OF_YOUR_CHOOSING>/validators.txt
#$PEERS >> <PATH_OF_YOUR_CHOOSING>/validators.txt

# Execute validator-status.py to push validator count and status's to $WEBLINK
#python3 <PATH_OF_YOUR_CHOOSING>/validators-status.py >> $WEBLINK

