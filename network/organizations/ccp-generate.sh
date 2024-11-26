#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

# MiningCompanyMSP
ORG=MiningCompanyMSP
P0PORT=8051
CAPORT=8054
PEERPEM=../organizations/peerOrganizations/miningcompany.example.com/tlsca/tlsca.miningcompany.example.com-cert.pem
CAPEM=../organizations/peerOrganizations/miningcompany.example.com/ca/ca.miningcompany.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/miningcompany.example.com/connection-miningcompany.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/miningcompany.example.com/connection-miningcompany.yaml

# CuttingCompanyMSP
ORG=CuttingCompanyMSP
P0PORT=9051
CAPORT=9054
PEERPEM=../organizations/peerOrganizations/cuttingcompany.example.com/tlsca/tlsca.cuttingcompany.example.com-cert.pem
CAPEM=../organizations/peerOrganizations/cuttingcompany.example.com/ca/ca.cuttingcompany.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/cuttingcompany.example.com/connection-cuttingcompany.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/cuttingcompany.example.com/connection-cuttingcompany.yaml

# GradingLabMSP
ORG=GradingLabMSP
P0PORT=10051
CAPORT=10054
PEERPEM=../organizations/peerOrganizations/gradinglab.example.com/tlsca/tlsca.gradinglab.example.com-cert.pem
CAPEM=../organizations/peerOrganizations/gradinglab.example.com/ca/ca.gradinglab.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/gradinglab.example.com/connection-gradinglab.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/gradinglab.example.com/connection-gradinglab.yaml

# JewelryMakerMSP
ORG=JewelryMakerMSP
P0PORT=11051
CAPORT=11054
PEERPEM=../organizations/peerOrganizations/jewelrymaker.example.com/tlsca/tlsca.jewelrymaker.example.com-cert.pem
CAPEM=../organizations/peerOrganizations/jewelrymaker.example.com/ca/ca.jewelrymaker.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/jewelrymaker.example.com/connection-jewelrymaker.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ../organizations/peerOrganizations/jewelrymaker.example.com/connection-jewelrymaker.yaml