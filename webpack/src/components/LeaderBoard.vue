<template>
  <div>
    <h3>Leader Board</h3>
    <table>
      <thead>
        <tr>
          <th>Player</th>
          <th>PCT Won</th>
          <th>Total Games</th>
          <th>Games Won</th>
          <th>Points Scored</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="leader in orderedLeaders">
          <td>{{ leader.name }}</td>
          <td>{{ pctWon(leader) }}%</td>
          <td>{{ leader.total_games }}</td>
          <td>{{ leader.games_won }}</td>
          <td>{{ leader.points }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import _ from 'lodash'
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
    window.setInterval(() => {
      that.fetchLeaders()
    }, 5000)
  },
  computed: {
    orderedLeaders () {
      var that = this
      var ordered = _.orderBy(this.leaders, ['games_won', 'total_games', 'points'], ['desc', 'desc', 'desc'])
      return ordered.filter((leader) => {
        if (that.leaders.indexOf(leader) <= 4) {
          return leader
        }
      })
      // look at more accurate evaluation based on average points per game weighted based on number of games played
      // var that = this
      // return _.sortBy(that.leaders, (leader) => {
      //   return [-that.pctWon(leader)]
      // })
    }
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
      return Math.round(100 * (leader.games_won / leader.total_games))
    }
  }
}
</script>
