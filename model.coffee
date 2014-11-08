@Dinosaurs = new Meteor.Collection "dinos",
  transform: (doc) -> new Dinosaur doc

class @Dinosaur
  constructor: (doc) ->
    _.extend @, doc
  name: "Jeremy"

@Games = new Meteor.Collection "games",
  transform: (doc) -> new Game doc

class @Game
  constructor: (doc) ->
    _.extend @, doc
  name: "Jeremy"

