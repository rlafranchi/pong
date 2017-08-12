<template>
  <div id="app">
    <h1>Pong</h1>
    <a class="github-button" href="https://github.com/rlafranchi/pong" data-icon="octicon-star" data-size="large" data-show-count="true" aria-label="Star rlafranchi/pong on GitHub">Star</a>
    <p>Welcome, {{ currentPlayer.name }}</p>
    <div v-if="currentPlayer.id == null">
      <input v-model="currentPlayer.name" type="text"/>
      <button @click="createPlayer">Sign In</button>
    </div>
    <leader-board></leader-board>
    <br>
    <game-list v-if="currentPlayer.id != null" :currentPlayer="currentPlayer" v-on:joined="joinGame"></game-list>
    <p>
      Created by <a href="https://twitter.com/ralafranchi">@ralafranchi</a> | Share:
      <a href="https://twitter.com/home?status=A%20Game%20of%20Pong%20anyone?%20https%3A//vue-rails-pong.herokuapp.com" target="_blank">Twitter</a> |
      <a href="https://plus.google.com/share?url=https%3A//vue-rails-pong.herokuapp.com" target="_blank">Google+</a> |
      <a href="https://www.facebook.com/sharer/sharer.php?u=https%3A//vue-rails-pong.herokuapp.com" target="_blank">Facebook</a> |
    </p>
  </div>
</template>

<script>
import GameList from './components/GameList'
import LeaderBoard from './components/LeaderBoard'

export default {
  name: 'app',
  data () {
    return {
      error: null,
      apiUrl: process.env.RAILS_URL + '/api',
      joined: false,
      currentPlayer: {
        id: null,
        name: ''
      }
    }
  },
  components: {
    'game-list': GameList,
    'leader-board': LeaderBoard
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
