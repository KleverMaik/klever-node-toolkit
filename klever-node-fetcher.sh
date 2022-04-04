#!/bin/bash

# retrieve status of Validator node (eligible, elected, jailed)
# written by Maik @ community-node.ath.cx - 2022
# version 0.3

METRICS='curl http://YOURIP:8080/node/status'
PEERS='curl http://YOURIP:8080/validator/statistics'
OUTPUT=`
curl -H "Accept: application/json" \
     -H "Content-Type: application/json" \
     -i "http://YOURIP:8080/node/status"`
     
if ! echo "$OUTPUT" | grep -oP 'eligible'; 

then

    rm /var/www/localhost/htdocs/status.json
    echo "klv_peer_type 1" >> /var/www/localhost/htdocs/status.json

elif ! echo "$OUTPUT" | grep -oP 'jailed';

then
    rm /var/www/localhost/htdocs/status.json
    echo "klv_peer_type 3" >> /var/www/localhost/htdocs/status.json

else
    rm /var/www/localhost/htdocs/status.json
    echo "klv_peer_type 0" >> /var/www/localhost/htdocs/status.json

fi
# From here start to fetch values of the node status
# - just extent as needed
# hnonce=$($METRICS | jq '.data.metrics.klv_probable_highest_nonce')

# echo "klv_probable_highest_nonce $hnonce" >> /var/www/localhost/htdocs/status.json

# From here start to fetch values of Validator statistics
# 1. modify YOUR_BLSKEY with your own node key
# 2. fetch the values

struct=.data.statistics.
var1=.Rating
var2=.TotalNumValidatorSuccess
var3=.TotalNumLeaderFailure
BLSkey=YOUR_BLSKEY
BLSkey=\"$BLSkey\"
# echo $struct$BLSkey$struct2
rating=$($PEERS | jq $struct$BLSkey$var1)
valisuccess=$($PEERS | jq $struct$BLSkey$var2)
missed=$($PEERS | jq $struct$BLSkey$var3)


echo "Rating $rating"  >> /var/www/localhost/htdocs/status.json
echo "TotalNumValidatorSuccess $valisuccess" >> /var/www/localhost/htdocs/status.json
echo "TotalNumLeaderFailure $missed" >> /var/www/localhost/htdocs/status.json

