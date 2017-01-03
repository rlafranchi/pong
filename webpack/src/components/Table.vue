<template>
  <div
    class="table"
    @mousemove="moveWithMouse($event)"
    @mouseleave="bottomOrTop()">
    <div class="net"></div>
    <div class="scores">
      <span class="one">{{ game.left_player ? game.left_player.score : 0 }}</span>
      <span class="two">{{ game.right_player ? game.right_player.score : 0 }}</span>
    </div>
    <paddle position="left" :paddle="leftPaddle"></paddle>
    <paddle position="right" :paddle="rightPaddle"></paddle>
    <ball :game="game"></ball>
  </div>
</template>

<script>
import Ball from './Ball'
import Paddle from './Paddle'

export default {
  name: 'table',
  props: {
    currentPlayer: Object,
    game: Object
  },
  data () {
    return {
      currentPosition: null,
      paddleChannel: null,
      leftPaddle: {
        y: 200
      },
      rightPaddle: {
        y: 200
      }
    }
  },
  created () {
    window.addEventListener('keydown', this.move)
    if (this.game.left_player != null && this.currentPlayer.id === this.game.left_player.id) {
      this.currentPosition = 'left'
      this.subscribeLeft()
    } else if (this.game.right_player != null && this.currentPlayer.id === this.game.right_player.id) {
      this.currentPosition = 'right'
      this.subscribeRight()
    } else {
      // allows for watching a game
      this.currentPosition = null
      this.subscribeLeft()
      this.subscribeRight()
    }
  },
  components: {
    Ball,
    Paddle
  },
  methods: {
    move (e) {
      e.preventDefault()
      if (this.currentPosition != null) {
        switch (e.keyCode) {
          case 38:
            if (this.currentPaddle().y < 400) {
              this.currentPaddle().y += 40
            }
            break
          case 40:
            if (this.currentPaddle().y > 0) {
              this.currentPaddle().y -= 40
            }
            break
        }
        this.paddleChannel.send({y: this.currentPaddle().y})
      }
    },
    moveWithMouse (e) {
      if (this.currentPosition != null) {
        var newY = 480 - e.layerY
        newY = newY > 400 ? 400 : newY
        this.currentPaddle().y = newY
        this.paddleChannel.send({y: this.currentPaddle().y})
      }
    },
    currentPaddle () {
      return this[this.currentPosition + 'Paddle']
    },
    subscribeLeft () {
      var that = this
      this.paddleChannel = this.$cable.subscriptions.create({channel: 'LeftPaddleChannel', game_id: this.game.id}, {
        received (data) {
          that.rightPaddle.y = data.y
        }
      })
    },
    subscribeRight () {
      var that = this
      this.paddleChannel = this.$cable.subscriptions.create({channel: 'RightPaddleChannel', game_id: this.game.id}, {
        received (data) {
          that.leftPaddle.y = data.y
        }
      })
    },
    bottomOrTop () {
      this.currentPaddle().y = this.currentPaddle().y >= 240 ? 400 : 0
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
