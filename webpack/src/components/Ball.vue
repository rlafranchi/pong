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
  data () {
    return {
      intervalId: null,
      x: 500,
      y: 400,
      direction: {}
    }
  },
  methods: {
    serve () {
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
      if (nextX <= 45) {
        this.x = 45
        this.direction.x = 1
      }
      // right paddle
      if (nextX >= 590) {
        this.x = 590
        this.direction.x = -1
      }

      this.x += this.direction.x
      this.y += this.direction.y
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
