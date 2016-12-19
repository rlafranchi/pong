<template>
  <div class="table">
    <paddle position="left"></paddle>
    <paddle position="right"></paddle>
    <ball></ball>
  </div>
</template>

<script>
import Ball from './Ball'
import Paddle from './Paddle'

export default {
  name: 'table',
  data () {
    return {
    }
  },
  components: {
    Ball,
    Paddle
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.table {
  position: absolute;
  width: 650px;
  height: 480px;
  background-color: #000;
}
</style>
