<template>
  <!--<div-->
    <!--class="ball"-->
    <!--v-bind:style="{ bottom: y + 'px', left: x + 'px' }">-->
  <!--</div>-->
  <rect :x="x" :y="y" width="15" height="15" fill="white"/>
</template>

<script>
export default {
  name: 'ball',
  props: {
    game: Object
  },
  data () {
    // leave the ball off the board
    return {
      pongChannel: null,
      x: -50,
      y: -50
    }
  },
  created () {
    var that = this
    this.pongChannel = this.$cable.subscriptions.create({ channel: 'PongChannel', game_id: this.game.id }, {
      received (data) {
        that.y = data.y
        that.x = data.x
      }
    })
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
