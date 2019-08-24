# Router.route '/tasks', -> @render 'tasks'
Router.route '/t/:tribe_slug/dashboard', (->
    @layout 'layout'
    @render 'tribe_dashboard'
    ), name:'tribe_dashboard'


if Meteor.isClient
    Template.tribe_dashboard.onCreated ->
        @autorun => Meteor.subscribe 'tribe_by_slug', Router.current().params.tribe_slug
        @autorun => Meteor.subscribe 'docs', selected_tags.array(), Router.current().params.tribe_slug, 'event'

    Template.event_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.event_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.tribe_dashboard.helpers
        events: ->
            Docs.find
                model:'event'
    Template.tribe_dashboard.events
        'click .add_event': ->
            tribe_slug = Router.current().params.tribe_slug
            new_id = Docs.insert
                model:'event'
                tribe_slug:tribe_slug
            Router.go "/t/#{tribe_slug}/event/#{new_id}/edit"
