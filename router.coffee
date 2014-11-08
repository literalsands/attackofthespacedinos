Router.configure
  autorender: false

if Meteor.isServer
  Meteor.startup ->
    AccountsEntry.config {}

if Meteor.isClient
  Meteor.startup ->
    AccountsEntry.config
      homeRoute: '/'
      dashboardRoute: '/zoo'
      profileRoute: 'zoo'

Router.onBeforeAction -> AccountsEntry.signInRequired @
,
  only: ['home', 'zoo', 'arena']

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

  @route 'zoo',
    path: '/zoo'
    template: 'game'
    yieldTemplates:
      zoo: to: 'main'
    onBeforeAction: ->
      @subscribe 'userZoo'
      @next()
    data: ->
      Dinosaurs.find()


