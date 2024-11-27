(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-37aeff16"],{1514:function(e,s,t){},"41fc":function(e,s,t){"use strict";t("1514")},"7c91":function(e,s,t){},"941e":function(e,s,t){"use strict";t("7c91")},"9ed6":function(e,s,t){"use strict";t.r(s);var o=function(){var e=this,s=e.$createElement,t=e._self._c||s;return t("div",{staticClass:"login-container"},[t("el-form",{ref:"loginForm",staticClass:"login-form",attrs:{model:e.loginForm,rules:e.loginRules,"auto-complete":"on","label-position":"left"}},[t("div",{staticClass:"title-container"},[t("h3",{staticClass:"title"},[e._v("基于区块链的农产品溯源系统")])]),t("div",{directives:[{name:"show",rawName:"v-show",value:e.isLoginPage,expression:"isLoginPage"}]},[t("el-form-item",{attrs:{prop:"username"}},[t("span",{staticClass:"svg-container"},[t("svg-icon",{attrs:{"icon-class":"user"}})],1),t("el-input",{ref:"username",attrs:{placeholder:"请输入账号",name:"username",type:"text",tabindex:"1","auto-complete":"on"},model:{value:e.loginForm.username,callback:function(s){e.$set(e.loginForm,"username",s)},expression:"loginForm.username"}})],1),t("el-form-item",{attrs:{prop:"password"}},[t("span",{staticClass:"svg-container"},[t("svg-icon",{attrs:{"icon-class":"password"}})],1),t("el-input",{key:e.passwordType,ref:"password",attrs:{type:e.passwordType,placeholder:"请输入密码",name:"password",tabindex:"2","auto-complete":"on"},nativeOn:{keyup:function(s){return!s.type.indexOf("key")&&e._k(s.keyCode,"enter",13,s.key,"Enter")?null:e.handleLogin(s)}},model:{value:e.loginForm.password,callback:function(s){e.$set(e.loginForm,"password",s)},expression:"loginForm.password"}}),t("span",{staticClass:"show-pwd",on:{click:e.showPwd}},[t("svg-icon",{attrs:{"icon-class":"password"===e.passwordType?"eye":"eye-open"}})],1)],1),t("el-button",{staticStyle:{width:"20%","margin-bottom":"30px"},attrs:{loading:e.loading,type:"info"},on:{click:e.handleRegister}},[e._v("注册")]),t("el-button",{staticStyle:{width:"30%","margin-bottom":"30px",float:"right"},attrs:{loading:e.loading,type:"primary"},nativeOn:{click:function(s){return s.preventDefault(),e.handleLogin(s)}}},[e._v("登录")])],1),t("div",{directives:[{name:"show",rawName:"v-show",value:!e.isLoginPage,expression:"!isLoginPage"}]},[t("el-form-item",{attrs:{prop:"username"}},[t("span",{staticClass:"svg-container"},[t("svg-icon",{attrs:{"icon-class":"user"}})],1),t("el-input",{attrs:{placeholder:"请输入账号",name:"username",type:"text","auto-complete":"on"},model:{value:e.registerForm.username,callback:function(s){e.$set(e.registerForm,"username",s)},expression:"registerForm.username"}})],1),t("el-form-item",{attrs:{prop:"password"}},[t("span",{staticClass:"svg-container"},[t("svg-icon",{attrs:{"icon-class":"password"}})],1),t("el-input",{key:e.passwordType,ref:"password",staticStyle:{color:"white !important"},attrs:{type:e.passwordType,placeholder:"请输入密码",name:"password","auto-complete":"on"},model:{value:e.registerForm.password,callback:function(s){e.$set(e.registerForm,"password",s)},expression:"registerForm.password"}}),t("span",{staticClass:"show-pwd",on:{click:e.showPwd}},[t("svg-icon",{attrs:{"icon-class":"password"===e.passwordType?"eye":"eye-open"}})],1)],1),t("el-form-item",{attrs:{prop:"password2"}},[t("span",{staticClass:"svg-container"},[t("svg-icon",{attrs:{"icon-class":"password"}})],1),t("el-input",{attrs:{placeholder:"请再次输入密码",name:"password","auto-complete":"on",type:e.passwordType},model:{value:e.registerForm.password2,callback:function(s){e.$set(e.registerForm,"password2",s)},expression:"registerForm.password2"}}),t("span",{staticClass:"show-pwd",on:{click:e.showPwd}},[t("svg-icon",{attrs:{"icon-class":"password"===e.passwordType?"eye":"eye-open"}})],1)],1),t("el-form-item",{staticStyle:{width:"200px"}},[t("el-select",{attrs:{placeholder:"请选择角色"},model:{value:e.registerForm.userType,callback:function(s){e.$set(e.registerForm,"userType",s)},expression:"registerForm.userType"}},e._l(e.options,(function(e){return t("el-option",{key:e.value,attrs:{label:e.label,value:e.value}})})),1)],1),t("el-button",{staticStyle:{width:"20%","margin-bottom":"30px"},attrs:{loading:e.loading,type:"info"},on:{click:e.handleRegister}},[e._v("返回")]),t("el-button",{staticStyle:{width:"30%","margin-bottom":"30px",float:"right"},attrs:{loading:e.loading,type:"primary"},nativeOn:{click:function(s){return s.preventDefault(),e.submitRegister(s)}}},[e._v("提交注册")])],1)])],1)},r=[],a={name:"Login",data:function(){return{loginForm:{username:"",password:""},loginRules:{username:[{required:!0}],password:[{required:!0}]},loading:!1,passwordType:"password",redirect:void 0,isLoginPage:!0,registerForm:{username:"",password:"",password2:"",userType:""},options:[{value:"种植户",label:"种植户"},{value:"工厂",label:"工厂"},{value:"运输司机",label:"运输司机"},{value:"商店",label:"商店"},{value:"消费者",label:"消费者"}]}},watch:{$route:{handler:function(e){this.redirect=e.query&&e.query.redirect},immediate:!0}},methods:{showPwd:function(){var e=this;"password"===this.passwordType?this.passwordType="":this.passwordType="password",this.$nextTick((function(){e.$refs.password.focus()}))},handleLogin:function(){var e=this;this.loading=!0,this.$store.dispatch("user/login",this.loginForm).then((function(){e.$router.push({path:e.redirect||"/"}),e.loading=!1})).catch((function(){e.loading=!1}))},handleRegister:function(){this.isLoginPage=!this.isLoginPage},submitRegister:function(){var e=this;if(this.registerForm.password===this.registerForm.password2){var s=this.$loading({lock:!0,text:"注册中...",spinner:"el-icon-loading",background:"rgba(0, 0, 0, 0.7)"});this.$store.dispatch("user/register",this.registerForm).then((function(t){e.$router.push({path:e.redirect||"/"}),e.loading=!1,e.$message({message:"注册成功，链上交易ID："+t.txid,type:"success"}),s.close(),e.handleRegister()})).catch((function(){s.close()}))}else this.$message.error("两次密码不一致")}}},i=a,n=(t("941e"),t("41fc"),t("2877")),l=Object(n["a"])(i,o,r,!1,null,"4049baf1",null);s["default"]=l.exports}}]);