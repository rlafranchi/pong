<template>
  <div class="table">
    <div class="net"></div>
    <div class="scores">
      <span class="one">{{ scores[0] }}</span>
      <span class="two">{{ scores[1] }}</span>
    </div>
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
      scores: [8, 10]
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
  font-family: monospace;
  font-weight: bold;
}

.net {
  width: 0px;
  border: 4px dotted #fff;
  height: 480px;
  margin-left: 320px;
}

.scores {
  position: absolute;
  width: 100%;
  top: 10px;
  color: #fff !important;
  font-size: 48px;
}

.scores .one {
  position: absolute;
  right: 325px;
  margin-right: 15px;
}

.scores .two {
  position: absolute;
  left: 325px;
  margin-left: 15px;
}
</style>
