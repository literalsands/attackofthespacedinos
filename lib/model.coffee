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

class @DinoMatch
  constructor: (doc) ->
    _.extend @, doc
  players: [null, null]

