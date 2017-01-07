# pong

> Pong reinvented using Rails and Vue.js

This purpose of this app was to demonstrate the use of a progressive JavaScript framework [Vue.js](https://vuejs.org) and Rails ActionCable to build a two player pong game that can be played over the web.

## Demo

[https://vue-rails-pong.herokuapp.com](https://vue-rails-pong.herokuapp.com)

## Rails Dev Setup
```bash
# run the migration
rake db:migrate

# dev server
rails server
```

## Webpack Dev Setup

``` bash
# install dependencies
npm install

# serve with hot reload at localhost:8080
npm run dev
```

## Production Setup

The app is deployed to heroku using a nodejs buildpack and ruby buildpack.  A configuartion in package.json for "heroku-postbuild" which runs `npm run build` before starting the Rails server.
