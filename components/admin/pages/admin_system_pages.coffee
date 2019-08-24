if Meteor.isClient
    Template.admin_website_system_pages.onCreated ->
        @autorun => Meteor.subscribe 'tribe_docs', Router.current().params.tribe_slug, 'page'
    Template.tribe_page_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Session.get('current_page')

    Template.admin_website_system_pages.events
        'click .add_page': ->
            Docs.insert
                tribe_slug:Router.current().params.tribe_slug
                model:'page'
        'click .set_page': ->
            Session.set 'current_page', @_id


    Template.admin_website_system_pages.helpers
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



    Template.tribe_page_view.helpers
        current_page: -> Docs.findOne Session.get('current_page')
        viewing: -> Session.equals 'view_mode', 'view'
        editing: -> Session.equals 'view_mode', 'edit'
        configuring: -> Session.equals 'view_mode', 'configure'
        view_mode_class: -> if Session.equals('view_mode', 'view') then 'active blue' else ''
        edit_mode_class: -> if Session.equals('view_mode', 'edit') then 'active blue' else ''
        configure_mode_class: -> if Session.equals('view_mode', 'configure') then 'active blue' else ''

    Template.tribe_page_view.events
        'click .set_view_mode': ->
            Session.set 'view_mode', 'view'
        'click .set_edit_page': ->
            Session.set 'view_mode', 'edit'
        'click .set_configure_page': ->
            Session.set 'view_mode', 'configure'



if Meteor.isServer
    Meteor.publish 'tribe_docs', (tribe_slug, model)->
        Docs.find
            tribe_slug:tribe_slug
            model:model
