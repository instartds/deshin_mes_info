// polyfills are required for IE11 compatibility. If you don't use IE then delete them
import "core-js/es";
import "core-js/stage";
import 'whatwg-fetch';
import 'abortcontroller-polyfill';
// end of IE11 polyfills

import Vue from "vue";
import App from "./App.vue";

Vue.config.productionTip = false;

new Vue({
  render: h => h(App)
}).$mount("#app");
