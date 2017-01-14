import Vue from 'vue'
import App from './App'
import ActionCable from 'actioncable'
import axios from 'axios'
var webSocketProtocol = process.env.NODE_ENV === 'production' ? 'wss' : 'ws'
const cable = ActionCable.createConsumer(webSocketProtocol + '://' + process.env.RAILS_URL.replace(/.*?:\/\//g, '') + '/cable')

Vue.prototype.$http = axios
Vue.prototype.$cable = cable

/* eslint-disable no-new */
new Vue({
  el: '#app',
  template: '<App/>',
  components: { App }
})
