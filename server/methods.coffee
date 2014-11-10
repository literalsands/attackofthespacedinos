Meteor.methods
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
      Actions[choice].time * 2500 + now

    changes = DinoMatches.update selector, modifier

    # Attack has occurred.
    if changes > 0 and (choice is 0 or choice is 1)

      match = DinoMatches.findOne match_id
      modifier = $push: actions: {}

      # Action does occur.
      firstRoll = Random.fraction()
      if firstRoll <= Actions[choice].success

        opponent = match.players[(match.players.indexOf(@userId) + 1) % 2]
        opponentActionChoice = match[opponent].action

        # Add attack to action.
        modifier.$push.actions[match[@userId].dinosaur] =
          attack: Actions[choice].attack
          armor: Actions[choice].defense

        # Opponent has a defend in play.
        if now < match[opponent]['action-lock'] and
            (opponentActionChoice is 2 or opponentActionChoice is 3)

          opponentAction = Actions[opponentActionChoice]
          secondRoll = Random.fraction()

          # Opponent's defend is successful
          if secondRoll <= opponentAction.success
            modifier.$push.actions[match[opponent].dinosaur] =
              block: opponentAction.defense
              counter: opponentAction.attack

          # Add fumble to opponent.
          else
            modifier.$push.actions[match[opponent].dinosaur] =
              fumble: true

      # Add miss to action.
      else
        modifier.$push.actions[match[@userId].dinosaur] = miss: true

      # Update the match state.
      # This should probably be a separate db doc that gets purged later.
      DinoMatches.update match_id, modifier
