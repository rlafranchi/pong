<template>
  <div
    class="ball"
    v-bind:style="{ bottom: y + 'px', left: x + 'px' }">
  </div>
</template>

<script>
const VALID_SLOPES = [0, 0.0875, 0.2679, 0.5773, 1]
import _ from 'lodash'

export default {
  name: 'ball',
  created () {
    this.serve()
  },
  props: {
    leftPaddle: Object,
    rightPaddle: Object
  },
  data () {
    return {
      intervalId: null,
      nextHit: 'left',
      x: 318,
      y: 232,
      direction: {}
    }
  },
  methods: {
    serve () {
      this.direction.x = this.nextHit === 'left' ? -1 : 1
      this.direction.y = _.sample(VALID_SLOPES)
      if (Math.random() > 0.5) {
        this.direction.y = -this.direction.y
      }
      var that = this
      this.intervalId = window.setInterval(() => {
        that.update()
      }, 1)
    },
    update () {
      var nextY = this.y + this.direction.y
      var nextX = this.x + this.direction.x

      if (this.pointScored()) {
        window.clearInterval(this.intervalId)
        console.log('Point Scored')
        this.tally()
        if (this.$parent.gameOver()) {
          console.log('Game Over')
          this.$destroy
        } else {
          this.x = 318
          this.y = 232
          this.serve()
        }
      }

      // upper wall
      if (nextY >= 465) {
        this.y = 465
        this.direction.y = -this.direction.y
      }
      // lower wall
      if (nextY <= 0) {
        this.y = 0
        this.direction.y = -this.direction.y
      }
      // left paddle
      if (nextX <= 45 && this.x > 45 && this.willHit()) {
        this.direction.x = 1
        this.nextHit = 'right'
      }
      // right paddle
      if (nextX >= 590 && this.x < 590 && this.willHit()) {
        this.direction.x = -1
        this.nextHit = 'left'
      }

      this.x += this.direction.x
      this.y += this.direction.y
    },
    willHit () {
      var nextPaddle = this.nextHit === 'left' ? this.leftPaddle : this.rightPaddle
      var upperPaddle = nextPaddle.y + 95
      var topOf = this.y + 15
      return topOf >= nextPaddle.y && topOf <= upperPaddle
    },
    pointScored () {
      return this.x <= -15 || this.x >= 650
    },
    tally () {
      this.nextHit = this.nextHit === 'left' ? 'right' : 'left'
      this.$parent.score(this.nextHit)
    }
  }
}
</script>

<style scoped>
.ball {
  background-color: #fff;
  position: absolute;
  width: 15px;
  height: 15px;
}
</style>
