Session.setDefault "counter", 0

Template.dinosaurs.helpers
  dinosaurs: ->
    Dinosaurs.find()

Template.dinosaur.helpers
  stats: ->

Template.arena.helpers
  userDino: ->

  opponentDino: ->

Template.dinoBattle.events
  'click .dino-action': ->

