if Meteor.isClient
    Router.route '/t/:tribe_slug/admin/events', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_events_nav', {to:'sub_sub_nav'}
        @render 'admin_events'
        ), name:'admin_events'

    Template.admin_events.onCreated ->
        @autorun => Meteor.subscribe 'tribe_docs', Router.current().params.tribe_slug, 'page'
    Template.tribe_page_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Session.get('current_page')

    Template.admin_events.events
        'click .add_page': ->
            Docs.insert
                tribe_slug:Router.current().params.tribe_slug
                model:'page'
        'click .set_page': ->
            Session.set 'current_page', @_id


    Template.admin_events.helpers
        pages: ->
            Docs.find
                tribe_slug:Router.current().params.tribe_slug
                model:'page'

        page_menu_item_class: ->
            console.log @_id
            console.log Session.get('current_page')
            if Session.equals(@_id, Session.get('current_page'))
                console.log 'this is active'
                return 'active'
            else ''
