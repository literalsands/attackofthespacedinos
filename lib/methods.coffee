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

  performAction: (choice, match_id) ->
    now = +new Date()
    selector = _id: match_id
    selector.$or = []
    selector.$or[0] = {}
    selector.$or[0][@userId+'.action-lock'] = $lt: now
    selector.$or[1] = {}
    selector.$or[1][@userId+'.action-lock'] = $exists: false

    modifier = $set: {}
    modifier.$set[@userId+'.action'] = choice
    modifier.$set[@userId+'.action-lock'] =
      Actions[choice].time * 1000 + now
    changes = DinoMatches.update selector, modifier

    if changes > 0 and (choice is 0 or choice is 1)
      firstRoll = Random.fraction()
      match = DinoMatches.findOne match_id
      modifier = $push: actions: {}
      if firstRoll <= Actions[choice].success
        opponent = (match.players.indexOf(@userId) + 1) % 2
        console.log now, match[match.players[opponent]]['action-lock']
        if now < match[match.players[opponent]]['action-lock']
          opponentAction = Actions[match[match.players[opponent]].action]
          secondRoll = Random.fraction()
          if secondRoll <= opponentAction.success
            console.log "Block"
            modifier.$push.actions[match[match.players[opponent]].dinosaur] =
              block: opponentAction.defense
              counter: opponentAction.attack
          else
            console.log "Block Miss"
            modifier.$push.actions[match[match.players[opponent]].dinosaur] =
              miss: true
        console.log "Attack"
        modifier.$push.actions[match[@userId].dinosaur] =
          attack: Actions[choice].attack
          armor: Actions[choice].defense
      else
        console.log "Attack Miss"
        modifier.$push.actions[match[@userId].dinosaur] = miss: true
      DinoMatches.update match_id, modifier

    #match = DinoMatches.findOne match_id
    #actions = _.compact _.pluck match, 'action'

    #resolution = match.resolveAction()
    #DinoMatches.update
      #_id: match_id
    #,
      #$set: resolution
