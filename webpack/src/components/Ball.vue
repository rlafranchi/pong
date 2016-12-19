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
      nextHit: null,
      x: 500,
      y: 400,
      direction: {}
    }
  },
  methods: {
    serve () {
      this.nextHit = this.leftPaddle
      this.direction.x = -1
      this.direction.y = _.sample(VALID_SLOPES)
      var coinFlip = _.sample([true, false])
      if (coinFlip) {
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
        // right scored
        if (this.x <= 0) {
          this.$parent.score('right')
        } else {
          this.$parent.score('left')
        }
        this.x = 500
        this.y = 400
        this.serve()
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
      if (nextX <= 45 && this.x > 45) {
        if (this.willHit()) {
          this.x = 45
          this.direction.x = 1
          this.nextHit = this.rightPaddle
        }
      }
      // right paddle
      if (nextX >= 590 && this.x < 590) {
        if (this.willHit()) {
          this.x = 590
          this.direction.x = -1
          this.nextHit = this.leftPaddle
        }
      }

      this.x += this.direction.x
      this.y += this.direction.y
    },
    willHit () {
      var upperPaddle = this.nextHit.y + 95
      var topOf = this.y + 15
      return topOf >= this.nextHit.y && topOf <= upperPaddle
    },
    pointScored () {
      return this.x <= 0 || this.x >= 650
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
