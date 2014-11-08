@Dinosaurs = new Meteor.Collection "dinos",
  transform: (doc) -> new Dinosaur doc

class @Dinosaur
  constructor: (doc) ->
    _.extend @, doc
  name: "Dinosaur"
  attackOne: "Tail Swipe"
  attackTwo: "Headbutt"
  defendOne: "Defend"
  defendTwo: "Dodge"

@Games = new Meteor.Collection "games",
  transform: (doc) -> new Game doc

class @Game
  constructor: (doc) ->
    _.extend @, doc
  playerOne: null
  playerTwo: null

