Backbone = require "backbone"
window.App = require "./app"

# Set Backbone.$ to window.$
$ = Backbone.$ = window.$

$ ->
  App.initialize()
  console.log "testing"
