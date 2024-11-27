<template>
  <div class="trace-container">
    <el-input v-model="input" placeholder="Enter traceability code" style="width: 300px;margin-right: 15px;" />
    <el-button type="primary" plain @click="FruitInfo"> Query </el-button>
    <el-button type="success" plain @click="AllFruitInfo"> Get all produce information </el-button>
    <el-table :data="tracedata" style="width: 100%">
      <el-table-column type="expand">
        <template slot-scope="props">
          <el-form label-position="left" inline class="demo-table-expand">
            <div><span class="trace-text" style="color: #67C23A;">Info of diamond</span></div>
            <el-form-item label="diamondName:">
              <span>{{ props.row.farmer_input.fa_fruitName }}</span>
            </el-form-item>
            <el-form-item label="miner:">
              <span>{{ props.row.farmer_input.fa_origin }}</span>
            </el-form-item>
            <el-form-item label="miningLocation:">
              <span>{{ props.row.farmer_input.fa_plantTime }}</span>
            </el-form-item>
            <el-form-item label="miningTime:">
              <span>{{ props.row.farmer_input.fa_pickingTime }}</span>
            </el-form-item>
            <el-form-item label="companyName:">
              <span>{{ props.row.farmer_input.fa_farmerName }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX ID：">
              <span>{{ props.row.farmer_input.fa_txid }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX Date：">
              <span>{{ props.row.farmer_input.fa_timestamp }}</span>
            </el-form-item>
            <div><span class="trace-text" style="color: #409EFF;">Cutting company</span></div>
            <el-form-item label="diamondName:">
              <span>{{ props.row.factory_input.fac_productName }}</span>
            </el-form-item>
            <el-form-item label="cutTime:">
              <span>{{ props.row.factory_input.fac_productionbatch }}</span>
            </el-form-item>
            <el-form-item label="shape:">
              <span>{{ props.row.factory_input.fac_productionTime }}</span>
            </el-form-item>
            <el-form-item label="weight:">
              <span>{{ props.row.factory_input.fac_factoryName }}</span>
            </el-form-item>
            <el-form-item label="companyName:">
              <span>{{ props.row.factory_input.fac_contactNumber }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX ID:">
              <span>{{ props.row.factory_input.fac_txid }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX Date:">
              <span>{{ props.row.factory_input.fac_timestamp }}</span>
            </el-form-item>
            <div><span class="trace-text" style="color: #E6A23C;">Grading lab</span></div>
            <el-form-item label="diamondName:">
              <span>{{ props.row.driver_input.dr_name }}</span>
            </el-form-item>
            <el-form-item label="caratWeight:">
              <span>{{ props.row.driver_input.dr_age }}</span>
            </el-form-item>
            <el-form-item label="quality:">
              <span>{{ props.row.driver_input.dr_phone }}</span>
            </el-form-item>
            <el-form-item label="certificateNo:">
              <span>{{ props.row.driver_input.dr_carNumber }}</span>
            </el-form-item>
            <el-form-item label="gradingLabName:">
              <span>{{ props.row.driver_input.dr_transport }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX ID:">
              <span>{{ props.row.driver_input.dr_txid }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX Date:">
              <span>{{ props.row.driver_input.dr_timestamp }}</span>
            </el-form-item>
            <div><span class="trace-text" style="color: #909399;">Jewelry_maker</span></div>
            <el-form-item label="diamondName:">
              <span>{{ props.row.shop_input.sh_storeTime }}</span>
            </el-form-item>
            <el-form-item label="design:">
              <span>{{ props.row.shop_input.sh_sellTime }}</span>
            </el-form-item>
            <el-form-item label="manufactureDate:">
              <span>{{ props.row.shop_input.sh_shopName }}</span>
            </el-form-item>
            <el-form-item label="material:">
              <span>{{ props.row.shop_input.sh_shopAddress }}</span>
            </el-form-item>
            <el-form-item label="jewelerName:">
              <span>{{ props.row.shop_input.sh_shopPhone }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX ID:">
              <span>{{ props.row.shop_input.sh_txid }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX Date:">
              <span>{{ props.row.shop_input.sh_timestamp }}</span>
            </el-form-item>
          </el-form>
        </template>
      </el-table-column>
      <el-table-column label="Traceability code" prop="traceability_code" />
      <el-table-column label="Diamond name" prop="farmer_input.fa_fruitName" />
      <el-table-column label="Mining Time " prop="farmer_input.fa_pickingTime" />
    </el-table>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { getDiamondInfo, getDiamondList, getAllDiamondInfo, getDiamondHistory } from '@/api/trace'

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
    getDiamondList().then(res => {
      this.tracedata = JSON.parse(res.data)
    })
  },
  methods: {
    AllDiamondInfo() {
      getAllDiamondInfo().then(res => {
        this.tracedata = JSON.parse(res.data)
      })
    },
    DiamondHistory() {
      getDiamondHistory().then(res => {
        // console.log(res)
      })
    },
    DiamondInfo() {
      var formData = new FormData()
      formData.append('traceability_code', this.input)
      getDiamondInfo(formData).then(res => {
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
