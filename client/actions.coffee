Template.view_profile.events
    'click .view_profile': ->
        console.log @
Template.enter_tribe.events
    'click .enter_tribe': ->
        Meteor.users.update Meteor.userId(),
            $set:
                current_tribe_id:@_id
                current_tribe_slug:@slug
        Router.go "/t/#{tribe_slug}/home"
        # location.reload()
