Session.setDefault 'match_id', null
Session.setDefault 'action', null

Template.dinosaur.helpers
  stats: ->

Template.dinosaur.events
  'click .fight': ->
    Meteor.call 'lookForArenaMatch', @_id

Template.arena.rendered = ->
  @autorun ->
    match = DinoMatches.findOne Session.get 'match_id'
    duration = match[Meteor.userId()]['action-lock'] - new Date()

    if duration > 0
      $('.four-box').css 'transition', ""
      $('.four-box').css 'background-color', 'yellow'

      setTimeout ->
        $('.four-box').css 'transition',
          "background-color #{ duration }ms cubic-bezier(1.000, 0.835, 0.000, 0.945)"
        $('.four-box').css 'background-color', 'white'
      , 100

Template.arena.helpers
  userDino: ->
    Dinosaurs.findOne @[Meteor.userId()]?.dinosaur
  opponentDino: ->
    opponent = (@players.indexOf(Meteor.userId()) + 1) % 2
    Dinosaurs.findOne @[@players[opponent]]?.dinosaur
  hpBar: ->
    dino = @
    hp_reduction = _.reduce DinoMatches.findOne(Session.get('match_id')).actions
    ,
      (ret, action) ->
        damage = 0

        dinos = _.keys action
        that_dino = _.without(dinos, dino._id)[0] if dinos.length isnt 0

        if that_dino
          attack = action[that_dino].attack or 0
          counter = action[that_dino].counter or 0
          if action[dino._id]
            block = action[dino._id].block or 0
            armor = action[dino._id].armor or 0
          else
            block = 0
            armor = 0

          back = counter - armor
          back = 0 if back < 0
          direct = attack - block
          direct = 0 if direct < 0
          damage = direct + back

        ret + (damage or 0)
    ,
      0

    hp = 20 - hp_reduction

    if hp <= 0 and @owner isnt Meteor.userId()
      Meteor.call 'winArenaMatch', Session.get 'match_id'

    hearts = Array(Math.floor hp).join('&#10084;')
    empty_hearts = Array(Math.floor hp_reduction + 1).join('&nbsp;')
    isPartial = hp > Math.floor hp
    partial = if isPartial then '&bullet;' else ''

    "<pre>[#{ hearts }#{ partial }#{ empty_hearts }]</pre>"

  opponentStance: ->
    opponent = (@players.indexOf(Meteor.userId()) + 1) % 2
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
