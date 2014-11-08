Session.setDefault 'match_id', null
Session.setDefault 'action', null

Template.dinosaur.helpers
  stats: ->

Template.dinosaur.events
  'click .fight': ->
    Meteor.call 'lookForArenaMatch', @_id

Template.arena.helpers
  userDino: ->
    Dinosaurs.findOne @[Meteor.userId()]?.dinosaur
  opponentDino: ->
    opponent = (@players.indexOf(Meteor.userId()) + 1) % 2
    Dinosaurs.findOne @[@players[opponent]]?.dinosaur
  HP_BAR: ->
    hp = 6
    "[#{ Array(hp).join('&#10084;') }#{ Array(6-hp).join(' ') }]"
  opponentStance: ->
    opponent = (@players.indexOf(Meteor.userId()) + 1) % 2
    console.log @
    switch @[@players[opponent]]?.action
      when 0
        "an attack"
      when 1
        "an attack"
      when 2
        "a defensive"
      when 3
        "a defensive"

Template.arena.events
  'click .win': ->
    Meteor.call 'winArenaMatch', @_id
  'click .dino-action.attack.primary': ->
    Meteor.call 'performAction', 0, Session.get 'match_id'
    Session.set 'action', 0
  'click .dino-action.attack.secondary': ->
    Meteor.call 'performAction', 1, Session.get 'match_id'
    Session.set 'action', 1
  'click .dino-action.defense.primary': ->
    Meteor.call 'performAction', 2, Session.get 'match_id'
    Session.set 'action', 2
  'click .dino-action.defense.secondary': ->
    Meteor.call 'performAction', 3, Session.get 'match_id'
    Session.set 'action', 3

Template.game.helpers
  serverTime: -> +new Date()

# I have a match.
Tracker.autorun ->
  query =
    players:
      $size: 2
    expired:
      $ne: true
  query[Meteor.userId()] = $exists: true
  dinoMatch = DinoMatches.findOne query
  if dinoMatch
    Session.set 'match_id', dinoMatch._id
    Router.go 'arena'
    ,
      match_id: dinoMatch._id
  else
    Router.go 'zoo'
