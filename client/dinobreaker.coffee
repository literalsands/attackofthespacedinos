Session.setDefault "counter", 0

Template.dinosaurs.helpers
  userDinosaurs: ->
    Dinosaurs.find
      owner: undefined

Template.dinosaur.helpers
  stats: {}

Template.dinosaur.events
  'click button': ->
    Session.set "counter", Session.get("counter") + 1

