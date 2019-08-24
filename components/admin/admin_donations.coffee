if Meteor.isClient
    Router.route '/t/:tribe_slug/admin/donations', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_donations_nav', {to:'sub_sub_nav'}
        @render 'admin_donations'
        ), name:'admin_donations'

    Router.route '/t/:tribe_slug/admin/donations/donors', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_donations_nav', {to:'sub_sub_nav'}
        @render 'admin_donations_donors'
        ), name:'admin_donations_donors'

    Router.route '/t/:tribe_slug/admin/donations/donation_settings', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_donations_nav', {to:'sub_sub_nav'}
        @render 'admin_donations_donation_settings'
        ), name:'admin_donations_donation_settings'

    Router.route '/t/:tribe_slug/admin/donations/donation_receipt', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_donations_nav', {to:'sub_sub_nav'}
        @render 'admin_donations_donation_receipt'
        ), name:'admin_donations_donation_receipt'

    Router.route '/t/:tribe_slug/admin/donations/confirmation_email', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_donations_nav', {to:'sub_sub_nav'}
        @render 'admin_donations_confirmation_email'
        ), name:'admin_donations_confirmation_email'

    Template.admin_donations.onCreated ->
        @autorun => Meteor.subscribe 'tribe_docs', Router.current().params.tribe_slug, 'donation'

    Template.admin_donations.events
        'click .add_donation': ->
            Docs.insert
                tribe_slug:Router.current().params.tribe_slug
                model:'donation'
        'click .set_donation': ->
            Session.set 'current_donation', @_id


    Template.admin_donations.helpers
        donations: ->
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
