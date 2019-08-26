Router.route '/tribes', -> @render 'tribes'
Router.route '/tribe/:doc_id/view', -> @render 'tribe_view'

Router.route '/t/:tribe_slug/edit', (->
    @layout 'tribe_edit_layout'
    @render 'tribe_edit_nav', {to:'sub_nav'}
    @render 'te_dashboard_nav', {to:'sub_sub_nav'}
    @render 'tribe_edit'
    ), name:'tribe_edit2'


Router.route '/tribe/:doc_id/edit', (->
    @layout 'tribe_edit_layout'
    @render 'tribe_edit_nav', {to:'sub_nav'}
    @render 'te_dashboard_nav', {to:'sub_sub_nav'}
    @render 'tribe_edit'
    ), name:'tribe_edit'


Router.route '/t/:tribe_slug/blog', (->
    @layout 'layout'
    @render 'blog'
    ), name:'blog'

Router.route '/t/:tribe_slug/events', (->
    @layout 'layout'
    @render 'events'
    ), name:'events'

Router.route '/t/:tribe_slug/mail', (->
    @layout 'layout'
    @render 'mail'
    ), name:'mail'

Router.route '/t/:tribe_slug/tasks', (->
    @layout 'layout'
    @render 'tasks'
    ), name:'tasks'

Router.route '/t/:tribe_slug/chat', (->
    @layout 'layout'
    @render 'chat'
    ), name:'chat'

Router.route '/t/:tribe_slug/shop', (->
    @layout 'layout'
    @render 'shop'
    ), name:'shop'

Router.route '/t/:tribe_slug/gallery', (->
    @layout 'layout'
    @render 'gallery'
    ), name:'gallery'



if Meteor.isClient
    Template.tribes.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'tribe_stats'
        @autorun => Meteor.subscribe 'docs', selected_tags.array(), 'tribe', 10

    Template.tribe_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.tribe_edit.onCreated ->
        @autorun => Meteor.subscribe 'tribe_by_slug', Router.current().params.tribe_slug
    Template.admin_dashboard.onCreated ->
        @autorun => Meteor.subscribe 'tribe_by_slug', Router.current().params.tribe_slug

    Template.tribes.helpers
        tribe_stats_doc: ->
            Docs.findOne
                model:'tribe_stats'
        my_tribes: ->
            Docs.find
                model:'tribe'



if Meteor.isServer
    Meteor.publish 'tribe_by_slug', (tribe_slug)->
        Docs.find
            model:'tribe'
            slug:tribe_slug
