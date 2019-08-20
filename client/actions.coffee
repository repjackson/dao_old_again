Template.view_profile.events
    'click .view_profile': ->
        console.log @
Template.enter_tribe.events
    'click .enter_tribe': ->
        console.log @
        Meteor.users.update Meteor.userId(),
            $set:
                current_tribe_id:@_id
                current_tribe_slug:@slug
