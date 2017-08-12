<template>
  <div>
    <h3>Games</h3>
    <table>
      <thead>
        <tr>
          <th>Game</th>
          <th>Left Player (score)</th>
          <th>Right Player (score)</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        <tr v-if="loading">
          <td>
            <span v-if="loadingIndex === 0">\</span>
            <span v-if="loadingIndex === 1">|</span>
            <span v-if="loadingIndex === 2">/</span>
            <span v-if="loadingIndex === 3">-</span>
          </td>
        </tr>
        <tr v-if="currentGame === null && !loading">
          <td><button @click="newGame">+ Game</button></td>
        </tr>
        <tr v-for="game in orderedGames">
          <td>Game #{{ game.id }}</td>
          <td>
            <span v-if="game.left_player">{{ game.left_player.name }} (<b>{{ game.left_player.score }}</b>)</span>
            <span v-else><button @click="openCheckout(game, 'left')" :disabled="currentGame">Join</button></span>
          </td>
          <td>
            <span v-if="game.right_player">{{ game.right_player.name }} (<b>{{ game.right_player.score }}</b>)</span>
            <span v-else><button @click="openCheckout(game, 'right')" :disabled="currentGame">Join</button></span>
          </td>
          <td>{{ game.status }}</td>
        </tr>
      </tbody>
    </table>
    <pong-table v-if="currentGame" :game="currentGame" :currentPlayer="currentPlayer"></pong-table>
  </div>
</template>

<script>
/* global StripeCheckout:true */
import Table from './Table'
import _ from 'lodash'

export default {
  props: {
    currentPlayer: Object
  },
  data () {
    return {
      gamesChannel: null,
      games: [],
      currentGame: null,
      loading: false,
      loadingIndex: 0,
      stripeHandler: null,
      proposedGame: null,
      proposedPosition: null
    }
  },
  components: {
    'pong-table': Table
  },
  created () {
    var that = this
    this.stripeHandler = StripeCheckout.configure({
      key: 'pk_test_fI98pLJ5HlziNWAA56tW5QlT',
      image: 'https://stripe.com/img/documentation/checkout/marketplace.png',
      locale: 'auto',
      token: function (token) {
        that.join(token.id)
      }
    })
    this.fetchGames()
    this.$cable.subscriptions.create('GamesChannel', {
      received (data) {
        var gameIndex = that.games.map((game) => game.id).indexOf(data.id)
        if (gameIndex > -1) {
          that.$set(that.games, gameIndex, data)
        } else {
          that.games.push(data)
        }
        if (that.currentGame != null && data.id === that.currentGame.id) {
          that.currentGame = data
          if (data.status === 'over') {
            window.alert('Game Over!')
            that.currentGame = null
          }
        }
      }
    })
  },
  computed: {
    gamesOrCurrent () {
      var that = this
      return this.gamesNotOver.filter((game) => {
        if (that.currentGame != null && that.currentGame.id === game.id) {
          return game
        } else if (that.currentGame === null) {
          return game
        }
      })
    },
    gamesNotOver () {
      return this.games.filter((game) => game.status !== 'over')
    },
    orderedGames () {
      return _.orderBy(this.gamesOrCurrent, ['id'], ['desc'])
    }
  },
  methods: {
    fetchGames (current) {
      var that = this
      var spinner = window.setInterval(() => {
        that.loadingIndex = (that.loadingIndex + 1) % 4
      }, 100)
      this.loading = true
      this.$http.get(this.$parent.apiUrl + '/games')
        .then((res) => {
          that.games = res.data
          that.clearSpinner(spinner)
          if (current) {
            var gameIndex = that.games.map((game) => game.id).indexOf(current.id)
            that.currentGame = that.games[gameIndex]
          } else {
            current = that.games.find(game =>
              game.status !== 'over' &&
              ((game.left_player != null && game.left_player.id === that.currentPlayer.id) ||
              (game.right_player != null && game.right_player.id === that.currentPlayer.id))
            )
            that.currentGame = current && current.id ? current : null
          }
        }).catch((e) => {
          that.clearSpinner(spinner)
          console.log(e)
        })
    },
    clearSpinner (spinner) {
      this.loading = false
      window.clearInterval(spinner)
    },
    newGame () {
      this.$http.post(this.$parent.apiUrl + '/games')
    },
    openCheckout (game, position) {
      this.proposedGame = game
      this.proposedPosition = position
      this.stripeHandler.open({
        name: 'Pong',
        description: 'A single game of Pong',
        amount: 100,
        currency: 'usd'
      })
    },
    join (tokenId) {
      var that = this
      this.$http.post(this.$parent.apiUrl + '/players_games', {
        players_game: {
          player_id: this.currentPlayer.id,
          game_id: that.proposedGame.id,
          position: that.proposedPosition
        },
        stripe_token: tokenId
      }).then((res) => {
        that.fetchGames(that.proposedGame)
      }).catch((e) => {
        console.log(e)
      })
    }
  }
}
</script>
