<template>
  <div>
    <h3>Leader Board</h3><a href="#!" @click="fetchLeaders()">refresh</a>
    <table>
      <thead>
        <tr>
          <th>Player</th>
          <th>Games Won</th>
          <th>Total Games</th>
          <th>PCT Won</th>
          <th>Points Scored</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="leader in leaders">
          <td>{{ leader.name }}</td>
          <td>{{ leader.games_won }}</td>
          <td>{{ leader.total_games }}</td>
          <td>{{ pctWon(leader) }}%</td>
          <td>{{ leader.points }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  data () {
    return {
      leaders: []
    }
  },
  created () {
    var that = this
    // polling Why not?
    that.fetchLeaders()
//    window.setInterval(() => {
//      that.fetchLeaders()
//    }, 5000)
  },
  methods: {
    fetchLeaders () {
      var that = this
      this.$http.get(this.$parent.apiUrl + '/leaders')
        .then((res) => {
          that.leaders = res.data
        })
    },
    pctWon (leader) {
      if (leader.total_games > 0) {
        return Math.round(100 * (leader.games_won / leader.total_games))
      } else {
        return 0
      }
    }
  }
}
</script>
