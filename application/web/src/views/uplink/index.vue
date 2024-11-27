<template>
  <div class="uplink-container">
    <div style="color:#909399;margin-bottom: 30px">
      Active user：{{ name }};
      User type: {{ userType }}
    </div>
    <div>
      <el-form ref="form" :model="tracedata" label-width="80px" size="mini" style="">
        <el-form-item v-show="userType != 'Mining company' & userType != 'Customer'" label="Traceability code:"
          style="width: 300px" label-width="120px">
          <el-input v-model="tracedata.traceability_code" />
        </el-form-item>

        <div>
          <div v-show="userType == 'Mining company'">
            <el-form-item label="diamondName:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Mining_company_input.Mc_diamondName" />
            </el-form-item>
            <el-form-item label="miner:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Mining_company_input.Mc_miner" />
            </el-form-item>
            <el-form-item label="miningLocation:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Mining_company_input.Mc_miningLocation" />
            </el-form-item>
            <el-form-item label="miningTime:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Mining_company_input.Mc_miningTime" />
            </el-form-item>
            <el-form-item label="companyName:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Mining_company_input.Mc_companyName" />
            </el-form-item>
          </div>
          <div v-show="userType == 'Cutting company'">
            <el-form-item label="diamondName:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Cutting_company_input.Cc_diamondName" />
            </el-form-item>
            <el-form-item label="cutTime:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Cutting_company_input.Cc_cutTime" />
            </el-form-item>
            <el-form-item label="shape:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Cutting_company_input.Cc_shape" />
            </el-form-item>
            <el-form-item label="weight:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Cutting_company_input.Cc_weight" />
            </el-form-item>
            <el-form-item label="companyName:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Cutting_company_input.Cc_companyName" />
            </el-form-item>
          </div>
          <div v-show="userType == 'Grading lab'">
            <el-form-item label="diamondName:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Grading_lab_input.Gl_diamondName" />
            </el-form-item>
            <el-form-item label="caratWeight:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Grading_lab_input.Gl_caratWeight" />
            </el-form-item>
            <el-form-item label="quality:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Grading_lab_input.Gl_quality" />
            </el-form-item>
            <el-form-item label="certificateNo:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Grading_lab_input.Gl_certificateNo" />
            </el-form-item>
            <el-form-item label="gradingLabName:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Grading_lab_input.Gl_gradingLabName" />
            </el-form-item>
          </div>
          <div v-show="userType == 'Jewelry maker'">
            <el-form-item label="diamondName:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Jewelry_maker_input.Jm_diamondName" />
            </el-form-item>
            <el-form-item label="design:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Jewelry_maker_input.Jm_design" />
            </el-form-item>
            <el-form-item label="manufactureDate:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Jewelry_maker_input.Jm_manufactureDate" />
            </el-form-item>
            <el-form-item label="material:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Jewelry_maker_input.Jm_material" />
            </el-form-item>
            <el-form-item label="jewelerName:" style="width: 300px" label-width="120px">
              <el-input v-model="tracedata.Jewelry_maker_input.Jm_jewelerName" />
            </el-form-item>
          </div>
        </div>
      </el-form>
      <span slot="footer" style="color: gray;" class="dialog-footer">
        <el-button v-show="userType != 'Customer'" type="primary" plain style="margin-left: 220px;"
          @click="submittracedata()">Submit</el-button>
      </span>
      <span v-show="userType == 'Customer'" slot="footer" style="color: gray;" class="dialog-footer">
        Consumers do not have permission to enter! Please use the traceability function!
      </span>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { uplink } from '@/api/trace'

export default {
  name: 'Uplink',
  data() {
    return {
      tracedata: {
        traceability_code: '',
        Mining_company_input: {
          Mc_diamondName: '',
          Mc_miner: '',
          Mc_miningLocation: '',
          Mc_miningTime: '',
          Mc_companyName: '',
          Mc_Txid: '',
          Mc_Timestamp: ''
        },
        Cutting_company_input: {
          Cc_diamondName: '',
          Cc_cutTime: '',
          Cc_shape: '',
          Cc_weight: '',
          Cc_companyName: '',
          Cc_Txid: '',
          Cc_Timestamp: ''
        },
        Grading_lab_input: {
          Gl_diamondName: '',
          Gl_caratWeight: '',
          Gl_quality: '',
          Gl_certificateNo: '',
          Gl_gradingLabName: '',
          Gl_Txid: '',
          Gl_Timestamp: ''
        },
        Jewelry_maker_input: {
          Jm_diamondName: '',
          Jm_design: '',
          Jm_manufactureDate: '',
          Jm_material: '',
          Jm_jewelerName: '',
          Jm_Txid: '',
          Jm_Timestamp: ''
        }
      },
      loading: false
    }
  },
  computed: {
    ...mapGetters([
      'name',
      'userType'
    ])
  },
  methods: {
    submittracedata() {
      console.log(this.tracedata)
      const loading = this.$loading({
        lock: true,
        text: '数据上链中...',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)'
      })
      var formData = new FormData()
      formData.append('traceability_code', this.tracedata.traceability_code)
      // 根据不同的用户给arg1、arg2、arg3..赋值,
      switch (this.userType) {
        case 'Mining company':
          formData.append('arg1', this.tracedata.Mining_company_input.Mc_diamondName);
          formData.append('arg2', this.tracedata.Mining_company_input.Mc_miner);
          formData.append('arg3', this.tracedata.Mining_company_input.Mc_miningLocation);
          formData.append('arg4', this.tracedata.Mining_company_input.Mc_miningTime);
          formData.append('arg5', this.tracedata.Mining_company_input.Mc_companyName);
          break;
        case 'Cutting company':
          formData.append('arg1', this.tracedata.Cutting_company_input.Cc_diamondName);
          formData.append('arg2', this.tracedata.Cutting_company_input.Cc_cutTime);
          formData.append('arg3', this.tracedata.Cutting_company_input.Cc_shape);
          formData.append('arg4', this.tracedata.Cutting_company_input.Cc_weight);
          formData.append('arg5', this.tracedata.Cutting_company_input.Cc_companyName);
          break;
        case 'Grading lab':
          formData.append('arg1', this.tracedata.Grading_lab_input.Gl_diamondName);
          formData.append('arg2', this.tracedata.Grading_lab_input.Gl_caratWeight);
          formData.append('arg3', this.tracedata.Grading_lab_input.Gl_quality);
          formData.append('arg4', this.tracedata.Grading_lab_input.Gl_certificateNo);
          formData.append('arg5', this.tracedata.Grading_lab_input.Gl_gradingLabName);
          break;
        case 'Jewelry maker':
          formData.append('arg1', this.tracedata.Jewelry_maker_input.Jm_diamondName);
          formData.append('arg2', this.tracedata.Jewelry_maker_input.Jm_design);
          formData.append('arg3', this.tracedata.Jewelry_maker_input.Jm_manufactureDate);
          formData.append('arg4', this.tracedata.Jewelry_maker_input.Jm_material);
          formData.append('arg5', this.tracedata.Jewelry_maker_input.Jm_jewelerName);
          break;
      }
      uplink(formData).then(res => {
        if (res.code === 200) {
          loading.close()
          this.$message({
            message: '上链成功，交易ID：' + res.txid + '\n溯源码：' + res.traceability_code,
            type: 'success'
          })
        } else {
          loading.close()
          this.$message({
            message: '上链失败',
            type: 'error'
          })
        }
      }).catch(err => {
        loading.close()
        console.log(err)
      })
    }
  }
}

</script>

<style lang="scss" scoped>
.uplink {
  &-container {
    margin: 30px;
  }

  &-text {
    font-size: 30px;
    line-height: 46px;
  }
}
</style>
