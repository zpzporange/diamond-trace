#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0

# default to using MiningCompany
ORG=${1:-MiningCompanyMSP}

# Exit on first error, print all commands.
set -e
set -o pipefail

# Where am I?
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ORDERER_CA=${DIR}/test-network/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem

# Define CA and Peer PEM paths for each organization
PEER0_MiningCompany_CA=${DIR}/test-network/organizations/peerOrganizations/miningcompany.example.com/tlsca/tlsca.miningcompany.example.com-cert.pem
PEER0_CuttingCompany_CA=${DIR}/test-network/organizations/peerOrganizations/cuttingcompany.example.com/tlsca/tlsca.cuttingcompany.example.com-cert.pem
PEER0_GradingLab_CA=${DIR}/test-network/organizations/peerOrganizations/gradinglab.example.com/tlsca/tlsca.gradinglab.example.com-cert.pem
PEER0_JewelryMaker_CA=${DIR}/test-network/organizations/peerOrganizations/jewelrymaker.example.com/tlsca/tlsca.jewelrymaker.example.com-cert.pem

# Set environment variables based on the selected organization
if [[ ${ORG,,} == "miningcompanymsp" ]]; then
   CORE_PEER_LOCALMSPID=MiningCompanyMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/miningcompany.example.com/users/Admin@miningcompany.example.com/msp
   CORE_PEER_ADDRESS=localhost:8051
   CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_MiningCompany_CA}

elif [[ ${ORG,,} == "cuttingcompanymsp" ]]; then
   CORE_PEER_LOCALMSPID=CuttingCompanyMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/cuttingcompany.example.com/users/Admin@cuttingcompany.example.com/msp
   CORE_PEER_ADDRESS=localhost:9051
   CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_CuttingCompany_CA}

elif [[ ${ORG,,} == "gradinglabmsp" ]]; then
   CORE_PEER_LOCALMSPID=GradingLabMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/gradinglab.example.com/users/Admin@gradinglab.example.com/msp
   CORE_PEER_ADDRESS=localhost:10051
   CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_GradingLab_CA}

elif [[ ${ORG,,} == "jewelrymakermsp" ]]; then
   CORE_PEER_LOCALMSPID=JewelryMakerMSP
   CORE_PEER_MSPCONFIGPATH=${DIR}/test-network/organizations/peerOrganizations/jewelrymaker.example.com/users/Admin@jewelrymaker.example.com/msp
   CORE_PEER_ADDRESS=localhost:11051
   CORE_PEER_TLS_ROOTCERT_FILE=${PEER0_JewelryMaker_CA}

else
   echo "Unknown \"$ORG\", please choose MiningCompanyMSP, CuttingCompanyMSP, GradingLabMSP, or JewelryMakerMSP"
   echo "For example to get the environment variables to set up a MiningCompanyMSP shell environment run:  ./setOrgEnv.sh MiningCompanyMSP"
   echo
   echo "This can be automated to set them as well with:"
   echo
   echo 'export $(./setOrgEnv.sh MiningCompanyMSP | xargs)'
   exit 1
fi

# Output the variables that need to be set
echo "CORE_PEER_TLS_ENABLED=true"
echo "ORDERER_CA=${ORDERER_CA}"
echo "PEER0_MININGCOMPANY_CA=${PEER0_MiningCompany_CA}"
echo "PEER0_CUTTINGCOMPANY_CA=${PEER0_CuttingCompany_CA}"
echo "PEER0_GRADINGLAB_CA=${PEER0_GradingLab_CA}"
echo "PEER0_JEWELRYMAKER_CA=${PEER0_JewelryMaker_CA}"

echo "CORE_PEER_MSPCONFIGPATH=${CORE_PEER_MSPCONFIGPATH}"
echo "CORE_PEER_ADDRESS=${CORE_PEER_ADDRESS}"
echo "CORE_PEER_TLS_ROOTCERT_FILE=${CORE_PEER_TLS_ROOTCERT_FILE}"

echo "CORE_PEER_LOCALMSPID=${CORE_PEER_LOCALMSPID}"