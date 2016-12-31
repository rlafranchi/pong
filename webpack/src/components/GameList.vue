<template>
  <table>
    <thead>
      <tr>
        <th>Game</th>
        <th>Players (left/right)</th>
        <th>Status</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="game in games">
        <td>Game #{{ game.id }}</td>
        <td>
          <span v-if="game.left_player">{{ game.left_player.name }}</span>
          <span v-else><button @click="join(game, 'left')" :disabled="currentGame">Join</button></span>
          /
          <span v-if="game.right_player">{{ game.right_player.name }}</span>
          <span v-else><button @click="join(game, 'right')" :disabled="currentGame">Join</button></span>
        </td>
        <td>{{ game.status }}</td>
      </tr>
      <tr>
        <td><button @click="newGame">+ Game</button></td>
      </tr>
    </tbody>
    <pong-table v-if="currentGame" :game="currentGame"></pong-table>
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
      games: [],
      currentGame: null
    }
  },
  components: {
    'pong-table': Table
  },
  created () {
    this.fetchGames()
  },
  methods: {
    fetchGames () {
      var that = this
      this.$http.get(this.$parent.apiUrl + '/games')
        .then((res) => {
          that.games = res.data
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
          player_id: this.$parent.currentPlayer.id,
          game_id: game.id,
          position: position
        }
      }).then((res) => {
        that.fetchGames()
        that.currentGame = game
      }).catch((e) => {
        that.$emit('error', e)
        console.log(e)
      })
    }
  }
}
</script>
