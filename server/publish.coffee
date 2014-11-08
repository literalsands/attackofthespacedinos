Meteor.publish 'match', (match_id) ->
  DinoMatches.find _id: match_id

Meteor.publish 'userZoo', ->
  Dinosaurs.find owner: this.userId

Meteor.publish 'userMatches', ->
  DinoMatches.find players: this.userId
