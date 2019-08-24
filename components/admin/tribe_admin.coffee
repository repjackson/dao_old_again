if Meteor.isClient
    Router.route '/t/:tribe_slug/admin/contacts', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_dashboard_nav', {to:'sub_sub_nav'}
        @render 'admin_contacts'
        ), name:'admin_contacts'

    Router.route '/t/:tribe_slug/admin/dashboard', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_dashboard_nav', {to:'sub_sub_nav'}
        @render 'admin_dashboard'
        ), name:'admin_dashboard'


    Template.admin_contacts.onCreated ->
        @autorun => Meteor.subscribe 'tribe_contacts', 'stat'

    Template.admin_contacts.helpers
        stats_doc: ->
            Docs.findOne
                model:'stat'


if Meteor.isServer
    Meteor.publish 'tribe_contacts', (tribe_slug)->
        tribe = Docs.findOne
            model:'tribe'
            slug:tribe_slug
        Meteor.users.find
            _id: $in: tribe.member_id
