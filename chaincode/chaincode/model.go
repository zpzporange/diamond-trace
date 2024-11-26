package chaincode

/*
User 结构体定义了用户信息
包含以下字段：
UserID: 用户唯一标识符
UserType: 用户类型（如采矿公司、切割公司、评级实验室、珠宝制造商等）
RealInfoHash: 用户真实信息的哈希值，用于隐私保护
DiamondList: 用户关联的钻石列表
*/
type User struct {
	UserID       string     `json:"userID"`
	UserType     string     `json:"userType"`
	RealInfoHash string     `json:"realInfoHash"`
	DiamondList  []*Diamond `json:"diamondList"`
}

/*
定义钻石结构体
溯源码
采矿公司输入
切割公司输入
打分公司输入
商店输入
*/
type Diamond struct {
	Traceability_code     string                `json:"traceability_code"`
	Mining_company_input  Mining_company_input  `json:"mining_company_input"`
	Cutting_company_input Cutting_company_input `json:"cutting_company_input"`
	Grading_lab_input     Grading_lab_input     `json:"grading_lab_input"`
	Jewelry_maker_input   Jewelry_maker_input   `json:"jewelry_maker_input"`
}

// HistoryQueryResult structure used for handling result of history query
type HistoryQueryResult struct {
	Record    *Diamond `json:"record"`
	TxId      string   `json:"txId"`
	Timestamp string   `json:"timestamp"`
	IsDelete  bool     `json:"isDelete"`
}

/*
Mining_company_input 结构体定义了采矿公司输入的信息
包含以下字段：
Mc_diamondName: 钻石名称
Mc_miner: 矿工名称
Mc_miningLocation: 开采地点
Mc_miningTime: 开采时间
Mc_companyName: 采矿公司名称
Mc_Txid: 交易ID
Mc_Timestamp: 时间戳
*/
type Mining_company_input struct {
	Mc_diamondName    string `json:"Mc_diamondName"`
	Mc_miner          string `json:"Mc_miner"`
	Mc_miningLocation string `json:"Mc_miningLocation"`
	Mc_miningTime     string `json:"Mc_miningTime"`
	Mc_companyName    string `json:"Mc_companyName"`
	Mc_Txid           string `json:"Mc_Txid"`
	Mc_Timestamp      string `json:"Mc_timestamp"`
}

/*
Cutting_company_input 结构体定义了切割公司输入的信息
包含以下字段：
Cc_diamondName: 钻石名称
Cc_cutTime: 切割时间
Cc_shape: 切割形状
Cc_weight: 切割后重量
Cc_companyName: 切割公司名称
Cc_Txid: 交易ID
Cc_Timestamp: 时间戳
*/
type Cutting_company_input struct {
	Cc_diamondName string `json:"Cc_diamondName"`
	Cc_cutTime     string `json:"Cc_cutTime"`
	Cc_shape       string `json:"Cc_shape"`
	Cc_weight      string `json:"Cc_weight"`
	Cc_companyName string `json:"Cc_companyName"`
	Cc_Txid        string `json:"Cc_Txid"`
	Cc_Timestamp   string `json:"Cc_timestamp"`
}

/*
Grading_lab_input 结构体定义了钻石评级实验室输入的信息
包含以下字段：
Gl_diamondName: 钻石名称
Gl_caratWeight: 克拉重量
Gl_quality: 钻石质量
Gl_certificateNo: 证书编号
Gl_gradingLabName: 评级实验室名称
Gl_Txid: 交易ID
Gl_timestamp: 时间戳
*/
type Grading_lab_input struct {
	Gl_diamondName    string `json:"Gl_diamondName"`
	Gl_caratWeight    string `json:"Gl_caratWeight"`
	Gl_quality        string `json:"Gl_quality"`
	Gl_certificateNo  string `json:"Gl_certificateNo"`
	Gl_gradingLabName string `json:"Gl_gradingLabName"`
	Gl_Txid           string `json:"Gl_Txid"`
	Gl_Timestamp      string `json:"Gl_Timestamp"`
}

/*
Jewelry_maker_input 结构体定义了珠宝制造商输入的信息
包含以下字段：
Jm_diamondName: 钻石名称
Jm_design: 珠宝设计
Jm_manufactureDate: 制造日期
Jm_material: 使用的材料
Jm_jewelerName: 珠宝制造商名称
Jm_Txid: 交易ID
Jm_timestamp: 时间戳
*/
type Jewelry_maker_input struct {
	Jm_diamondName     string `json:"Jm_diamondName"`
	Jm_design          string `json:"Jm_design"`
	Jm_manufactureDate string `json:"Jm_manufactureDate"`
	Jm_material        string `json:"Jm_material"`
	Jm_jewelerName     string `json:"Jm_jewelerName"`
	Jm_Txid            string `json:"Jm_Txid"`
	Jm_Timestamp       string `json:"Jm_Timestamp"`
}
