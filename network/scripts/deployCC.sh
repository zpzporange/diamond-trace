#!/bin/bash

source scripts/utils.sh

CHANNEL_NAME=${1:-"mychannel"}
CC_NAME=${2}
CC_SRC_PATH=${3}
CC_SRC_LANGUAGE=${4}
CC_VERSION=${5:-"1.0"}
CC_SEQUENCE=${6:-"1"}
CC_INIT_FCN=${7:-"NA"}
CC_END_POLICY=${8:-"NA"}
CC_COLL_CONFIG=${9:-"NA"}
DELAY=${10:-"3"}
MAX_RETRY=${11:-"5"}
VERBOSE=${12:-"false"}

println "executing with the following"
println "- CHANNEL_NAME: ${C_GREEN}${CHANNEL_NAME}${C_RESET}"
println "- CC_NAME: ${C_GREEN}${CC_NAME}${C_RESET}"
println "- CC_SRC_PATH: ${C_GREEN}${CC_SRC_PATH}${C_RESET}"
println "- CC_SRC_LANGUAGE: ${C_GREEN}${CC_SRC_LANGUAGE}${C_RESET}"
println "- CC_VERSION: ${C_GREEN}${CC_VERSION}${C_RESET}"
println "- CC_SEQUENCE: ${C_GREEN}${CC_SEQUENCE}${C_RESET}"
println "- CC_END_POLICY: ${C_GREEN}${CC_END_POLICY}${C_RESET}"
println "- CC_COLL_CONFIG: ${C_GREEN}${CC_COLL_CONFIG}${C_RESET}"
println "- CC_INIT_FCN: ${C_GREEN}${CC_INIT_FCN}${C_RESET}"
println "- DELAY: ${C_GREEN}${DELAY}${C_RESET}"
println "- MAX_RETRY: ${C_GREEN}${MAX_RETRY}${C_RESET}"
println "- VERBOSE: ${C_GREEN}${VERBOSE}${C_RESET}"

INIT_REQUIRED="--init-required"
# check if the init fcn should be called
if [ "$CC_INIT_FCN" = "NA" ]; then
  INIT_REQUIRED=""
fi

if [ "$CC_END_POLICY" = "NA" ]; then
  CC_END_POLICY=""
else
  CC_END_POLICY="--signature-policy $CC_END_POLICY"
fi

if [ "$CC_COLL_CONFIG" = "NA" ]; then
  CC_COLL_CONFIG=""
else
  CC_COLL_CONFIG="--collections-config $CC_COLL_CONFIG"
fi

FABRIC_CFG_PATH=$PWD/config/

# import utils
. scripts/envVar.sh
. scripts/ccutils.sh

function checkPrereqs() {
  jq --version > /dev/null 2>&1

  if [[ $? -ne 0 ]]; then
    errorln "jq command not found..."
    errorln
    errorln "Follow the instructions in the Fabric docs to install the prereqs"
    errorln "https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html"
    exit 1
  fi
}

## Function to set environment variables for a given organization
setGlobals() {
  ORG=$1
  DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
  ORDERER_CA=${DIR}/test-network/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem

  if [[ ${ORG,,} == "miningcompanymsp" ]]; then
    CORE_PEER_LOCALMSPID=MiningCompanyMSP
    CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/miningcompany.example.com/users/Admin@miningcompany.example.com/msp
    CORE_PEER_ADDRESS=localhost:8051
    CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/miningcompany.example.com/tlsca/tlsca.miningcompany.example.com-cert.pem
    PEER0_ORG1_CA=${DIR}/test-network/organizations/peerOrganizations/miningcompany.example.com/tlsca/tlsca.miningcompany.example.com-cert.pem

  elif [[ ${ORG,,} == "cuttingcompanymsp" ]]; then
    CORE_PEER_LOCALMSPID=CuttingCompanyMSP
    CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/cuttingcompany.example.com/users/Admin@cuttingcompany.example.com/msp
    CORE_PEER_ADDRESS=localhost:9051
    CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/cuttingcompany.example.com/tlsca/tlsca.cuttingcompany.example.com-cert.pem
    PEER0_ORG2_CA=${DIR}/test-network/organizations/peerOrganizations/cuttingcompany.example.com/tlsca/tlsca.cuttingcompany.example.com-cert.pem

  elif [[ ${ORG,,} == "gradinglabmsp" ]]; then
    CORE_PEER_LOCALMSPID=GradingLabMSP
    CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/gradinglab.example.com/users/Admin@gradinglab.example.com/msp
    CORE_PEER_ADDRESS=localhost:10051
    CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/gradinglab.example.com/tlsca/tlsca.gradinglab.example.com-cert.pem
    PEER0_ORG3_CA=${DIR}/test-network/organizations/peerOrganizations/gradinglab.example.com/tlsca/tlsca.gradinglab.example.com-cert.pem

  elif [[ ${ORG,,} == "jewelrymakermsp" ]]; then
    CORE_PEER_LOCALMSPID=JewelryMakerMSP
    CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/jewelrymaker.example.com/users/Admin@jewelrymaker.example.com/msp
    CORE_PEER_ADDRESS=localhost:11051
    CORE_PEER_TLS_ROOTCERT_FILE=${DIR}/test-network/organizations/peerOrganizations/jewelrymaker.example.com/tlsca/tlsca.jewelrymaker.example.com-cert.pem
    PEER0_ORG4_CA=${DIR}/test-network/organizations/peerOrganizations/jewelrymaker.example.com/tlsca/tlsca.jewelrymaker.example.com-cert.pem

  else
    echo "Unknown \"$ORG\", please choose MiningCompanyMSP, CuttingCompanyMSP, GradingLabMSP, or JewelryMakerMSP"
    exit 1
  fi
}

# check for prerequisites
checkPrereqs

## package the chaincode
./scripts/packageCC.sh $CC_NAME $CC_SRC_PATH $CC_SRC_LANGUAGE $CC_VERSION 

PACKAGE_ID=$(peer lifecycle chaincode calculatepackageid ${CC_NAME}.tar.gz)

## Install chaincode on peer0.org1 and peer0.org2
infoln "Installing chaincode on peer0.miningcompanymsp..."
installChaincode MiningCompanyMSP
infoln "Installing chaincode on peer0.cuttingcompanymsp..."
installChaincode CuttingCompanyMSP
infoln "Installing chaincode on peer0.gradinglabmsp..."
installChaincode GradingLabMSP
infoln "Installing chaincode on peer0.jewelrymakermsp..."
installChaincode JewelryMakerMSP

resolveSequence

## query whether the chaincode is installed
queryInstalled MiningCompanyMSP
queryInstalled CuttingCompanyMSP
queryInstalled GradingLabMSP
queryInstalled JewelryMakerMSP

## approve the definition for each org
approveForMyOrg MiningCompanyMSP
approveForMyOrg CuttingCompanyMSP
approveForMyOrg GradingLabMSP
approveForMyOrg JewelryMakerMSP

## check whether the chaincode definition is ready to be committed
## expect all orgs to have approved
checkCommitReadiness MiningCompanyMSP "\"MiningCompanyMSP\": true" "\"CuttingCompanyMSP\": true" "\"GradingLabMSP\": true" "\"JewelryMakerMSP\": true"
checkCommitReadiness CuttingCompanyMSP "\"MiningCompanyMSP\": true" "\"CuttingCompanyMSP\": true" "\"GradingLabMSP\": true" "\"JewelryMakerMSP\": true"
checkCommitReadiness GradingLabMSP "\"MiningCompanyMSP\": true" "\"CuttingCompanyMSP\": true" "\"GradingLabMSP\": true" "\"JewelryMakerMSP\": true"
checkCommitReadiness JewelryMakerMSP "\"MiningCompanyMSP\": true" "\"CuttingCompanyMSP\": true" "\"GradingLabMSP\": true" "\"JewelryMakerMSP\": true"

## now that we know for sure all orgs have approved, commit the definition
commitChaincodeDefinition MiningCompanyMSP CuttingCompanyMSP GradingLabMSP JewelryMakerMSP

## query on all orgs to see that the definition committed successfully
queryCommitted MiningCompanyMSP
queryCommitted CuttingCompanyMSP
queryCommitted GradingLabMSP
queryCommitted JewelryMakerMSP

## Invoke the chaincode - this does require that the chaincode have the 'initLedger'
## method defined
if [ "$CC_INIT_FCN" = "NA" ]; then
  infoln "Chaincode initialization is not required"
else
  chaincodeInvokeInit MiningCompanyMSP CuttingCompanyMSP GradingLabMSP JewelryMakerMSP
fi

exit 0