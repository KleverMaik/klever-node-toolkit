#!/bin/bash

# Retrieve status of Validator node (eligible, elected, jailed)
# Written by Maik @ community-node.ath.cx - 2022
# Written by JP @ theklevernator.com - 2022
# Version 0.3.2

# Update the WEBLINK to the path where the status.json file should be stored
WEBLINK='/var/www/localhost/htdocs/status.json'

# Modify the IP or enter your full path to the web address of your server
METRICS='curl http://YOURIP:8080/node/status'
PEERS='curl http://YOURIP:8080/validator/statistics'
OUTPUT=`
curl -H "Accept: application/json" \
     -H "Content-Type: application/json" \
     -i "http://YOURIP:8080/node/status"` 

# Gather YOUR current Node Status
if echo "$OUTPUT" | grep -oP 'elected'; 

then
    rm $WEBLINK
    echo "klv_peer_type 1" >> $WEBLINK 

elif echo "$OUTPUT" | grep -oP 'eligible';

then
    rm $WEBLINK
    echo "klv_peer_type 2" >> $WEBLINK

elif echo "$OUTPUT" | grep -oP 'jailed';

then
    rm $WEBLINK
    echo "klv_peer_type 3" >> $WEBLINK

elif echo "$OUTPUT" | grep -oP 'observer';

then
    rm $WEBLINK
    echo "klv_peer_type 4" >> $WEBLINK

else
    rm $WEBLINK
    echo "klv_peer_type 0" >> $WEBLINK

fi

# From here start to fetch values of the node status
# - just extent as needed
# hnonce=$($METRICS | jq '.data.metrics.klv_probable_highest_nonce')

# echo "klv_probable_highest_nonce $hnonce" >> $WEBLINK

# From here start to fetch values of Validator statistics
# 1. Modify YOUR_BLSKEY with your own node key
# 2. Fetch the values

struct=.data.statistics.
var1=.Rating
var2=.TotalNumValidatorSuccess
var3=.TotalNumLeaderFailure
var4=.TotalNumLeaderSuccess
var5=.TotalNumValidatorIgnoredSignatures
BLSkey=YOUR_BLSKEY
BLSkey=\"$BLSkey\"

rating=$($PEERS | jq $struct$BLSkey$var1)
valisuccess=$($PEERS | jq $struct$BLSkey$var2)
missed=$($PEERS | jq $struct$BLSkey$var3)
leadsuccess=$($PEERS | jq $struct$BLSkey$var4)
ignored=$($PEERS | jq $struct$BLSkey$var5)


# Push metrics to status.json
echo "Rating $rating"  >> $WEBLINK 
echo "TotalNumValidatorSuccess $valisuccess" >> $WEBLINK
echo "TotalNumLeaderFailure $missed" >> $WEBLINK
echo "TotalNumLeaderSuccess $leadsuccess" >> $WEBLINK
echo "TotalNumValidatorIgnoredSignatures $ignored" >> $WEBLINK

# Uncomment below commands if making use of validators-status.py and validators.txt. Reach out to JP if you want the following.

# Create validator.txt file to store complete validator status's (elected, eligible, jailed, waiting, inactive)
#rm <PATH_OF_YOUR_CHOOSING>/validators.txt
#$PEERS >> <PATH_OF_YOUR_CHOOSING>/validators.txt

# Execute validatorstatus.py to get validator count and status's
#python3 <PATH_OF_YOUR_CHOOSING>/validators-status.py >> $WEBLINK
