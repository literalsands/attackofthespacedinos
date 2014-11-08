@Dinosaurs = new Meteor.Collection "dinos",
  transform: (doc) -> new Dinosaur doc

class @Dinosaur
  constructor: (doc) ->
    _.extend @, doc
  name: "Dinosaur"
  attackOne: ->
    "Tail Swipe"
  attackTwo: ->
    "Headbutt"
  defendOne: ->
    "Defend"
  defendTwo: ->
    "Dodge"

@DinoMatches = new Meteor.Collection "dino_matches",
  transform: (doc) -> new DinoMatch doc

@Actions = [
  defense: 0
  attack: 1
  success: 9/10
  time: 1
,
  defense: 0
  attack: 2
  success: 8/10
  time: 1.75
,
  defense: 1.25
  attack: 0
  success: 8/10
  time: 1
,
  defense: 2
  attack: 1
  success: 5/10
  time: 1.25
]

class @DinoMatch
  constructor: (doc) ->
    _.extend @, doc
  players: [null, null]
  resolveAction: ->
    that = @
    players = _.sortBy @players, (player) ->
      that[player].time

    ret =  {}
    pda = @players.map (player) ->
      [player, that[player].dinosaur, that[player].action]

    @state

    _.sorted pda

    expired: true
    winner: pda[0][0]



