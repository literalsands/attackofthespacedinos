Meteor.publish 'match', (match_id) ->
  Matches.find _id: match_id

Meteor.publish 'userZoo', ->
  Dinosaurs.find owner: this.userId
