# pong

> Pong reinvented using Rails and Vue.js

## A Vue Webpack template forked from vuejs-templates/webpack

This template is intended for use with the Rails framework.  It is inteded to separate client and server and with Rails projects initialized using the --api flag.

Simply setup a new rails project

```bash
rails new vue-rails --api
```
Make sure you have vue-cli installed and run the following using the same project name

```bash
vue init rlafranchi/webpack vue-rails
```

## Build Setup

``` bash
cd vue-rails
# install dependencies
npm install

# serve with hot reload at localhost:8080
npm run dev

# build for production with minification
npm run build

# run unit tests
npm run unit

# run e2e tests
npm run e2e

# run all tests
npm test
```

For detailed explanation on how things work, checkout the [guide](http://vuejs-templates.github.io/webpack/) and [docs for vue-loader](http://vuejs.github.io/vue-loader).
