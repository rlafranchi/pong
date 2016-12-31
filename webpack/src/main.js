import Vue from 'vue'
import App from './App'
import ActionCable from 'actioncable'
import axios from 'axios'
const cable = ActionCable.createConsumer('ws://localhost:3000/cable')

Vue.prototype.$http = axios
Vue.prototype.$cable = cable

/* eslint-disable no-new */
new Vue({
  el: '#app',
  template: '<App/>',
  components: { App }
})
