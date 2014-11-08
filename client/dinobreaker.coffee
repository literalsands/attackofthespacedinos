Template.dinosaur.helpers
  stats: ->

Template.dinosaur.events
  'click .fight': ->
    Meteor.call 'lookForArenaMatch', @_id

Template.arena.helpers
  userDino: ->
  opponentDino: ->

Template.arena.events
  'click .win': ->
    console.log @, @_id
    Meteor.call 'winArenaMatch', @_id
  'click .dino-action': ->

Template.game.helpers
  serverTime: -> +new Date()

Tracker.autorun ->
  query =
    players:
      $size: 2
    expired:
      $ne: true
  query[Meteor.userId()] = $exists: true
  dinoMatch = DinoMatches.findOne query
  if dinoMatch
    Router.go 'arena'
    ,
      match_id: dinoMatch._id
  else
    Router.go 'zoo'
