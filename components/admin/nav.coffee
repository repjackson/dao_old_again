if Meteor.isClient
    Template.nav.events
        'click #logout': ->
            Session.set 'logging_out', true
            Meteor.logout ->
                Session.set 'logging_out', false
                Router.go '/'

        'click .set_models': ->
            Session.set 'loading', true
            Meteor.call 'set_facets', 'model', ->
                Session.set 'loading', false

        'click .toggle_model_nav': ->
            Meteor.users.update Meteor.userId(),
                $set:view_model_bar:!Meteor.user().view_model_bar
        'click .set_tribes': ->
            Session.set 'loading', true
            Meteor.call 'set_facets', 'tribe', ->
                Session.set 'loading', false

        'click .set_model': ->
            Session.set 'loading', true
            Meteor.call 'set_facets', @slug, ->
                Session.set 'loading', false

    Template.nav.onRendered ->
        # @autorun =>
        #     if @subscriptionsReady()
        #         Meteor.setTimeout ->
        #             $('.dropdown').dropdown()
        #         , 3000

        Meteor.setTimeout ->
            $('.item').popup(
                preserve:true;
                hoverable:true;
            )
        , 3000



    # Template.mlayout.onCreated ->
    #     @autorun -> Meteor.subscribe 'me'
    Template.nav.onCreated ->
        @autorun -> Meteor.subscribe 'me'
        @autorun -> Meteor.subscribe 'current_tribe', Router.current().params.tribe_slug
        @autorun -> Meteor.subscribe 'tribe_role_models', Router.current().params.tribe_slug, Router.current().params.model_slug
        @autorun -> Meteor.subscribe 'tribe_pages'

        # @autorun -> Meteor.subscribe 'current_session'
        # @autorun -> Meteor.subscribe 'unread_messages'

    Template.nav.helpers
        # nav_color: ->
        #     {
        #         background: url(/image/signup-bg.png) center no-repeat;
        #         /*height: 100%;*/
        #         width: 100%;
        #         height: 100vh;
        #         background-repeat: no-repeat;
        #         background-position: center center;
        #         background-size: cover;
        #         background-attachment: fixed;
        #         position: relative;
        #     }

        nav_class: ->
            if Meteor.user() and Meteor.user().current_tribe_id
                current_tribe = Docs.findOne Meteor.user().current_tribe_id
                if current_tribe
                    "inverted #{current_tribe.nav_color}"

        notifications: ->
            Docs.find
                model:'notification'
        # current_tribe: ->
        #     if Meteor.user() and Meteor.user().current_tribe_id
        #         Docs.findOne
        #             model:'tribe'
        #             _id:Meteor.user().current_tribe_id

        tribe_role_models: ->
            match = {}
            match.model = 'model'
            if Meteor.user()
                if Meteor.user() and Meteor.user().current_tribe_slug
                    # tribe = Meteor.user().current_tribe_slug
                    match.tribe_slug = Meteor.user().current_tribe_slug
                unless 'dev' in Meteor.user().roles
                    match.view_roles = $in:Meteor.user().roles
                # console.log match
                Docs.find match,
                    {sort:title:1}
        models: ->
            Docs.find
                model:'model'

        tribe_pages: ->
            Docs.find
                model:'page'

        unread_count: ->
            unread_count = Docs.find({
                model:'message'
                to_username:Meteor.user().username
                read_by_ids:$nin:[Meteor.userId()]
            }).count()

        cart_amount: ->
            cart_amount = Docs.find({
                model:'cart_item'
                _author_id:Meteor.userId()
            }).count()

        mail_icon_class: ->
            unread_count = Docs.find({
                model:'message'
                to_username:Meteor.user().username
                read_by_ids:$nin:[Meteor.userId()]
            }).count()
            if unread_count then 'red' else ''


        bookmarked_models: ->
            if Meteor.userId()
                Docs.find
                    model:'model'
                    bookmark_ids:$in:[Meteor.userId()]


if Meteor.isServer
    Meteor.publish 'my_notifications', ->
        Docs.find
            model:'notification'
            user_id: Meteor.userId()

    Meteor.publish 'bookmarked_models', ->
        if Meteor.userId()
            Docs.find
                model:'model'
                bookmark_ids:$in:[Meteor.userId()]

    Meteor.publish 'current_tribe', ->
        if Meteor.userId()
            if Meteor.user().current_tribe_id
                Docs.find
                    _id: Meteor.user().current_tribe_id

    Meteor.publish 'tribe_pages', ->
        if Meteor.userId()
            if Meteor.user().current_tribe_slug
                Docs.find
                    model:'page'
                    tribe_slug:Meteor.user().current_tribe_slug

    Meteor.publish 'tribe_role_models', (tribe_slug, model_slug)->
        Docs.find
            model:'model'
            tribe_slug: tribe_slug
            slug:model_slug


    Meteor.publish 'my_cart', ->
        if Meteor.userId()
            Docs.find
                model:'cart_item'
                _author_id:Meteor.userId()

    Meteor.publish 'unread_messages', (username)->
        if Meteor.userId()
            Docs.find {
                model:'message'
                to_username:username
                read_ids:$nin:[Meteor.userId()]
            }, sort:_timestamp:-1
