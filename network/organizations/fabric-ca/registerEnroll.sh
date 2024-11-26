#!/bin/bash

function createMiningCompany() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/miningcompany.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/miningcompany.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-miningcompany --tls.certfiles "${PWD}/organizations/fabric-ca/miningcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-miningcompany.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-miningcompany.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-miningcompany.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-miningcompany.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/miningcompany.example.com/msp/config.yaml"

  # Copy mining company's CA cert to the appropriate directories
  mkdir -p "${PWD}/organizations/peerOrganizations/miningcompany.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/miningcompany/ca-cert.pem" "${PWD}/organizations/peerOrganizations/miningcompany.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/miningcompany.example.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/miningcompany/ca-cert.pem" "${PWD}/organizations/peerOrganizations/miningcompany.example.com/tlsca/tlsca.miningcompany.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/miningcompany.example.com/ca"
  cp "${PWD}/organizations/fabric-ca/miningcompany/ca-cert.pem" "${PWD}/organizations/peerOrganizations/miningcompany.example.com/ca/ca.miningcompany.example.com-cert.pem"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-miningcompany --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/miningcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-miningcompany --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/miningcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-miningcompany --id.name miningcompanyadmin --id.secret miningcompanyadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/miningcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-miningcompany -M "${PWD}/organizations/peerOrganizations/miningcompany.example.com/peers/peer0.miningcompany.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/miningcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/miningcompany.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/miningcompany.example.com/peers/peer0.miningcompany.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates, use --csr.hosts to specify Subject Alternative Names"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-miningcompany -M "${PWD}/organizations/peerOrganizations/miningcompany.example.com/peers/peer0.miningcompany.example.com/tls" --enrollment.profile tls --csr.hosts peer0.miningcompany.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/miningcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/miningcompany.example.com/peers/peer0.miningcompany.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/miningcompany.example.com/peers/peer0.miningcompany.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/miningcompany.example.com/peers/peer0.miningcompany.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/miningcompany.example.com/peers/peer0.miningcompany.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/miningcompany.example.com/peers/peer0.miningcompany.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/miningcompany.example.com/peers/peer0.miningcompany.example.com/tls/server.key"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-miningcompany -M "${PWD}/organizations/peerOrganizations/miningcompany.example.com/users/User1@miningcompany.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/miningcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/miningcompany.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/miningcompany.example.com/users/User1@miningcompany.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://miningcompanyadmin:miningcompanyadminpw@localhost:8054 --caname ca-miningcompany -M "${PWD}/organizations/peerOrganizations/miningcompany.example.com/users/Admin@miningcompany.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/miningcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/miningcompany.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/miningcompany.example.com/users/Admin@miningcompany.example.com/msp/config.yaml"
}

function createCuttingCompany() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/cuttingcompany.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-cuttingcompany --tls.certfiles "${PWD}/organizations/fabric-ca/cuttingcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-cuttingcompany.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-cuttingcompany.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-cuttingcompany.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-cuttingcompany.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/msp/config.yaml"

  # Copy cutting company's CA cert to the appropriate directories
  mkdir -p "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/cuttingcompany/ca-cert.pem" "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/cuttingcompany/ca-cert.pem" "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/tlsca/tlsca.cuttingcompany.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/ca"
  cp "${PWD}/organizations/fabric-ca/cuttingcompany/ca-cert.pem" "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/ca/ca.cuttingcompany.example.com-cert.pem"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-cuttingcompany --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/cuttingcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-cuttingcompany --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/cuttingcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-cuttingcompany --id.name cuttingcompanyadmin --id.secret cuttingcompanyadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/cuttingcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-cuttingcompany -M "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/peers/peer0.cuttingcompany.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/cuttingcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/peers/peer0.cuttingcompany.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates, use --csr.hosts to specify Subject Alternative Names"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-cuttingcompany -M "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/peers/peer0.cuttingcompany.example.com/tls" --enrollment.profile tls --csr.hosts peer0.cuttingcompany.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/cuttingcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/peers/peer0.cuttingcompany.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/peers/peer0.cuttingcompany.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/peers/peer0.cuttingcompany.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/peers/peer0.cuttingcompany.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/peers/peer0.cuttingcompany.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/peers/peer0.cuttingcompany.example.com/tls/server.key"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca-cuttingcompany -M "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/users/User1@cuttingcompany.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/cuttingcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/users/User1@cuttingcompany.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://cuttingcompanyadmin:cuttingcompanyadminpw@localhost:9054 --caname ca-cuttingcompany -M "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/users/Admin@cuttingcompany.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/cuttingcompany/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/cuttingcompany.example.com/users/Admin@cuttingcompany.example.com/msp/config.yaml"
}

function createGradingLab() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/gradinglab.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/gradinglab.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-gradinglab --tls.certfiles "${PWD}/organizations/fabric-ca/gradinglab/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-gradinglab.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-gradinglab.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-gradinglab.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-gradinglab.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/gradinglab.example.com/msp/config.yaml"

  # Copy grading lab's CA cert to the appropriate directories
  mkdir -p "${PWD}/organizations/peerOrganizations/gradinglab.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/gradinglab/ca-cert.pem" "${PWD}/organizations/peerOrganizations/gradinglab.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/gradinglab.example.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/gradinglab/ca-cert.pem" "${PWD}/organizations/peerOrganizations/gradinglab.example.com/tlsca/tlsca.gradinglab.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/gradinglab.example.com/ca"
  cp "${PWD}/organizations/fabric-ca/gradinglab/ca-cert.pem" "${PWD}/organizations/peerOrganizations/gradinglab.example.com/ca/ca.gradinglab.example.com-cert.pem"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-gradinglab --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/gradinglab/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-gradinglab --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/gradinglab/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-gradinglab --id.name gradinglabadmin --id.secret gradinglabadminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/gradinglab/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca-gradinglab -M "${PWD}/organizations/peerOrganizations/gradinglab.example.com/peers/peer0.gradinglab.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/gradinglab/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/gradinglab.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/gradinglab.example.com/peers/peer0.gradinglab.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates, use --csr.hosts to specify Subject Alternative Names"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca-gradinglab -M "${PWD}/organizations/peerOrganizations/gradinglab.example.com/peers/peer0.gradinglab.example.com/tls" --enrollment.profile tls --csr.hosts peer0.gradinglab.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/gradinglab/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/gradinglab.example.com/peers/peer0.gradinglab.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/gradinglab.example.com/peers/peer0.gradinglab.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/gradinglab.example.com/peers/peer0.gradinglab.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/gradinglab.example.com/peers/peer0.gradinglab.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/gradinglab.example.com/peers/peer0.gradinglab.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/gradinglab.example.com/peers/peer0.gradinglab.example.com/tls/server.key"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca-gradinglab -M "${PWD}/organizations/peerOrganizations/gradinglab.example.com/users/User1@gradinglab.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/gradinglab/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/gradinglab.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/gradinglab.example.com/users/User1@gradinglab.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://gradinglabadmin:gradinglabadminpw@localhost:10054 --caname ca-gradinglab -M "${PWD}/organizations/peerOrganizations/gradinglab.example.com/users/Admin@gradinglab.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/gradinglab/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/gradinglab.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/gradinglab.example.com/users/Admin@gradinglab.example.com/msp/config.yaml"
}

function createJewelryMaker() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/peerOrganizations/jewelrymaker.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-jewelrymaker --tls.certfiles "${PWD}/organizations/fabric-ca/jewelrymaker/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-jewelrymaker.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-jewelrymaker.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-jewelrymaker.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-jewelrymaker.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/msp/config.yaml"

  # Copy jewelry maker's CA cert to the appropriate directories
  mkdir -p "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/jewelrymaker/ca-cert.pem" "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/msp/tlscacerts/ca.crt"

  mkdir -p "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/jewelrymaker/ca-cert.pem" "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/tlsca/tlsca.jewelrymaker.example.com-cert.pem"

  mkdir -p "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/ca"
  cp "${PWD}/organizations/fabric-ca/jewelrymaker/ca-cert.pem" "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/ca/ca.jewelrymaker.example.com-cert.pem"

  infoln "Registering peer0"
  set -x
  fabric-ca-client register --caname ca-jewelrymaker --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/organizations/fabric-ca/jewelrymaker/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-jewelrymaker --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/organizations/fabric-ca/jewelrymaker/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-jewelrymaker --id.name jewelrymakeradmin --id.secret jewelrymakeradminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/jewelrymaker/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-jewelrymaker -M "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/peers/peer0.jewelrymaker.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/jewelrymaker/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/peers/peer0.jewelrymaker.example.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates, use --csr.hosts to specify Subject Alternative Names"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-jewelrymaker -M "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/peers/peer0.jewelrymaker.example.com/tls" --enrollment.profile tls --csr.hosts peer0.jewelrymaker.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/jewelrymaker/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/peers/peer0.jewelrymaker.example.com/tls/tlscacerts/"* "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/peers/peer0.jewelrymaker.example.com/tls/ca.crt"
  cp "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/peers/peer0.jewelrymaker.example.com/tls/signcerts/"* "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/peers/peer0.jewelrymaker.example.com/tls/server.crt"
  cp "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/peers/peer0.jewelrymaker.example.com/tls/keystore/"* "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/peers/peer0.jewelrymaker.example.com/tls/server.key"

  infoln "Generating the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-jewelrymaker -M "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/users/User1@jewelrymaker.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/jewelrymaker/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/users/User1@jewelrymaker.example.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
  fabric-ca-client enroll -u https://jewelrymakeradmin:jewelrymakeradminpw@localhost:11054 --caname ca-jewelrymaker -M "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/users/Admin@jewelrymaker.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/jewelrymaker/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/msp/config.yaml" "${PWD}/organizations/peerOrganizations/jewelrymaker.example.com/users/Admin@jewelrymaker.example.com/msp/config.yaml"
}

function createOrderer() {
  infoln "Enrolling the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml"

  # Since the CA serves as both the organization CA and TLS CA, copy the org's root cert that was generated by CA startup into the org level ca and tlsca directories

  # Copy orderer org's CA cert to orderer org's /msp/tlscacerts directory (for use in the channel MSP definition)
  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts"
  cp "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  # Copy orderer org's CA cert to orderer org's /tlsca directory (for use by clients)
  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/tlsca"
  cp "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem" "${PWD}/organizations/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem"

  infoln "Registering orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml"

  infoln "Generating the orderer-tls certificates, use --csr.hosts to specify Subject Alternative Names"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls" --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  # Copy the tls CA cert, server cert, server keystore to well known file names in the orderer's tls directory that are referenced by orderer startup config
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key"

  # Copy orderer org's CA cert to orderer's /msp/tlscacerts directory (for use in the orderer MSP definition)
  mkdir -p "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts"
  cp "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/"* "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

  infoln "Generating the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp" --tls.certfiles "${PWD}/organizations/fabric-ca/ordererOrg/ca-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml" "${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml"
}
