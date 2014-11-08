Meteor.methods
  createDinosaur: (name) ->
    now = +new Date()
    Dinosaurs.insert
      created: now
      updated: now
      name: name
      owner: @userId

  lookForGame: (dinosaur_id) ->
    now = +new Date()
    modifier =
      $push:
        players: @userId
      $set:
        updated: now
    modifier.$set[@userId +'.timestamp'] = now
    modifier.$set[@userId +'.dinosaur'] = dinosaur_id

    success = DinoMatches.update
      players:
        $size: 1
      expired:
        $ne: true
    , modifier

    if success
      query = {}
      query[@userId + '.timestamp'] = now
      DinoMatches.findOne query
    else
      doc =
        created: now
        update: now
        players: [@userId]
      doc[@userId] =
        timestamp: now
        dinosaur: dinosaur_id
      DinoMatches.insert doc
