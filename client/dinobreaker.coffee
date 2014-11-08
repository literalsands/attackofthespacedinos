Session.setDefault "counter", 0

Template.dinosaur.helpers
  name: -> #function (a) {
    Dinosaurs.findOne()?.name
  #}

Template.dinosaur.events
  'click button': ->
    Session.set "counter", Session.get("counter") + 1

