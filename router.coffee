Router.configure
  autorender: false

if Meteor.isServer
  Meteor.startup ->
    AccountsEntry.config {}

if Meteor.isClient
  Meteor.startup ->
    AccountsEntry.config
      homeRoute: '/'
      dashboardRoute: '/'
      profileRoute: 'zoo'

Router.map ->
  #@route 'home',
  #path: '/'
  #template: 'game'
  #data: {}
  #onBeforeAction: ->
  #AccountsEntry.signInRequired @

  @route 'arena',
    path: '/arena/:match_id'
    template: 'game'
    yieldTemplates:
      arena: to: 'frame'
    onBeforeAction: ->
      AccountsEntry.signInRequired @
      @subscribe 'match', @params.match_id
    data: ->
      Matches.find _id: @params.match_id

  @route 'zoo',
    path: '/'
    template: 'game'
    yieldTemplates:
      zoo: to: 'frame'
    onBeforeAction: ->
      AccountsEntry.signInRequired @
      @subscribe 'userZoo'
    data: ->
      Dinosaurs.find()


