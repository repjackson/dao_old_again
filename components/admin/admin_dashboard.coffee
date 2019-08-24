if Meteor.isClient
    Router.route '/t/:tribe_slug/admin/dashboard', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_dashboard_nav', {to:'sub_sub_nav'}
        @render 'admin_dashboard'
        ), name:'admin_dashboard'

    Router.route '/t/:tribe_slug/admin/dashboard/summary', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_dashboard_nav', {to:'sub_sub_nav'}
        @render 'admin_dashboard_summary'
        ), name:'admin_dashboard_summary'

    Router.route '/t/:tribe_slug/admin/dashboard/account', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_dashboard_nav', {to:'sub_sub_nav'}
        @render 'admin_dashboard_account'
        ), name:'admin_dashboard_account'

    Router.route '/t/:tribe_slug/admin/dashboard/organization', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_dashboard_nav', {to:'sub_sub_nav'}
        @render 'admin_dashboard_organization'
        ), name:'admin_dashboard_organization'

    Router.route '/t/:tribe_slug/admin/dashboard/referrals', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_dashboard_nav', {to:'sub_sub_nav'}
        @render 'admin_dashboard_referrals'
        ), name:'admin_dashboard_referrals'

    Router.route '/t/:tribe_slug/admin/dashboard/getting_started', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_dashboard_nav', {to:'sub_sub_nav'}
        @render 'admin_dashboard_getting_started'
        ), name:'admin_dashboard_getting_started'

    Template.admin_dashboard.onCreated ->
        @autorun => Meteor.subscribe 'tribe_docs', Router.current().params.tribe_slug, 'donation'

    Template.admin_dashboard.events
        'click .add_donation': ->
            Docs.insert
                tribe_slug:Router.current().params.tribe_slug
                model:'donation'
        'click .set_donation': ->
            Session.set 'current_donation', @_id


    Template.admin_dashboard.helpers
        dashboard: ->
            Docs.find
                tribe_slug:Router.current().params.tribe_slug
                model:'donation'

        donation_menu_item_class: ->
            console.log @_id
            console.log Session.get('current_donation')
            if Session.equals(@_id, Session.get('current_donation'))
                console.log 'this is active'
                return 'active'
            else ''
