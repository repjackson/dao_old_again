if Meteor.isClient
    Template.page.onCreated ->
        @autorun => Meteor.subscribe 'page', Router.current().params.slug
        @autorun => Meteor.subscribe 'page_blocks', Router.current().params.slug


    Template.page.helpers
        page: ->
            Docs.findOne
                model:'page'
                slug:Router.current().params.slug

        # page_style: ->
        #     console.log @
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


    Template.add.onCreated ->
        @autorun => Meteor.subscribe 'model', 'model'

    Template.add.helpers
        add_models: ->
            if Meteor.user()
                Docs.find {
                    model:'model'
                    add_roles:$in:Meteor.user().roles
                }, sort:title:1

    Template.menu.onCreated ->
        @autorun => Meteor.subscribe 'model', 'model'

    Template.menu.helpers
        view_models: ->
            if Meteor.user()
                if 'dev' in Meteor.user().roles
                    Docs.find {
                        model:'model'
                    }, sort:title:1
                else
                    Docs.find {
                        model:'model'
                        view_roles:$in:Meteor.user().roles
                    }, sort:title:1

    Template.menu.events
        'click .set_tribe_model': ->
            Session.set 'loading', true
            Meteor.call 'set_delta_facets', @slug,->
                Session.set 'loading', false



    Template.add.events
        'click .add_doc': ->
            # console.log @
            new_id =
                Docs.insert
                    model:@slug

            Router.go "/m/#{@slug}/#{new_id}/edit"

        'click .add_model': ->
            # console.log @
            new_id =
                Docs.insert
                    model:'model'

            Router.go "/m/model/#{new_id}/edit"

        'click .add_page': ->
            # console.log @
            new_id =
                Docs.insert
                    model:'page'

            Router.go "/m/page/#{new_id}/edit"
