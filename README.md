# pong

> Pong reinvented using Rails and Vue.js

This purpose of this app was to demonstrate the use of a progressive JavaScript framework [Vue.js](https://vuejs.org) and Rails ActionCable to build a two player pong game that can be played over the web.

## Demo

Just over 500 games have been played on the demo.  I decided to request a $1 donation at the end of the game.  If you found this helpful in any way, support the project by playing a game for $1.00 and invite your friends:

[https://vue-rails-pong.herokuapp.com](https://vue-rails-pong.herokuapp.com)

## The Basic Architecture when Playing a Game

![Pong Architecture](Pong%20Diagram.png?raw=true)

There also exists a GamesChannel which broadcasts every time a point is scored or a game changes state.

## Latency issue

There exists a latency issue where a paddle's position may be behind to it's true position at a point in time.  This may also exist with the ball's position as seen by the client.  I'm sure this is a common issue among multiplayer games, but have no experience in that department so am open to suggestions.

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
