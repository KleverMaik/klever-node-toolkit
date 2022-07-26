#!/bin/bash

# Retrieve status of Validator node (eligible, elected, jailed)
# Written by Maik @ community-node.ath.cx - 2022
# Written by JP @ theklevernator.com - 2022
# Version 0.5.3

# retrieve metrics and store at temporary file
truncate -s 0 /tmp/nodestat.tmp
truncate -s 0 /tmp/valistat.tmp

# Modify the IP or enter your full path to the web address of your server and your wallet address
BALANCE='curl http://YOUR_IP:8080/address/YOUR_WALLET_ADDRESS'
curl http://YOUR_IP:8080/node/status >> /tmp/nodestat.tmp
curl http://YOUR_IP:8080/validator/statistics >> /tmp/valistat.tmp

# Path to the web directory of your server - you may have to update
STATSFILE='/var/www/localhost/htdocs/status.json'

# local files to store the values
METRICS='cat /tmp/nodestat.tmp'
PEERS='cat /tmp/valistat.tmp'
TEMPFILE='/tmp/status.json'

#Clear out the file
truncate -s 0 $TEMPFILE

# Gather YOUR current Node Status
if $METRICS | grep -oP 'elected'; 
then
    echo "klv_peer_type 1" >> $TEMPFILE 

elif $METRICS | grep -oP 'eligible';
then
    echo "klv_peer_type 2" >> $TEMPFILE

elif $METRICS | grep -oP 'jailed';
then
    echo "klv_peer_type 3" >> $TEMPFILE

elif $METRICS | grep -oP 'inactive';
then
    echo "klv_peer_type 4" >> $TEMPFILE

elif $METRICS | grep -oP 'waiting';
then
    echo "klv_peer_type 5" >> $TEMPFILE
    
else
    echo "klv_peer_type 0" >> $TEMPFILE
fi

# Get Node Consensus Slot State
if echo "$METRICS" | grep -oP 'signed';
then
    echo "klv_slot_state 1" >> $TEMPFILE
else
    echo "klv_slot_state 2" >> $TEMPFILE
fi

# From here start to fetch values of the node status
# - just extent as needed
# hnonce=$($METRICS | jq '.data.metrics.klv_probable_highest_nonce')
# echo "klv_probable_highest_nonce $hnonce" >> $TEMPFILE

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
temp=''

rating=$($PEERS | jq $struct$BLSkey$var1)
valisuccess=$($PEERS | jq $struct$BLSkey$var2*1)
missed=$($PEERS | jq $struct$BLSkey$var3*1)
leadsuccess=$($PEERS | jq $struct$BLSkey$var4*1)
ignored=$($PEERS | jq $struct$BLSkey$var5*1)
balance=$($BALANCE | jq $bal$var6/1000000)
allowance=$($BALANCE | jq $bal$var7)
allowvalue=$(($allowance/1000000))
valifailure=$($PEERS | jq $struct$BLSkey$var9)

# Push metrics to status.json
if [ -z "$valisuccess" ]; 
	then echo "TotalNumValidatorSuccess 0" >> $TEMPFILE
	else echo "TotalNumValidatorSuccess $valisuccess" >> $TEMPFILE
fi

if [ -z "$missed" ];
	then echo "TotalNumLeaderFailure 0" >> $TEMPFILE
	else echo "TotalNumLeaderFailure $missed" >> $TEMPFILE
fi

if [ -z "$leadsuccess" ];
	then echo "TotalNumLeaderSuccess 0" >> $TEMPFILE
	else echo "TotalNumLeaderSuccess $leadsuccess" >> $TEMPFILE
fi

if [ -z "$ignored" ];
	then echo "TotalNumValidatorIgnoredSignatures 0" >> $TEMPFILE
	else echo "TotalNumValidatorIgnoredSignatures $ignored" >> $TEMPFILE
fi

if [ -z "$balance" ];
	then echo "AvailableBalance 1" >> $TEMPFILE
	else echo "AvailableBalance $balance" >> $TEMPFILE
fi

if [ -z "$allowance" ];
	then echo "ClaimableRewards 1" >> $TEMPFILE
	else echo "ClaimableRewards $allowvalue" >> $TEMPFILE
fi

# Just decide the Exchange where the Price should be retrieved from.
# 1. Klever Exchange
#KLVPRICE='curl https://api.exchange.klever.io/v1/market/ticker?symbol=KLV-USDT'
#priceval=.price

# 2. Kucoin
KLVPRICE='curl https://api.kucoin.com/api/v1/market/orderbook/level1?symbol=KLV-USDT'
priceval=.data.price

# prepare the retrieved price
calcrew=$($KLVPRICE | jq $priceval | sed 's/.\(.*\)/\1/' | sed 's/\(.*\)./\1/')

# Calculate the rewards and display the price per KLV
echo "KLVPrice" $calcrew >> $TEMPFILE
echo "CalcRewards " | tr -d '\n' >> $TEMPFILE
echo "$calcrew $allowvalue" | awk '{print $1 * $2}'  >> $TEMPFILE
echo "CalcBalance " | tr -d '\n' >> $TEMPFILE
echo "$calcrew $balance" | awk '{print $1 * $2}'  >> $TEMPFILE

# Uncomment below commands if making use of the validators-status.py script also provided. Do not uncomment if not using the script.
# Create validator.txt file to store complete validator status's (elected, eligible, jailed, waiting, inactive).
#rm <PATH_OF_YOUR_CHOOSING>/validators.txt
#$PEERS >> <PATH_OF_YOUR_CHOOSING>/validators.txt

# Execute validator-status.py to push validator count and status's to $TEMPFILE
#python3 <PATH_OF_YOUR_CHOOSING>/validators-status.py >> $TEMPFILE

# rating of Validtor node - if node is running as Observer, value is NULL - output changed to 0
if echo "$rating" | grep -oP 'null';
then 
echo 'Rating 0'  >> $TEMPFILE
else 
echo "Rating $rating"  >> $TEMPFILE 
fi

# Break of defined time until the loaded file replaces the status.json after loading all values.
# That's to prevent broken values at Grafana Dashboard.
sleep 5
cp -f $TEMPFILE $STATSFILE
