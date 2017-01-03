<template>
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
      <tr v-for="game in gamesOrCurrent">
        <td>Game #{{ game.id }}</td>
        <td>
          <span v-if="game.left_player">{{ game.left_player.name }} (<b>{{ game.left_player.score }}</b>)</span>
          <span v-else><button @click="join(game, 'left')" :disabled="currentGame">Join</button></span>
        </td>
        <td>
          <span v-if="game.right_player">{{ game.right_player.name }} (<b>{{ game.right_player.score }}</b>)</span>
          <span v-else><button @click="join(game, 'right')" :disabled="currentGame">Join</button></span>
        </td>
        <td>{{ game.status }}</td>
      </tr>
      <tr>
        <td><button @click="newGame">+ Game</button></td>
      </tr>
    </tbody>
    <pong-table v-if="currentGame" :game="currentGame" :currentPlayer="currentPlayer"></pong-table>
  </table>
</template>

<script>
import Table from './Table'

export default {
  props: {
    currentPlayer: Object
  },
  data () {
    return {
      gamesChannel: null,
      games: [],
      currentGame: null
    }
  },
  components: {
    'pong-table': Table
  },
  created () {
    this.fetchGames()
    var that = this
    this.$cable.subscriptions.create('GamesChannel', {
      received (data) {
        var gameIndex = that.games.map((game) => game.id).indexOf(data.id)
        that.$set(that.games, gameIndex, data)
        if (that.currentGame != null) {
          if (data.id === that.currentGame.id) {
            if (data.status === 'over') {
              that.currentGame = null
            } else {
              that.currentGame = data
            }
          }
        }
      }
    })
  },
  computed: {
    gamesOrCurrent () {
      var that = this
      return this.games.filter((game) => {
        if (that.currentGame != null && that.currentGame.id === game.id) {
          return game
        } else if (that.currentGame === null) {
          return game
        }
      })
    }
  },
  methods: {
    fetchGames (current) {
      var that = this
      this.$http.get(this.$parent.apiUrl + '/games')
        .then((res) => {
          that.games = res.data
          if (current) {
            var gameIndex = that.games.map((game) => game.id).indexOf(current.id)
            that.currentGame = that.games[gameIndex]
          }
        })
    },
    newGame () {
      var that = this
      this.$http.post(this.$parent.apiUrl + '/games')
        .then((res) => {
          that.games.push(res.data)
        })
    },
    join (game, position) {
      var that = this
      this.$http.post(this.$parent.apiUrl + '/players_games', {
        players_game: {
          player_id: this.currentPlayer.id,
          game_id: game.id,
          position: position
        }
      }).then((res) => {
        that.fetchGames(game)
      }).catch((e) => {
        that.$emit('error', e)
        console.log(e)
      })
    }
  }
}
</script>
