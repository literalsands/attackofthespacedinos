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

@Matches = new Meteor.Collection "games",
  transform: (doc) -> new Match doc

class @Match
  constructor: (doc) ->
    _.extend @, doc
  players: [null, null]

