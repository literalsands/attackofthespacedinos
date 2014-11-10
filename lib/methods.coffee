Meteor.methods
  createDinosaur: (name) ->
    now = +new Date()
    Dinosaurs.insert
      created: now
      updated: now
      name: name
      owner: @userId

  lookForArenaMatch: (dinosaur_id) ->
    alreadyLooking = DinoMatches.findOne $and: [
      players: $size: 1
    ,
      players: @userId
    ]

    if not _.isObject alreadyLooking
      now = +new Date()
      modifier =
        $push:
          players: @userId
        $set:
          updated: now
      modifier.$set[@userId+'.timestamp'] = now
      modifier.$set[@userId+'.dinosaur'] = dinosaur_id

      success = DinoMatches.update
        $and: [
          players:
            $size: 1
        ,
          players:
            $ne: @userId
        ]
        expired:
          $ne: true
      , modifier

      if success
        query = {}
        query[@userId+'.timestamp'] = now
        DinoMatches.findOne query
      else
        doc =
          created: now
          updated: now
          players: [@userId]
        doc[@userId] =
          timestamp: now
          dinosaur: dinosaur_id
        DinoMatches.insert doc

  winArenaMatch: (match_id) ->
    DinoMatches.update
      _id: match_id
      players: @userId
    ,
      $set:
        expired: true
        winner: @userId

