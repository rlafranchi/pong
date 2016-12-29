<template>
  <div id="app">
    <h1>Pong</h1>
    <pong-table></pong-table>
  </div>
</template>

<script>
import Table from './components/Table'
import ActionCable from 'actioncable'
const cable = ActionCable.createConsumer('ws://localhost:28080')

export default {
  name: 'app',
  data () {
    return {
      cable: cable
    }
  },
  components: {
    'pong-table': Table
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  padding: 15px;
}
</style>
