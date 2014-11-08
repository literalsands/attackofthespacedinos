Meteor.publish 'match', (match_id) ->
  match = DinoMatches.findOne match_id
  match_dinosaurs = match.players.map (player_id) ->
    match[player_id].dinosaur

  Dinosaurs.find
    _id:
      $in: match_dinosaurs

Meteor.publish 'userZoo', ->
  Dinosaurs.find owner: this.userId

Meteor.publish 'userMatches', ->
  DinoMatches.find players: this.userId
