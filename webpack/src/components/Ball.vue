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
      var nextY = this.y + (1 * this.direction.y)
      var nextX = this.x + (1 * this.direction.x)

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
      } else {
        // upper wall and lower walls
        if (nextY >= 465 || nextY <= 0) {
          this.direction.y = -this.direction.y
        }
        // paddles
        var slope = (nextY - this.y) / (nextX - this.x)
        var pointOfContact = this.pointOfContact(slope)
        if (((nextX <= 45 && this.x > 45) || (nextX >= 590 && this.x < 590)) && this.willHit(pointOfContact)) {
          this.deflect(pointOfContact)
        }
      }

      this.x += (1 * this.direction.x)
      this.y += (1 * this.direction.y)
      this.rightPaddle.y = this.y > 400 ? 400 : this.y
    },
    willHit (pointOfContact) {
      var upperPaddle = this.nextPaddle().y + 95
      var topOf = pointOfContact + 15
      return topOf >= this.nextPaddle().y && topOf <= upperPaddle
    },
    nextPaddle () {
      return this.nextHit === 'left' ? this.leftPaddle : this.rightPaddle
    },
    pointScored () {
      return this.x <= -15 || this.x >= 650
    },
    tally () {
      this.toggleNextHit()
      this.$parent.score(this.nextHit)
    },
    deflect (pointOfContact) {
      this.x = this.paddleX()
      this.y = pointOfContact
      var relativePoint = pointOfContact + 7.5 - 40 - this.nextPaddle().y
      var slopeIndex = Math.ceil(Math.abs(relativePoint / 10))
      slopeIndex = slopeIndex > 4 ? 4 : slopeIndex
      this.direction.y = VALID_SLOPES[slopeIndex]
      this.direction.y = relativePoint < 0 ? -this.direction.y : this.direction.y
      this.direction.x = -this.direction.x
      this.toggleNextHit()
    },
    toggleNextHit () {
      this.nextHit = this.nextHit === 'left' ? 'right' : 'left'
    },
    paddleX () {
      return this.nextHit === 'left' ? 45 : 590
    },
    pointOfContact (slope) {
      var deltaX = this.paddleX() - this.x
      var deltaY = slope * deltaX
      return this.y + deltaY
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
