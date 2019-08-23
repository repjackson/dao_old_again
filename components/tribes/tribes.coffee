Router.route '/tribes', -> @render 'tribes'
Router.route '/tribe/:doc_id/view', -> @render 'tribe_view'

Router.route '/tribe/:doc_id/edit', (->
    @layout 'tribe_edit_layout'
    @render 'tribe_edit_nav', {to:'sub_nav'}
    @render 't_e_dashboard_nav', {to:'sub_sub_nav'}
    @render 'tribe_edit'
    ), name:'tribe_edit'

Router.route '/t/:tribe_slug/edit', (->
    @layout 'tribe_edit_layout'
    @render 'tribe_edit_nav', {to:'sub_nav'}
    @render 't_e_dashboard_nav', {to:'sub_sub_nav'}
    @render 'tribe_edit'
    ), name:'tribe_edit2'


Router.route '/t/:tribe_slug/dashboard', (->
    @layout 'layout'
    @render 'tribe_dashboard'
    ), name:'tribe_dashboard'

Router.route '/t/:tribe_slug/blog', (->
    @layout 'layout'
    @render 'tribe_blog'
    ), name:'tribe_blog'

Router.route '/t/:tribe_slug/events', (->
    @layout 'layout'
    @render 'tribe_events'
    ), name:'tribe_events'

Router.route '/t/:tribe_slug/mail', (->
    @layout 'layout'
    @render 'tribe_mail'
    ), name:'tribe_mail'

Router.route '/t/:tribe_slug/tasks', (->
    @layout 'layout'
    @render 'tribe_tasks'
    ), name:'tribe_tasks'

Router.route '/t/:tribe_slug/chat', (->
    @layout 'layout'
    @render 'tribe_chat'
    ), name:'tribe_chat'

Router.route '/t/:tribe_slug/gallery', (->
    @layout 'layout'
    @render 'tribe_gallery'
    ), name:'tribe_gallery'



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
