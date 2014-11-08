Template.dinosaur.helpers
  stats: ->

Template.arena.helpers
  userDino: ->

  opponentDino: ->

Template.arena.events
  'click .dino-action': ->

Template.game.helpers
  serverTime: -> +new Date()
