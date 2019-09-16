if Meteor.isClient
    Template.model_view.onCreated ->
        # @autorun -> Meteor.subscribe 'model', Router.current().params.tribe_slug, Router.current().params.model_slug
        @autorun -> Meteor.subscribe 'model', Router.current().params.model_slug
        # @autorun -> Meteor.subscribe 'model_fields', Router.current().params.model_slug
        @autorun -> Meteor.subscribe 'docs', selected_tags.array(), Router.current().params.model_slug

    Template.model_view.helpers
        model: ->
            Docs.findOne
                model:'model'
                slug: Router.current().params.model_slug

        model_docs: ->
            model = Docs.findOne
                model:'model'
                slug: Router.current().params.model_slug

            Docs.find
                model:model.slug

        model_doc: ->
            model = Docs.findOne
                model:'model'
                slug: Router.current().params.model_slug
            "#{model.slug}_view"

        fields: ->
            Docs.find { model:'field' }, sort:rank:1
                # parent_id: Router.current().params.doc_id

    Template.model_view.events
        'click .add_child': ->
            model = Docs.findOne slug:Router.current().params.model_slug
            console.log model
            # new_id = Docs.insert
            #     model: Router.current().params.model_slug
            # Router.go "/edit/#{new_id}"

    Template.model_edit.onCreated ->
        @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id
        @autorun -> Meteor.subscribe 'child_docs', Router.current().params.doc_id


    Template.model_edit.helpers
        model: ->
            doc_id = Router.current().params.doc_id
            # console.log doc_id
            Docs.findOne doc_id

        fields: ->
            Docs.find {
                model:'field'
                parent_id: Router.current().params.doc_id
            }, sort:rank:1

    Template.model_edit.events
        'click #delete_model': (e,t)->
            if confirm 'delete model?'
                Docs.remove Router.current().params.doc_id, ->
                    Router.go "/"

        'click .add_field': ->
            Docs.insert
                model:'field'
                parent_id: Router.current().params.doc_id

if Meteor.isServer
    Meteor.publish 'model', (tribe_slug, slug)->
        Docs.find
            model:'model'
            slug:slug
            # tribe_slug:tribe_slugs

    # Meteor.publish 'model_fields', (tribe_slug, model_slug)->
    Meteor.publish 'model_fields', (model_slug)->
        console.log 'looking for model fields', tribe_slug, model_slug
        if model_slug is 'model'
            model = Docs.findOne
                model:'model'
                slug:'model'
        else
            model = Docs.findOne
                model:'model'
                # tribe_slug:tribe_slug
                slug:model_slug
        console.log model
        Docs.find
            model:'field'
            parent_id:model._id
