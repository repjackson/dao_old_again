# Router.route '/tasks', -> @render 'tasks'
Router.route '/t/:tribe_slug/events/', -> @render 'events'
Router.route '/t/:tribe_slug/event/:doc_id/view', -> @render 'event_view'
Router.route '/t/:tribe_slug/event/:doc_id/edit', -> @render 'event_edit'


if Meteor.isClient
    Template.events.onCreated ->
        @autorun => Meteor.subscribe 'tribe_by_slug', Router.current().params.tribe_slug

        # @autorun => Meteor.subscribe 'tribe_docs', Router.current().params.tribe_slug, 'event'
        @autorun => Meteor.subscribe 'docs', selected_tags.array(), Router.current().params.tribe_slug, 'event'

    Template.event_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.event_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.events.helpers
        events: ->
            Docs.find
                model:'event'
    Template.events.events
        'click .add_event': ->
            tribe_slug = Router.current().params.tribe_slug
            new_id = Docs.insert
                model:'event'
                tribe_slug:tribe_slug
            Router.go "/event/#{new_id}/edit"
