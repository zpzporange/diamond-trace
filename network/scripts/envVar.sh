#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem
export PEER0_MiningCompany_CA=${PWD}/organizations/peerOrganizations/miningcompany.example.com/tlsca/tlsca.miningcompany.example.com-cert.pem
export PEER0_CuttingCompany_CA=${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/tlsca/tlsca.cuttingcompany.example.com-cert.pem
export PEER0_GradingLab_CA=${PWD}/organizations/peerOrganizations/gradinglab.example.com/tlsca/tlsca.gradinglab.example.com-cert.pem
export PEER0_JewelryMaker_CA=${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/tlsca/tlsca.jewelrymaker.example.com-cert.pem

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"

  case $USING_ORG in
  MiningCompanyMSP)
    export CORE_PEER_LOCALMSPID="MiningCompanyMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_MiningCompany_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/miningcompany.example.com/users/Admin@miningcompany.example.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
    ;;
  CuttingCompanyMSP)
    export CORE_PEER_LOCALMSPID="CuttingCompanyMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_CuttingCompany_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/users/Admin@cuttingcompany.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    ;;
  GradingLabMSP)
    export CORE_PEER_LOCALMSPID="GradingLabMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_GradingLab_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/gradinglab.example.com/users/Admin@gradinglab.example.com/msp
    export CORE_PEER_ADDRESS=localhost:10051
    ;;
  JewelryMakerMSP)
    export CORE_PEER_LOCALMSPID="JewelryMakerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_JewelryMaker_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/users/Admin@jewelrymaker.example.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
    ;;
  *)
    errorln "ORG Unknown"
    ;;
  esac

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi

  case $USING_ORG in
  MiningCompanyMSP)
    export CORE_PEER_ADDRESS=peer0.miningcompany.example.com:8051
    ;;
  CuttingCompanyMSP)
    export CORE_PEER_ADDRESS=peer0.cuttingcompany.example.com:9051
    ;;
  GradingLabMSP)
    export CORE_PEER_ADDRESS=peer0.gradinglab.example.com:10051
    ;;
  JewelryMakerMSP)
    export CORE_PEER_ADDRESS=peer0.jewelrymaker.example.com:11051
    ;;
  *)
    errorln "ORG Unknown"
    ;;
  esac
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=()
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.$1"
    ## Set peer addresses
    if [ -z "$PEERS" ]; then
      PEERS="$PEER"
    else
      PEERS="$PEERS $PEER"
    fi
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
    ## Set path to TLS certificate
    CA=PEERPEM
    TLSINFO=(--tlsRootCertFiles "${!CA}")
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" "${TLSINFO[@]}")
    # shift by one to get to the next organization
    shift
  done
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
