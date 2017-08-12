var merge = require('webpack-merge')
var devEnv = require('./dev.env')

module.exports = merge(devEnv, {
  NODE_ENV: '"testing"',
  RAILS_URL: '"http://api.example.com"',
  STRIPE_PK: '"pk_test_fI98pLJ5HlziNWAA56tW5QlT"'
})
