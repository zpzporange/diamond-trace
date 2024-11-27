<template>
  <div class="login-container">
    <el-form ref="loginForm" :model="loginForm" :rules="loginRules" class="login-form" auto-complete="on" label-position="left">

      <div class="title-container">
        <h3 class="title">Jewelry Traceability System</h3>
      </div>
      <div v-show="isLoginPage">
        <el-form-item prop="username">
          <span class="svg-container">
            <svg-icon icon-class="user" />
          </span>
          <el-input
            ref="username"
            v-model="loginForm.username"
            placeholder="Please enter your account number"
            name="username"
            type="text"
            tabindex="1"
            auto-complete="on"
          />
        </el-form-item>

        <el-form-item prop="password">
          <span class="svg-container">
            <svg-icon icon-class="password" />
          </span>
          <el-input
            :key="passwordType"
            ref="password"
            v-model="loginForm.password"
            :type="passwordType"
            placeholder="Please enter your password"
            name="password"
            tabindex="2"
            auto-complete="on"
            @keyup.enter.native="handleLogin"
          />
          <span class="show-pwd" @click="showPwd">
            <svg-icon :icon-class="passwordType === 'password' ? 'eye' : 'eye-open'" />
          </span>
        </el-form-item>
        <el-button :loading="loading" type="info" style="width:20%;margin-bottom:30px;" @click="handleRegister">Register</el-button>
        <el-button :loading="loading" type="primary" style="width:30%;margin-bottom:30px; float: right" @click.native.prevent="handleLogin">Login</el-button>
      </div>
      <div v-show="!isLoginPage">
        <el-form-item prop="username">
          <span class="svg-container">
            <svg-icon icon-class="user" />
          </span>
          <el-input
            v-model="registerForm.username"
            placeholder="Please enter your account number"
            name="username"
            type="text"
            auto-complete="on"
          />
        </el-form-item>
        <el-form-item prop="password">
          <span class="svg-container">
            <svg-icon icon-class="password" />
          </span>
          <el-input
            :key="passwordType"
            ref="password"
            v-model="registerForm.password"
            :type="passwordType"
            placeholder="Please enter your password"
            name="password"
            auto-complete="on"
            style="color: white !important;"
          />
          <span class="show-pwd" @click="showPwd">
            <svg-icon :icon-class="passwordType === 'password' ? 'eye' : 'eye-open'" />
          </span>
        </el-form-item>
        <el-form-item prop="password2">
          <span class="svg-container">
            <svg-icon icon-class="password" />
          </span>
          <el-input
            v-model="registerForm.password2"
            placeholder="Please enter your password again"
            name="password"
            auto-complete="on"
            :type="passwordType"
          />
          <span class="show-pwd" @click="showPwd">
            <svg-icon :icon-class="passwordType === 'password' ? 'eye' : 'eye-open'" />
          </span>
        </el-form-item>
        <el-form-item style="width: 200px">
          <el-select v-model="registerForm.userType" placeholder="Character">
            <el-option
              v-for="item in options"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-button :loading="loading" type="info" style="width:20%;margin-bottom:30px;" @click="handleRegister">Back</el-button>
        <el-button :loading="loading" type="primary" style="width:30%;margin-bottom:30px; float: right" @click.native.prevent="submitRegister">Submit</el-button>
      </div>
      <!-- <div class="tips">
        <span style="margin-right:20px;">提示：可以放一些提示</span>
      </div> -->

    </el-form>
  </div>
</template>

<script>

export default {
  name: 'Login',
  data() {
    return {
      loginForm: {
        username: '',
        password: ''
      },
      loginRules: {
        username: [{ required: true }],
        password: [{ required: true }]
      },
      loading: false,
      passwordType: 'password',
      redirect: undefined,
      isLoginPage: true,
      registerForm: {
        username: '',
        password: '',
        password2: '',
        userType: ''
      },
      options: [{
        value: 'Mining company',//'种植户', 矿业公司
        label: 'Mining company'//'种植户'
      }, {
        value: 'Cutting company',//'工厂',  切割公司
        label: 'Cutting company'//'工厂'
      }, {
        value: 'Grading lab',//'运输司机',  分级实验室
        label: 'Grading lab'//'运输司机'
      }, {
        value: 'Jewelry maker',//'商店',  珠宝商
        label: 'Jewelry maker'//'商店'
      }, {
        value: 'Customer',//'消费者',
        label: 'Customer'//'消费者'
      }]
    }
  },
  watch: {
    $route: {
      handler: function(route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  methods: {
    showPwd() {
      if (this.passwordType === 'password') {
        this.passwordType = ''
      } else {
        this.passwordType = 'password'
      }
      this.$nextTick(() => {
        this.$refs.password.focus()
      })
    },
    handleLogin() {
      this.loading = true
      this.$store.dispatch('user/login', this.loginForm).then(() => {
        this.$router.push({ path: this.redirect || '/' })
        this.loading = false
      }).catch(() => {
        this.loading = false
      })
    },
    handleRegister() {
      // 切换登录注册
      this.isLoginPage = !this.isLoginPage
    },
    submitRegister() {
      if (this.registerForm.password !== this.registerForm.password2) {
        this.$message.error('Two passwords do not match')
        return
      }
      const loading = this.$loading({
        lock: true,
        text: 'Regitering...',
        spinner: 'el-icon-loading',
        background: 'rgba(0, 0, 0, 0.7)'
      })
      this.$store.dispatch('user/register', this.registerForm).then(response => {
        this.$router.push({ path: this.redirect || '/' })
        this.loading = false
        this.$message({
          message: 'Successful registration and on-chain transaction ID:' + response.txid,
          type: 'success'
        })
        loading.close()
        this.handleRegister()
      }).catch(() => {
        loading.close()
      })
    }
  }
}
</script>

<style lang="scss">
/* 修复input 背景不协调 和光标变色 */
/* Detail see https://github.com/PanJiaChen/vue-element-admin/pull/927 */

$bg:#283443;
$light_gray:#fff;
$cursor: #fff;

@supports (-webkit-mask: none) and (not (cater-color: $cursor)) {
  .login-container .el-input input {
    color: $cursor;
  }
}

/* reset element-ui css */
.login-container {
  // 添加背景图片
  background-image: url("../../assets/login_images/nature.jpg");
  background-size: cover;
  background-position: center;

  .el-input {
    display: inline-block;
    height: 47px;
    width: 85%;

    input {
      background: transparent;
      border: 0px;
      border-radius: 0px;
      padding: 12px 5px 12px 15px;
      color: $light_gray;
      height: 47px;
      caret-color: $cursor;
      // -webkit-appearance: none;
      &:-webkit-autofill {
        box-shadow: 0 0 0px 1000px $bg inset !important;
        -webkit-text-fill-color: $cursor !important;
      }
    }
  }

  .el-form-item {
    border: 1px solid rgba(255, 255, 255, 0.1);
    background: rgba(0, 0, 0, 0.1);
    border-radius: 5px;
    color: #454545;
  }
}
</style>

<style lang="scss" scoped>
$bg:#2d3a4b;
$dark_gray:#889aa4;
$light_gray:#eee;

.login-container {
  min-height: 100%;
  width: 100%;
  background-color: $bg;
  overflow: hidden;

  .login-form {
    position: relative;
    width: 520px;
    max-width: 100%;
    padding: 160px 35px 0;
    margin: 0 auto;
    overflow: hidden;
  }

  .tips {
    font-size: 14px;
    color: #fff;
    margin-bottom: 10px;

    span {
      &:first-of-type {
        margin-right: 16px;
      }
    }
  }

  .svg-container {
    padding: 6px 5px 6px 15px;
    color: $dark_gray;
    vertical-align: middle;
    width: 30px;
    display: inline-block;
  }

  .title-container {
    position: relative;

    .title {
      font-size: 26px;
      color: $light_gray;
      margin: 0px auto 40px auto;
      text-align: center;
      font-weight: bold;
    }
  }

  .show-pwd {
    position: absolute;
    right: 10px;
    top: 7px;
    font-size: 16px;
    color: $dark_gray;
    cursor: pointer;
    user-select: none;
  }
}
</style>
