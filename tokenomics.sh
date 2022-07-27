#!/bin/bash

# Retrieve stats for KDA Tokenomics
# Written by Maik @ community-node.ath.cx - 2022
# Written by JP @ theklevernator.com - 2022
# Version 0.1.0

# Updated July 26, 2022

KDAFILE='<PATH_TO_KDAFILE>/kda.html'

truncate -s 0 $KDAFILE

KFISTATS='curl https://api.mainnet.klever.finance/v1.0/assets/KFI'
KLVSTATS='curl https://api.mainnet.klever.finance/v1.0/assets/KLV'
KIDSTATS='curl https://api.mainnet.klever.finance/v1.0/assets/KID-36W3'
AEDKSTATS='curl https://api.mainnet.klever.finance/v1.0/assets/AEDK-2V89'
LMTSTATS='curl https://api.mainnet.klever.finance/v1.0/assets/LMT-KGIA'
NVRSTATS='curl https://api.mainnet.klever.finance/v1.0/assets/NVR-3NSO'
DVKSTATS='curl https://api.mainnet.klever.finance/v1.0/assets/DVK-34ZH'
BBSTSTATS='curl https://api.mainnet.klever.finance/v1.0/assets/BBST-33Q7'
RLXSTATS='curl https://api.mainnet.klever.finance/v1.0/assets/RLX-ZOS9'
CYBSTATS='curl https://api.mainnet.klever.finance/v1.0/assets/CYB-3CAO'


#### Metrics

MAX=.data.asset.maxSupply
CIR=.data.asset.circulatingSupply
STAKED=.data.asset.staking.totalStaked

## Tokenomics and Extended Metrics ##

#KLV
klvmax=$($KLVSTATS | jq $MAX/1000000)
klvcir=$($KLVSTATS | jq $CIR/1000000)
klvstaked=$($KLVSTATS | jq $STAKED/1000000)
echo "MaxKLV" $klvmax >> $KDAFILE
echo "CircKLV" $klvcir >> $KDAFILE
echo "StakedKLV" $klvstaked >> $KDAFILE

#KFI
kfimax=$($KFISTATS | jq $MAX/1000000)
kficir=$($KFISTATS | jq $CIR/1000000)
kfistaked=$($KFISTATS | jq $STAKED/1000000)
echo "MaxKFI" $kfimax >> $KDAFILE
echo "CircKFI" $kficir >> $KDAFILE
echo "StakedKFI" $kfistaked >> $KDAFILE

#KID
kidmax=$($KIDSTATS | jq $MAX/1000)
kidcir=$($KIDSTATS | jq $CIR/1000)
kidstaked=$($KIDSTATS | jq $STAKED/1000)
echo "MaxKID" $kidmax >> $KDAFILE
echo "CircKID" $kidcir >> $KDAFILE
echo "StakedKID" $kidstaked >> $KDAFILE

#AEDK
aedkmax=$($AEDKSTATS | jq $MAX/1000000)
aedkcir=$($AEDKSTATS | jq $CIR/1000000)
aedkstaked=$($AEDKSTATS | jq $STAKED/1000000)
echo "MaxAEDK" $aedkmax >> $KDAFILE
echo "CircAEDK" $aedkcir >> $KDAFILE
echo "StakedAEDK" $aedkstaked >> $KDAFILE

#LMT
lmtmax=$($LMTSTATS | jq $MAX/1000000)
lmtcir=$($LMTSTATS | jq $CIR/1000000)
lmtstaked=$($LMTSTATS | jq $STAKED/1000000)
echo "MaxLMT" $lmtmax >> $KDAFILE
echo "CircLMT" $lmtcir >> $KDAFILE
echo "StakedLMT" $lmtstaked >> $KDAFILE

#NVR
nvrmax=$($NVRSTATS | jq $MAX/1000000)
nvrcir=$($NVRSTATS | jq $CIR/1000000)
nvrstaked=$($NVRSTATS | jq $STAKED/1000000)
echo "MaxNVR" $nvrmax >> $KDAFILE
echo "CircNVR" $nvrcir >> $KDAFILE
echo "StakedNVR" $nvrstaked >> $KDAFILE

#DVK
dvkmax=$($DVKSTATS | jq $MAX/1000000)
dvkcir=$($DVKSTATS | jq $CIR/1000000)
dvkstaked=$($DVKSTATS | jq $STAKED/1000000)
echo "MaxDVK" $dvkmax >> $KDAFILE
echo "CircDVK" $dvkcir >> $KDAFILE
echo "StakedDVK" $dvkstaked >> $KDAFILE

#BBST
bbstmax=$($BBSTSTATS | jq $MAX/1000000)
bbstcir=$($BBSTSTATS | jq $CIR/1000000)
bbststaked=$($BBSTSTATS | jq $STAKED/1000000)
echo "MaxBBST" $bbstmax >> $KDAFILE
echo "CircBBST" $bbstcir >> $KDAFILE
echo "StakedBBST" $bbststaked >> $KDAFILE

#RLX
rlxmax=$($RLXSTATS | jq $MAX/1000000)
rlxcir=$($RLXSTATS | jq $CIR/1000000)
rlxstaked=$($RLXSTATS | jq $STAKED/1000000)
echo "MaxRLX" $rlxmax >> $KDAFILE
echo "CircRLX" $rlxcir >> $KDAFILE
echo "StakedRLX" $rlxstaked >> $KDAFILE


# That's to prevent broken values at Grafana Dashboard.
sleep 5
