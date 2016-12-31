<template>
  <div
    class="table"
    @mousemove="moveWithMouse($event)"
    @mouseleave="bottomOrTop()">
    <div class="net"></div>
    <div class="scores">
      <span class="one">{{ scores[0] }}</span>
      <span class="two">{{ scores[1] }}</span>
    </div>
    <paddle position="left" :paddle="leftPaddle"></paddle>
    <paddle position="right" :paddle="rightPaddle"></paddle>
    <ball :leftPaddle="leftPaddle" :rightPaddle="rightPaddle"></ball>
  </div>
</template>

<script>
import Ball from './Ball'
import Paddle from './Paddle'

export default {
  name: 'table',
  data () {
    return {
      pongChannel: {},
      scores: [0, 0],
      leftPaddle: {
        y: 200
      },
      rightPaddle: {
        y: 200
      }
    }
  },
  created () {
    var that = this
    this.pongChannel = this.$cable.subscriptions.create('PongChannel', {
      received (data) {
        that.leftPaddle.y = data.y
      }
    })
    window.addEventListener('keydown', this.move)
  },
  components: {
    Ball,
    Paddle
  },
  methods: {
    move (e) {
      e.preventDefault()
      switch (e.keyCode) {
        case 38:
          if (this.leftPaddle.y < 400) {
            this.leftPaddle.y += 40
          }
          break
        case 40:
          if (this.leftPaddle.y > 0) {
            this.leftPaddle.y -= 40
          }
          break
      }
    },
    moveWithMouse (e) {
      var newY = 480 - e.layerY
      newY = newY > 400 ? 400 : newY
      this.leftPaddle.y = newY
      this.pongChannel.send(this.leftPaddle)
    },
    bottomOrTop () {
      this.leftPaddle.y = this.leftPaddle.y >= 240 ? 400 : 0
    },
    score (paddle) {
      console.log('paddle ' + paddle + ' scored')
      if (paddle === 'left') {
        this.$set(this.scores, 0, this.scores[0] + 1)
      } else {
        this.$set(this.scores, 1, this.scores[1] + 1)
      }
    },
    gameOver () {
      return this.scores[0] === 10 || this.scores[1] === 10
    }
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
