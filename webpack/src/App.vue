<template>
  <div id="app">
    <h1>Pong</h1>
    <p>Welcome, {{ currentPlayer.name }}</p>
    <div v-if="currentPlayer.id == null">
      <input v-model="currentPlayer.name" type="text"/>
      <button @click="createPlayer">Sign In</button>
    </div>
    <game-list v-if="currentPlayer.id != null" :currentPlayer="currentPlayer" v-on:joined="joinGame"></game-list>
  </div>
</template>

<script>
import GameList from './components/GameList'

export default {
  name: 'app',
  data () {
    return {
      error: null,
      apiUrl: 'http://localhost:3000/api',
      joined: false,
      currentPlayer: {
        id: null,
        name: ''
      }
    }
  },
  components: {
    'game-list': GameList
  },
  methods: {
    createPlayer () {
      var that = this
      this.$http.post(this.apiUrl + '/players', {
        player: {
          name: this.currentPlayer.name
        }
      })
      .then((res) => {
        that.currentPlayer = res.data
      })
      .catch((e) => {
        console.log(e.data.errors)
        that.error = e.data.errors
      })
    },
    joinGame () {
      this.joined = true
    }
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  padding: 15px;
}
</style>
