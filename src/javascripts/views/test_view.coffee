_ = require "underscore"
Backbone = require "backbone"
template = require "../templates/test"

class TestView extends Backbone.View

  id: "application"
  template: template

  initialize: (options) ->
    @render()

  render: ->
    @$el.html @template
      description: "hello",
      tools: @_tools()
    this

  _tools: ->
    [ _.random(0,10), _.random(0,10)]

module.exports = TestView
