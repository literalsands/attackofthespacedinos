Session.setDefault "counter", 0

Template.dinosaurs.helpers
  dinosaurs: ->
    Dinosaurs.find()

Template.dinosaur.helpers
  stats: ->

Template.dinoBattle.helpers
  dinoBattleGame: ->
    Games.findOne()
  dinoDefender: ->
    Dinosaurs.findOne()

Template.dinoBattle.events
  'click .dino-action': ->
    Session.set "counter", Session.get("counter") + 1

