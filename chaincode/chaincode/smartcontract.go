package chaincode

import (
	"encoding/json"
	"fmt"
	"log"
	"time"

	"github.com/golang/protobuf/ptypes"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// 定义合约结构体
type SmartContract struct {
	contractapi.Contract
}

// 注册用户
func (s *SmartContract) RegisterUser(ctx contractapi.TransactionContextInterface, userID string, userType string, realInfoHash string) error {
	fmt.Println("Register")
	user := User{
		UserID:       userID,
		UserType:     userType,
		RealInfoHash: realInfoHash,
		DiamondList:  []*Diamond{},
	}
	userAsBytes, err := json.Marshal(user)
	if err != nil {
		return err
	}
	err = ctx.GetStub().PutState(userID, userAsBytes)
	if err != nil {
		return err
	}
	return nil
}

// 农产品上链，传入用户ID、农产品上链信息
func (s *SmartContract) Uplink(ctx contractapi.TransactionContextInterface, userID string, traceability_code string, arg1 string, arg2 string, arg3 string, arg4 string, arg5 string) (string, error) {
	fmt.Println("Uplink")
	// 获取用户类型
	userType, err := s.GetUserType(ctx, userID)
	fmt.Println(1)
	if err != nil {
		fmt.Println(11)
		return "", fmt.Errorf("failed to get user type: %v", err)
	}

	// 通过溯源码获取农产品的上链信息
	DiamondAsBytes, err := ctx.GetStub().GetState(traceability_code)
	fmt.Println(2)
	if err != nil {
		fmt.Println(22)
		return "", fmt.Errorf("failed to read from world state: %v", err)
	}
	// 将农产品的信息转换为Fruit结构体
	var diamond Diamond
	if DiamondAsBytes != nil {
		fmt.Println(222)
		err = json.Unmarshal(DiamondAsBytes, &diamond)
		if err != nil {
			fmt.Println(2222)
			return "", fmt.Errorf("failed to unmarshal diamond: %v", err)
		}
	}

	//获取时间戳,修正时区
	txtime, err := ctx.GetStub().GetTxTimestamp()
	fmt.Println(3)
	if err != nil {
		fmt.Println(33)
		return "", fmt.Errorf("failed to read TxTimestamp: %v", err)
	}
	timeLocation, _ := time.LoadLocation("Asia/Hongkong") // 选择你所在的时区
	time := time.Unix(txtime.Seconds, 0).In(timeLocation).Format("2006-01-02 15:04:05")

	// 获取交易ID
	txid := ctx.GetStub().GetTxID()
	// 给农产品信息中加上溯源码
	diamond.Traceability_code = traceability_code
	// 不同用户类型的上链的参数不一致
	switch userType {
	// 种植户
	case "Mining_company":
		// 将传入的农产品上链信息转换为Farmer_input结构体
		diamond.Mining_company_input.Mc_diamondName = arg1
		diamond.Mining_company_input.Mc_miner = arg2
		diamond.Mining_company_input.Mc_miningLocation = arg3
		diamond.Mining_company_input.Mc_miningTime = arg4
		diamond.Mining_company_input.Mc_companyName = arg5
		diamond.Mining_company_input.Mc_Txid = txid
		diamond.Mining_company_input.Mc_Timestamp = time
	// 工厂
	case "Cutting_company":
		// 将传入的农产品上链信息转换为Factory_input结构体
		diamond.Cutting_company_input.Cc_diamondName = arg1
		diamond.Cutting_company_input.Cc_cutTime = arg2
		diamond.Cutting_company_input.Cc_shape = arg3
		diamond.Cutting_company_input.Cc_weight = arg4
		diamond.Cutting_company_input.Cc_companyName = arg5
		diamond.Cutting_company_input.Cc_Txid = txid
		diamond.Cutting_company_input.Cc_Timestamp = time
	// 运输司机
	case "Grading_lab":
		// 将传入的农产品上链信息转换为Driver_input结构体
		diamond.Grading_lab_input.Gl_diamondName = arg1
		diamond.Grading_lab_input.Gl_caratWeight = arg2
		diamond.Grading_lab_input.Gl_quality = arg3
		diamond.Grading_lab_input.Gl_certificateNo = arg4
		diamond.Grading_lab_input.Gl_gradingLabName = arg5
		diamond.Grading_lab_input.Gl_Txid = txid
		diamond.Grading_lab_input.Gl_Timestamp = time
	// 商店
	case "Jewelry_maker":
		// 将传入的农产品上链信息转换为Shop_input结构体
		diamond.Jewelry_maker_input.Jm_diamondName = arg1
		diamond.Jewelry_maker_input.Jm_design = arg2
		diamond.Jewelry_maker_input.Jm_manufactureDate = arg3
		diamond.Jewelry_maker_input.Jm_material = arg4
		diamond.Jewelry_maker_input.Jm_jewelerName = arg5
		diamond.Jewelry_maker_input.Jm_Txid = txid
		diamond.Jewelry_maker_input.Jm_Timestamp = time

	}

	//将农产品的信息转换为json格式
	diamondAsBytes, err := json.Marshal(diamond)
	fmt.Println(diamondAsBytes)
	fmt.Println(4)
	if err != nil {
		fmt.Println(44)
		return "", fmt.Errorf("failed to marshal diamond: %v", err)
	}
	//将农产品的信息存入区块链
	err = ctx.GetStub().PutState(traceability_code, diamondAsBytes)
	fmt.Println(5)
	if err != nil {
		fmt.Println(55)
		return "", fmt.Errorf("failed to put diamond: %v", err)
	}
	//将农产品存入用户的农产品列表
	err = s.AddDiamond(ctx, userID, &diamond)
	fmt.Println(6)
	if err != nil {
		fmt.Println(66)
		return "", fmt.Errorf("failed to add diamond to user: %v", err)
	}

	return txid, nil
}

// 添加农产品到用户的农产品列表
func (s *SmartContract) AddDiamond(ctx contractapi.TransactionContextInterface, userID string, diamond *Diamond) error {
	fmt.Println("AddDiamond")
	userBytes, err := ctx.GetStub().GetState(userID)
	if err != nil {
		return fmt.Errorf("failed to read from world state: %v", err)
	}
	if userBytes == nil {
		return fmt.Errorf("the user %s does not exist", userID)
	}
	// 将返回的结果转换为User结构体
	var user User
	err = json.Unmarshal(userBytes, &user)
	if err != nil {
		return err
	}
	user.DiamondList = append(user.DiamondList, diamond)
	userAsBytes, err := json.Marshal(user)
	if err != nil {
		return err
	}
	err = ctx.GetStub().PutState(userID, userAsBytes)
	if err != nil {
		return err
	}
	return nil
}

// 获取用户类型
func (s *SmartContract) GetUserType(ctx contractapi.TransactionContextInterface, userID string) (string, error) {
	fmt.Println("GetUserType")
	userBytes, err := ctx.GetStub().GetState(userID)
	if err != nil {
		return "", fmt.Errorf("failed to read from world state: %v", err)
	}
	if userBytes == nil {
		return "", fmt.Errorf("the user %s does not exist", userID)
	}
	// 将返回的结果转换为User结构体
	var user User
	err = json.Unmarshal(userBytes, &user)
	if err != nil {
		return "", err
	}
	return user.UserType, nil
}

// 获取用户信息
func (s *SmartContract) GetUserInfo(ctx contractapi.TransactionContextInterface, userID string) (*User, error) {
	fmt.Println("GetUserInfo")
	userBytes, err := ctx.GetStub().GetState(userID)
	if err != nil {
		return &User{}, fmt.Errorf("failed to read from world state: %v", err)
	}
	if userBytes == nil {
		return &User{}, fmt.Errorf("the user %s does not exist", userID)
	}
	// 将返回的结果转换为User结构体
	var user User
	err = json.Unmarshal(userBytes, &user)
	if err != nil {
		return &User{}, err
	}
	return &user, nil
}

// 获取农产品的上链信息
func (s *SmartContract) GetDiamondInfo(ctx contractapi.TransactionContextInterface, traceability_code string) (*Diamond, error) {
	fmt.Println("GetDiamondInfo")
	DiamondAsBytes, err := ctx.GetStub().GetState(traceability_code)
	if err != nil {
		return &Diamond{}, fmt.Errorf("failed to read from world state: %v", err)
	}

	// 将返回的结果转换为Fruit结构体
	var diamond Diamond
	if DiamondAsBytes != nil {
		err = json.Unmarshal(DiamondAsBytes, &diamond)
		if err != nil {
			return &Diamond{}, fmt.Errorf("failed to unmarshal diamond: %v", err)
		}
		if diamond.Traceability_code != "" {
			return &diamond, nil
		}
	}
	return &Diamond{}, fmt.Errorf("the diamond %s does not exist", traceability_code)
}

// 获取用户的农产品ID列表
func (s *SmartContract) GetDiamondList(ctx contractapi.TransactionContextInterface, userID string) ([]*Diamond, error) {
	fmt.Println("GetDiamondList")
	userBytes, err := ctx.GetStub().GetState(userID)
	if err != nil {
		return nil, fmt.Errorf("failed to read from world state: %v", err)
	}
	if userBytes == nil {
		return nil, fmt.Errorf("the user %s does not exist", userID)
	}
	// 将返回的结果转换为User结构体
	var user User
	err = json.Unmarshal(userBytes, &user)
	if err != nil {
		return nil, err
	}
	return user.DiamondList, nil
}

// 获取所有的农产品信息
func (s *SmartContract) GetAllDiamondInfo(ctx contractapi.TransactionContextInterface) ([]Diamond, error) {
	fmt.Println("GetAllDiamondInfo")
	diamondListAsBytes, err := ctx.GetStub().GetStateByRange("", "")
	if err != nil {
		return nil, fmt.Errorf("failed to read from world state: %v", err)
	}
	defer diamondListAsBytes.Close()
	var diamonds []Diamond
	for diamondListAsBytes.HasNext() {
		queryResponse, err := diamondListAsBytes.Next()
		if err != nil {
			return nil, err
		}
		var diamond Diamond
		err = json.Unmarshal(queryResponse.Value, &diamond)
		if err != nil {
			return nil, err
		}
		// 过滤非农产品的信息
		if diamond.Traceability_code != "" {
			diamonds = append(diamonds, diamond)
		}
	}
	return diamonds, nil
}

// 获取农产品上链历史
func (s *SmartContract) GetDiamondHistory(ctx contractapi.TransactionContextInterface, traceability_code string) ([]HistoryQueryResult, error) {
	fmt.Println("GetDiamondHistory")
	log.Printf("GetAssetHistory: ID %v", traceability_code)

	resultsIterator, err := ctx.GetStub().GetHistoryForKey(traceability_code)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	var records []HistoryQueryResult
	for resultsIterator.HasNext() {
		response, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		var diamond Diamond
		if len(response.Value) > 0 {
			err = json.Unmarshal(response.Value, &diamond)
			if err != nil {
				return nil, err
			}
		} else {
			diamond = Diamond{
				Traceability_code: traceability_code,
			}
		}

		timestamp, err := ptypes.Timestamp(response.Timestamp)
		if err != nil {
			return nil, err
		}
		// 指定目标时区
		targetLocation, err := time.LoadLocation("Asia/Hongkong")
		if err != nil {
			return nil, err
		}

		// 将时间戳转换到目标时区
		timestamp = timestamp.In(targetLocation)
		// 格式化时间戳为指定格式的字符串
		formattedTime := timestamp.Format("2006-01-02 15:04:05")

		record := HistoryQueryResult{
			TxId:      response.TxId,
			Timestamp: formattedTime,
			Record:    &diamond,
			IsDelete:  response.IsDelete,
		}
		records = append(records, record)
	}

	return records, nil
}
