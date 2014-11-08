Router.configure
  autorender: false

Router.onBeforeAction ->
  AccountsEntry.signInRequired @

Router.map ->
  @route 'home',
    path: '/'
    template: 'game'
    data: {}

  @route 'arena',
    path: '/arena/:match_id'
    template: 'game'
    yieldTemplates:
      arena: to: 'main'
    onBeforeAction: ->
      @subscribe 'match', @params.match_id
      @next()
    data: ->
      Matches.find _id: @params.match_id


