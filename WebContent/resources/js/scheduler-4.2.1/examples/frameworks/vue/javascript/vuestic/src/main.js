// polyfills are required for IE11 compatibility. If you don't use IE then delete them
import 'core-js-3/es'
import 'core-js-3/stage'
import 'whatwg-fetch'
import 'abortcontroller-polyfill'
// end of IE11 polyfills

// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import VeeValidate from 'vee-validate'
import App from './App.vue'
import store from './store'
import router from './router'
import VuesticPlugin from '@/vuestic-theme/vuestic-plugin'
import './i18n'
import YmapPlugin from 'vue-yandex-maps'

Vue.use(VuesticPlugin)
Vue.use(YmapPlugin)

// NOTE: workaround for VeeValidate + vuetable - 2
Vue.use(VeeValidate, { fieldsBagName: 'formFields' })

router.beforeEach((to, from, next) => {
  store.commit('setLoading', true)
  next()
})

router.afterEach((to, from) => {
  store.commit('setLoading', false)
})

/* eslint-disable no-new */

new Vue({
  el: '#app',
  router,
  store,
  render: h => h(App),
})
