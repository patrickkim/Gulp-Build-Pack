template = require("./templates/test")

App =
  start: ->
    console.log "app started! again"
    console.log template(description: "hello")

module.exports = App
