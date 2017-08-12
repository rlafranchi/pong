var merge = require('webpack-merge')
var prodEnv = require('./prod.env')

module.exports = merge(prodEnv, {
  NODE_ENV: '"development"',
  RAILS_URL: '"http://localhost:3000"',
  STRIPE_PK: '"pk_test_fI98pLJ5HlziNWAA56tW5QlT"'
})
