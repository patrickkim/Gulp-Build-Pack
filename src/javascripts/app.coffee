test_view = require "./views/test_view"

App =
  initialize: (options) ->
    @_setup_views(options)

  _setup_views: (options) ->
    App.view = new test_view(el: "#application")

module.exports = App
