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
              <span>{{ props.row.Mining_company_input.Mc_diamondName }}</span>
            </el-form-item>
            <el-form-item label="miner:">
              <span>{{ props.row.Mining_company_input.Mc_miner }}</span>
            </el-form-item>
            <el-form-item label="miningLocation:">
              <span>{{ props.row.Mining_company_input.Mc_miningLocation }}</span>
            </el-form-item>
            <el-form-item label="miningTime:">
              <span>{{ props.row.Mining_company_input.Mc_miningTime }}</span>
            </el-form-item>
            <el-form-item label="companyName:">
              <span>{{ props.row.Mining_company_input.Mc_companyName }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX ID:">
              <span>{{ props.row.Mining_company_input.Mc_Txid }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX Date:">
              <span>{{ props.row.Mining_company_input.Mc_Timestamp }}</span>
            </el-form-item>

            <div><span class="trace-text" style="color: #409EFF;">Cutting company</span></div>
            <el-form-item label="diamondName:">
              <span>{{ props.row.Cutting_company_input.Cc_diamondName }}</span>
            </el-form-item>
            <el-form-item label="cutTime:">
              <span>{{ props.row.Cutting_company_input.Cc_cutTime }}</span>
            </el-form-item>
            <el-form-item label="shape:">
              <span>{{ props.row.Cutting_company_input.Cc_shape }}</span>
            </el-form-item>
            <el-form-item label="weight:">
              <span>{{ props.row.Cutting_company_input.Cc_weight }}</span>
            </el-form-item>
            <el-form-item label="companyName:">
              <span>{{ props.row.Cutting_company_input.Cc_companyName }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX ID:">
              <span>{{ props.row.Cutting_company_input.Cc_Txid }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX Date:">
              <span>{{ props.row.Cutting_company_input.Cc_Timestamp }}</span>
            </el-form-item>

            <div><span class="trace-text" style="color: #E6A23C;">Grading lab</span></div>
            <el-form-item label="diamondName:">
              <span>{{ props.row.Grading_lab_input.Gl_diamondName }}</span>
            </el-form-item>
            <el-form-item label="caratWeight:">
              <span>{{ props.row.Grading_lab_input.Gl_caratWeight }}</span>
            </el-form-item>
            <el-form-item label="quality:">
              <span>{{ props.row.Grading_lab_input.Gl_quality }}</span>
            </el-form-item>
            <el-form-item label="certificateNo:">
              <span>{{ props.row.Grading_lab_input.Gl_certificateNo }}</span>
            </el-form-item>
            <el-form-item label="gradingLabName:">
              <span>{{ props.row.Grading_lab_input.Gl_gradingLabName }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX ID:">
              <span>{{ props.row.Grading_lab_input.Gl_Txid }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX Date:">
              <span>{{ props.row.Grading_lab_input.Gl_Timestamp }}</span>
            </el-form-item>

            <div><span class="trace-text" style="color: #909399;">Jewelry maker</span></div>
            <el-form-item label="diamondName:">
              <span>{{ props.row.Jewelry_maker_input.Jm_diamondName }}</span>
            </el-form-item>
            <el-form-item label="design:">
              <span>{{ props.row.Jewelry_maker_input.Jm_design }}</span>
            </el-form-item>
            <el-form-item label="manufactureDate:">
              <span>{{ props.row.Jewelry_maker_input.Jm_manufactureDate }}</span>
            </el-form-item>
            <el-form-item label="material:">
              <span>{{ props.row.Jewelry_maker_input.Jm_material }}</span>
            </el-form-item>
            <el-form-item label="jewelerName:">
              <span>{{ props.row.Jewelry_maker_input.Jm_jewelerName }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX ID:">
              <span>{{ props.row.Jewelry_maker_input.Jm_Txid }}</span>
            </el-form-item>
            <el-form-item label="Blockchain TX Date:">
              <span>{{ props.row.Jewelry_maker_input.Jm_Timestamp }}</span>
            </el-form-item>
          </el-form>
        </template>
      </el-table-column>
      <el-table-column label="Traceability code" prop="traceability_code" />
      <el-table-column label="Diamond name" prop="Mining_company_input.Mc_diamondName" />
      <el-table-column label="Mining Time " prop="Mining_company_input.Mc_miningTime" />
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
