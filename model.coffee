@Dinosaurs = new Meteor.Collection "dinos",
  transform: (doc) -> new Dinosaur doc

class @Dinosaur
  name: "Jeremy"

@Games = new Meteor.Collection "games",
  transform: (doc) -> new Game doc

class @Game
  name: "Jeremy"

