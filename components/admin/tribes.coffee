if Meteor.isClient
    Template.tribes.onCreated ->
        # @autorun => Meteor.subscribe 'role_models', Router.current().params.doc_id
        # @autorun => Meteor.subscribe 'model_docs', 'tribe'
        @autorun -> Meteor.subscribe('docs', selected_tags.array(), null, 'tribe')

        # @autorun => Meteor.subscribe 'model_fields_from_child_id', Router.current().params.doc_id
        Session.set 'tribe_filter',null

    Template.tribes.events
        'click .enter': ->
            if Meteor.user()
                Meteor.users.update Meteor.userId(),
                    $set:
                        current_tribe_id:@_id
                        current_tribe_slug:@slug
            Docs.update @_id,
                $inc: views: 1
            Router.go "/t/#{@slug}/dashboard"
            # if Meteor.isDevelopment
            #     Router.go "#{@slug}.dao2.com:3000"
                # window.location.replace("#{@slug}.localhost:3000");

        'click .calculate_tribe_stats': ->
            Meteor.call 'calculate_tribe_stats'

        'click .add_tribe': ->
            new_id = Docs.insert
                model:'tribe'
            Router.go "/tribe/#{new_id}/edit"

        'click .set_model': ->
            Session.set 'loading', true
            Meteor.call 'set_facets', @slug, ->
                Session.set 'loading', false

        'keyup .tribe_filter': (e,t)->
            tribe_filter = $('.tribe_filter').val()
            if e.which is 8
                if tribe_filter.length is 0
                    Session.set 'tribe_filter',null
                else
                    Session.set 'tribe_filter',tribe_filter
            else
                Session.set 'tribe_filter',tribe_filter
        'click .add_model': ->
            if Meteor.user() and Meteor.user().current_tribe_slug
                new_doc_id = Docs.insert
                    model:'model'
                    tribe_slug: Meteor.user().current_tribe_slug
                Router.go "/model/edit/#{new_doc_id}"

        'mouseenter .home_segment': (e,t)->
            t.$(e.currentTarget).closest('.home_segment').addClass('raised')
        'mouseleave .home_segment': (e,t)->
            t.$(e.currentTarget).closest('.home_segment').removeClass('raised')

    Template.tribes.helpers
        tribes: ->
            tribe_filter = Session.get('tribe_filter')
            if tribe_filter
                Docs.find {
                    model:'tribe'
                    # view_roles:$in:Meteor.user().roles
                    title: {$regex:"#{tribe_filter}", $options: 'i'}
                }, sort:title:1
            else
                Docs.find {
                    model:'tribe'
                    # view_roles:$in:Meteor.user().roles
                }, sort:title:1
