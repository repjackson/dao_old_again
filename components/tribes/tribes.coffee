Router.route '/tribes', -> @render 'tribes'
Router.route '/tribe/:doc_id/view', -> @render 'tribe_view'
Router.route '/tribe/:doc_id/edit', -> @render 'tribe_edit'
Router.route '/tribe/:doc_id/dashboard', -> @render 'tribe_dashboard'

if Meteor.isClient
    Template.tribes.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'tribe_stats'
        @autorun => Meteor.subscribe 'docs', selected_tags.array(), 'tribe', 10

    Template.tribe_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.tribe_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id

    Template.tribes.helpers
        tribe_stats_doc: ->
            Docs.findOne
                model:'tribe_stats'
        my_tribes: ->
            Docs.find
                model:'tribe'

    Template.tribes.events
        'click .enter': ->
            Meteor.users.update Meteor.userId(),
                $set:
                    current_tribe_id:@_id
                    current_tribe_slug:@slug
            Router.go '/home'

        'click .calculate_tribe_stats': ->
            Meteor.call 'calculate_tribe_stats'

        'click .add_tribe': ->
            new_id = Docs.insert
                model:'tribe'
            Router.go "/tribe/#{new_id}/edit"



if Meteor.isServer
    Meteor.methods
        calculate_tribe_stats: ->
            tribe_stat_doc = Docs.findOne(model:'tribe_stats')
            unless tribe_stat_doc
                new_id = Docs.insert
                    model:'tribe_stats'
                tribe_stat_doc = Docs.findOne(model:'tribe_stats')
            console.log tribe_stat_doc
            total_count = Docs.find(model:'tribe').count()
            complete_count = Docs.find(model:'tribe', complete:true).count()
            incomplete_count = Docs.find(model:'tribe', complete:false).count()
            Docs.update tribe_stat_doc._id,
                $set:
                    total_count:total_count
                    complete_count:complete_count
                    incomplete_count:incomplete_count
