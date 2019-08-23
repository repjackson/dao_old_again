if Meteor.isClient
    Template.home.onCreated ->
        # @autorun => Meteor.subscribe 'role_models', Router.current().params.doc_id
        @autorun => Meteor.subscribe 'tribe_role_models', Router.current().params.tribe_slug, Router.current().params.doc_id
        # @autorun => Meteor.subscribe 'model_docs', 'marketplace'
        # @autorun => Meteor.subscribe 'model_docs', 'post'
        # @autorun => Meteor.subscribe 'model_fields_from_child_id', Router.current().params.doc_id
        Session.set 'model_filter',null

    Template.home.events
        'click .set_model': ->
            Session.set 'loading', true
            Meteor.call 'set_facets', @slug, ->
                Session.set 'loading', false

        'keyup .model_filter': (e,t)->
            model_filter = $('.model_filter').val()
            if e.which is 8
                if model_filter.length is 0
                    Session.set 'model_filter',null
                else
                    Session.set 'model_filter',model_filter
            else
                Session.set 'model_filter',model_filter
        'click .add_model': ->
            if Meteor.user() and Meteor.user().current_tribe_slug
                new_doc_id = Docs.insert
                    model:'model'
                    tribe_slug: Meteor.user().current_tribe_slug
                Router.go "/model/edit/#{new_doc_id}"

        'mouseenter .home_segment': (e,t)->
            t.$(e.currentTarget).closest('.home_segment').addClass('raised')
        'mouseleave .home_segment': (e,t)->
            t.$(e.currentTarget).closest('.home_segment').removeClass('raised')

    Template.home.helpers
        tribe_role_models: ->
            if Meteor.user()
                tribe_slug = Router.current().params.current_tribe_slug
                model_filter = Session.get('model_filter')
                if 'dev' in Meteor.user().roles
                    if model_filter
                        Docs.find {
                            model:'model'
                            tribe_slug:tribe_slug
                            title: {$regex:"#{model_filter}", $options: 'i'}
                        }, sort:title:1
                    else
                        Docs.find {
                            tribe_slug:tribe_slug
                            model:'model'
                        }, sort:title:1
                else
                    if model_filter
                        Docs.find {
                            title: {$regex:"#{model_filter}", $options: 'i'}
                            model:'model'
                            view_roles:$in:Meteor.user().roles
                        }, sort:title:1
                    else
                        Docs.find {
                            model:'model'
                            view_roles:$in:Meteor.user().roles
                        }, sort:title:1


if Meteor.isServer
    Meteor.publish 'role_models', ()->
        if Meteor.user()
            current_tribe_id = Meteor.user().current_tribe_id
        else
            dao_tribe = Docs.findOne
                model:'tribe'
                slug:'dao'
            current_tribe_id = dao_tribe._id
        if 'dev' in Meteor.user().roles
            Docs.find
                model:'model'
                tribe_id:current_tribe_id
        else
            Docs.find
                model:'model'
                tribe_id:current_tribe_id
                view_roles:$in:Meteor.user().roles
