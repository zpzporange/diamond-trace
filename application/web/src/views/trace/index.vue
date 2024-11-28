<template>
  <div class="trace-container">
    <el-input v-model="input" placeholder="请输入溯源码查询" style="width: 300px;margin-right: 15px;" />
    <el-button type="primary" plain @click="FruitInfo"> Query </el-button>
    <el-button type="success" plain @click="AllFruitInfo"> Get all info </el-button>
    <el-table
      :data="tracedata"
      style="width: 100%"
    >
      <el-table-column type="expand">
        <template slot-scope="props">
          <el-form label-position="left" inline class="demo-table-expand">
            <div><span class="trace-text" style="color: #67C23A;">Mining_Company_Info</span></div>
            <el-form-item label="DiamondName:">
              <span>{{ props.row.farmer_input.fa_fruitName }}</span>
            </el-form-item>
            <el-form-item label="Miner:">
              <span>{{ props.row.farmer_input.fa_origin }}</span>
            </el-form-item>
            <el-form-item label="MiningLocation:">
              <span>{{ props.row.farmer_input.fa_plantTime }}</span>
            </el-form-item>
            <el-form-item label="MiningTime:">
              <span>{{ props.row.farmer_input.fa_pickingTime }}</span>
            </el-form-item>
            <el-form-item label="CompanyName:">
              <span>{{ props.row.farmer_input.fa_farmerName }}</span>
            </el-form-item>
            <el-form-item label="BlockchainTxID:">
              <span>{{ props.row.farmer_input.fa_txid }}</span>
            </el-form-item>
            <el-form-item label="BlockchainTxTime:">
              <span>{{ props.row.farmer_input.fa_timestamp }}</span>
            </el-form-item>
            <div><span class="trace-text" style="color: #409EFF;">Cutting_Company_Info</span></div>
            <el-form-item label="DiamondName:">
              <span>{{ props.row.factory_input.fac_productName }}</span>
            </el-form-item>
            <el-form-item label="utTime:">
              <span>{{ props.row.factory_input.fac_productionbatch }}</span>
            </el-form-item>
            <el-form-item label="Shape:">
              <span>{{ props.row.factory_input.fac_productionTime }}</span>
            </el-form-item>
            <el-form-item label="Weight:">
              <span>{{ props.row.factory_input.fac_factoryName }}</span>
            </el-form-item>
            <el-form-item label="CompanyName:">
              <span>{{ props.row.factory_input.fac_contactNumber }}</span>
            </el-form-item>
            <el-form-item label="BlockchainTxID:">
              <span>{{ props.row.factory_input.fac_txid }}</span>
            </el-form-item>
            <el-form-item label="BlockchainTxTime:">
              <span>{{ props.row.factory_input.fac_timestamp }}</span>
            </el-form-item>
            <div><span class="trace-text" style="color: #E6A23C;">Grading_Lab_Info</span></div>
            <el-form-item label="DiamondName:">
              <span>{{ props.row.driver_input.dr_name }}</span>
            </el-form-item>
            <el-form-item label="CaratWeight:">
              <span>{{ props.row.driver_input.dr_age }}</span>
            </el-form-item>
            <el-form-item label="Quality:">
              <span>{{ props.row.driver_input.dr_phone }}</span>
            </el-form-item>
            <el-form-item label="CertificateNo:">
              <span>{{ props.row.driver_input.dr_carNumber }}</span>
            </el-form-item>
            <el-form-item label="GradingLabName:">
              <span>{{ props.row.driver_input.dr_transport }}</span>
            </el-form-item>
            <el-form-item label="BlockchainTxID:">
              <span>{{ props.row.driver_input.dr_txid }}</span>
            </el-form-item>
            <el-form-item label="BlockchainTxTime:">
              <span>{{ props.row.driver_input.dr_timestamp }}</span>
            </el-form-item>
            <div><span class="trace-text" style="color: #909399;">Jewelry_Maker_Info</span></div>
            <el-form-item label="DiamondName">
              <span>{{ props.row.shop_input.sh_storeTime }}</span>
            </el-form-item>
            <el-form-item label="Design:">
              <span>{{ props.row.shop_input.sh_sellTime }}</span>
            </el-form-item>
            <el-form-item label="ManufactureDate:">
              <span>{{ props.row.shop_input.sh_shopName }}</span>
            </el-form-item>
            <el-form-item label="Material:">
              <span>{{ props.row.shop_input.sh_shopAddress }}</span>
            </el-form-item>
            <el-form-item label="JewelerName:">
              <span>{{ props.row.shop_input.sh_shopPhone }}</span>
            </el-form-item>
            <el-form-item label="BlockchainTxID:">
              <span>{{ props.row.shop_input.sh_txid }}</span>
            </el-form-item>
            <el-form-item label="BlockchainTxTime:">
              <span>{{ props.row.shop_input.sh_timestamp }}</span>
            </el-form-item>
          </el-form>
        </template>
      </el-table-column>
      <el-table-column
        label="traceability_code"
        prop="traceability_code"
      />
      <el-table-column
        label="DiamondName"
        prop="farmer_input.fa_fruitName"
      />
      <el-table-column
        label="MiningTime"
        prop="farmer_input.fa_pickingTime"
      />
    </el-table>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { getFruitInfo, getFruitList, getAllFruitInfo, getFruitHistory } from '@/api/trace'

export default {
  name: 'Trace',
  data() {
    return {
      tracedata: [],
      loading: false,
      input: ''
    }
  },
  computed: {
    ...mapGetters([
      'name',
      'userType'
    ])
  },
  created() {
    getFruitList().then(res => {
      this.tracedata = JSON.parse(res.data)
    })
  },
  methods: {
    AllFruitInfo() {
      getAllFruitInfo().then(res => {
        this.tracedata = JSON.parse(res.data)
      })
    },
    FruitHistory() {
      getFruitHistory().then(res => {
        // console.log(res)
      })
    },
    FruitInfo() {
      var formData = new FormData()
      formData.append('traceability_code', this.input)
      getFruitInfo(formData).then(res => {
        if (res.code === 200) {
          // console.log(res)
          this.tracedata = []
          this.tracedata[0] = JSON.parse(res.data)
          return
        } else {
          this.$message.error(res.message)
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>

.demo-table-expand {
    font-size: 0;
  }
  .demo-table-expand label {
    width: 90px;
    color: #99a9bf;
  }
  .demo-table-expand .el-form-item {
    margin-right: 0;
    margin-bottom: 0;
    width: 50%;
  }
.trace {
  &-container {
    margin: 30px;
  }
  &-text {
    font-size: 30px;
    line-height: 46px;
  }
}
</style>
