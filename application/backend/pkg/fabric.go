package pkg

// 本文件用于处理链码请求
import (
	"crypto/x509"
	"fmt"
	"os"
	"path/filepath"
	"time"

	"github.com/hyperledger/fabric-gateway/pkg/client"
	"github.com/hyperledger/fabric-gateway/pkg/identity"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
)

// MiningCompanyMSP constants
const (
	MiningCompanyMSPID        = "MiningCompanyMSP"
	MiningCompanyCryptoPath   = "../../network/organizations/peerOrganizations/miningcompany.example.com"
	MiningCompanyCertPath     = MiningCompanyCryptoPath + "/users/User1@miningcompany.example.com/msp/signcerts/User1@miningcompany.example.com-cert.pem"
	MiningCompanyKeyPath      = MiningCompanyCryptoPath + "/users/User1@miningcompany.example.com/msp/keystore/"
	MiningCompanyTLSCertPath  = MiningCompanyCryptoPath + "/tlsca/tlsca.miningcompany.example.com-cert.pem"
	MiningCompanyPeerEndpoint = "localhost:8051"
	MiningCompanyGatewayPeer  = "peer0.miningcompany.example.com"
)

// CuttingCompanyMSP constants
const (
	CuttingCompanyMSPID        = "CuttingCompanyMSP"
	CuttingCompanyCryptoPath   = "../../network/organizations/peerOrganizations/cuttingcompany.example.com"
	CuttingCompanyCertPath     = CuttingCompanyCryptoPath + "/users/User1@cuttingcompany.example.com/msp/signcerts/User1@cuttingcompany.example.com-cert.pem"
	CuttingCompanyKeyPath      = CuttingCompanyCryptoPath + "/users/User1@cuttingcompany.example.com/msp/keystore/"
	CuttingCompanyTLSCertPath  = CuttingCompanyCryptoPath + "/tlsca/tlsca.cuttingcompany.example.com-cert.pem"
	CuttingCompanyPeerEndpoint = "localhost:9051"
	CuttingCompanyGatewayPeer  = "peer0.cuttingcompany.example.com"
)

// GradingLabMSP constants
const (
	GradingLabMSPID        = "GradingLabMSP"
	GradingLabCryptoPath   = "../../network/organizations/peerOrganizations/gradinglab.example.com"
	GradingLabCertPath     = GradingLabCryptoPath + "/users/User1@gradinglab.example.com/msp/signcerts/User1@gradinglab.example.com-cert.pem"
	GradingLabKeyPath      = GradingLabCryptoPath + "/users/User1@gradinglab.example.com/msp/keystore/"
	GradingLabTLSCertPath  = GradingLabCryptoPath + "/tlsca/tlsca.gradinglab.example.com-cert.pem"
	GradingLabPeerEndpoint = "localhost:10051"
	GradingLabGatewayPeer  = "peer0.gradinglab.example.com"
)

// JewelryMakerMSP constants
const (
	JewelryMakerMSPID        = "JewelryMakerMSP"
	JewelryMakerCryptoPath   = "../../network/organizations/peerOrganizations/jewelrymaker.example.com"
	JewelryMakerCertPath     = JewelryMakerCryptoPath + "/users/User1@jewelrymaker.example.com/msp/signcerts/User1@jewelrymaker.example.com-cert.pem"
	JewelryMakerKeyPath      = JewelryMakerCryptoPath + "/users/User1@jewelrymaker.example.com/msp/keystore/"
	JewelryMakerTLSCertPath  = JewelryMakerCryptoPath + "/tlsca/tlsca.jewelrymaker.example.com-cert.pem"
	JewelryMakerPeerEndpoint = "localhost:11051"
	JewelryMakerGatewayPeer  = "peer0.jewelrymaker.example.com"
)

// 链码查询
func ChaincodeQuery(org string, fcn string, arg string) (string, error) {
	contract, conn, gw := GetContract(org)
	defer conn.Close()
	defer gw.Close()
	evaluateResult, err := contract.EvaluateTransaction(fcn, arg)
	if err != nil {
		return "", fmt.Errorf("failed to evaluate transaction: %w", err)
	}
	fmt.Printf("*** evaluateResult:%s\n", evaluateResult)
	return string(evaluateResult), nil
}

// 链码调用，返回交易ID
func ChaincodeInvoke(org string, fcn string, args []string) (string, error) {
	contract, conn, gw := GetContract(org)
	defer conn.Close()
	defer gw.Close()
	submitResult, commit, err := contract.SubmitAsync(fcn, client.WithArguments(args...))
	if err != nil {
		return "", fmt.Errorf("failed to submit transaction asynchronously: %w", err)
	}
	fmt.Printf("*** Successfully submitted transaction :%v", string(submitResult))
	fmt.Println("*** Waiting for transaction commit.")

	if commitStatus, err := commit.Status(); err != nil {
		return "", fmt.Errorf("failed to get commit status: %w", err)
	} else if !commitStatus.Successful {
		return "", fmt.Errorf("transaction %s failed to commit with status: %d", commitStatus.TransactionID, int32(commitStatus.Code))
	}

	fmt.Printf("*** Transaction committed successfully\n")
	return commit.TransactionID(), nil
}

func GetContract(org string) (*client.Contract, *grpc.ClientConn, *client.Gateway) {
	var mspID, certPath, keyPath, tlsCertPath, peerEndpoint, gatewayPeer string

	switch org {
	case "MiningCompany":
		mspID = MiningCompanyMSPID
		certPath = MiningCompanyCertPath
		keyPath = MiningCompanyKeyPath
		tlsCertPath = MiningCompanyTLSCertPath
		peerEndpoint = MiningCompanyPeerEndpoint
		gatewayPeer = MiningCompanyGatewayPeer
	case "CuttingCompany":
		mspID = CuttingCompanyMSPID
		certPath = CuttingCompanyCertPath
		keyPath = CuttingCompanyKeyPath
		tlsCertPath = CuttingCompanyTLSCertPath
		peerEndpoint = CuttingCompanyPeerEndpoint
		gatewayPeer = CuttingCompanyGatewayPeer
	case "GradingLab":
		mspID = GradingLabMSPID
		certPath = GradingLabCertPath
		keyPath = GradingLabKeyPath
		tlsCertPath = GradingLabTLSCertPath
		peerEndpoint = GradingLabPeerEndpoint
		gatewayPeer = GradingLabGatewayPeer
	case "JewelryMaker":
		mspID = JewelryMakerMSPID
		certPath = JewelryMakerCertPath
		keyPath = JewelryMakerKeyPath
		tlsCertPath = JewelryMakerTLSCertPath
		peerEndpoint = JewelryMakerPeerEndpoint
		gatewayPeer = JewelryMakerGatewayPeer
	default:
		panic(fmt.Sprintf("Unknown organization: %s", org))
	}

	// The gRPC client connection should be shared by all Gateway connections to this endpoint
	clientConnection := newGrpcConnection(tlsCertPath, peerEndpoint, gatewayPeer)
	// defer clientConnection.Close()

	id := newIdentity(mspID, certPath)
	sign := newSign(keyPath)

	// Create a Gateway connection for a specific client identity
	gw, err := client.Connect(
		id,
		client.WithSign(sign),
		client.WithClientConnection(clientConnection),
		// Default timeouts for different gRPC calls
		client.WithEvaluateTimeout(5*time.Second),
		client.WithEndorseTimeout(15*time.Second),
		client.WithSubmitTimeout(5*time.Second),
		client.WithCommitStatusTimeout(1*time.Minute),
	)
	if err != nil {
		panic(err)
	}
	// defer gw.Close()

	// Override default values for chaincode and channel name as they may differ in testing contexts.
	chaincodeName := "trace"
	if ccname := os.Getenv("CHAINCODE_NAME"); ccname != "" {
		chaincodeName = ccname
	}

	channelName := "mychannel"
	if cname := os.Getenv("CHANNEL_NAME"); cname != "" {
		channelName = cname
	}
	network := gw.GetNetwork(channelName)
	contract := network.GetContract(chaincodeName)

	return contract, clientConnection, gw
}

// newIdentity creates a client identity for this Gateway connection using an X.509 certificate.
func newIdentity(mspID string, certPath string) *identity.X509Identity {
	certificate, err := loadCertificate(certPath)
	if err != nil {
		panic(err)
	}

	id, err := identity.NewX509Identity(mspID, certificate)
	if err != nil {
		panic(err)
	}

	return id
}

// newSign creates a function that generates a digital signature from a message digest using a private key.
func newSign(keyPath string) identity.Sign {
	files, err := os.ReadDir(keyPath)
	if err != nil {
		panic(fmt.Errorf("failed to read private key directory: %w", err))
	}
	privateKeyPEM, err := os.ReadFile(filepath.Join(keyPath, files[0].Name()))

	if err != nil {
		panic(fmt.Errorf("failed to read private key file: %w", err))
	}

	privateKey, err := identity.PrivateKeyFromPEM(privateKeyPEM)
	if err != nil {
		panic(err)
	}

	sign, err := identity.NewPrivateKeySign(privateKey)
	if err != nil {
		panic(err)
	}

	return sign
}

// newGrpcConnection creates a gRPC connection to the Gateway server.
func newGrpcConnection(tlsCertPath string, peerEndpoint string, gatewayPeer string) *grpc.ClientConn {
	certificate, err := loadCertificate(tlsCertPath)
	if err != nil {
		panic(err)
	}

	certPool := x509.NewCertPool()
	certPool.AddCert(certificate)
	transportCredentials := credentials.NewClientTLSFromCert(certPool, gatewayPeer)

	connection, err := grpc.Dial(peerEndpoint, grpc.WithTransportCredentials(transportCredentials))
	if err != nil {
		panic(fmt.Errorf("failed to create gRPC connection: %w", err))
	}

	return connection
}

func loadCertificate(filename string) (*x509.Certificate, error) {
	certificatePEM, err := os.ReadFile(filename)
	if err != nil {
		return nil, fmt.Errorf("failed to read certificate file: %w", err)
	}
	return identity.CertificateFromPEM(certificatePEM)
}
