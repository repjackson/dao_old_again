if Meteor.isClient
    Template.edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
        @autorun -> Meteor.subscribe 'model_docs', 'field_type'

        # @autorun => Meteor.subscribe 'model_from_child_id', Router.current().params.doc_id
        # @autorun => Meteor.subscribe 'model_fields_from_child_id', Router.current().params.doc_id

    Template.edit.events
        'click #delete_doc': ->
            if confirm 'delete?'
                Docs.remove Router.current().params.doc_id
                Router.go "/"
    Template.edit.helpers
        current_doc: ->
            Docs.findOne Router.current().params.doc_id

        fields: ->
            Docs.find
                model:'field_type'

    Template.field_menu.helpers
        fields: ->
            Docs.find
                model:'field_type'

    Template.field_menu.events
        'click .add_field': ->
            console.log @
            Docs.update Router.current().params.doc_id,
                $push:
                    fields: @slug
                    _keys: "new_#{@slug}"
                $set:
                    "_new_#{@slug}": { field:@slug }

    Template.field_edit.events
        'blur .change_key': (e,t)->
            old_string = @valueOf()
            # console.log old_string
            new_key = t.$('.change_key').val()
            parent = Template.parentData()
            current_keys = Template.parentData()._keys

            Meteor.call 'rename_key', old_string, new_key, parent


        'click .remove_field': (e,t)->
            key_name = @valueOf()
            console.log @
            console.log Template.currentData()
            parent = Template.parentData()
            field = parent["_#{key_name}"].field
            if confirm "Remove #{key_name}?"
                $(e.currentTarget).closest('.segment').transition('fly right')
                Meteor.setTimeout =>
                    Docs.update parent._id,
                        $unset:
                            "#{key_name}": 1
                            "_#{key_name}": 1
                        $pull:
                            _keys: key_name
                            fields:field
                , 1000


    Template.field_edit.helpers
        key: -> @valueOf()

        meta: ->
            key_string = @valueOf()
            parent = Template.parentData()
            parent["_#{key_string}"]

        context: ->
            # console.log @
            {key:@valueOf()}


        field_edit: ->
            # console.log @
            # console.log Template.parentData(2)
            # console.log Template.parentData(3)
            meta = Template.parentData(2)["_#{@key}"]
            # console.log meta
            # console.log "#{meta.field}_edit"
            "#{meta.field}_edit"





if Meteor.isServer
    Meteor.publish 'model_from_child_id', (child_id)->
        child = Docs.findOne child_id
        Docs.find
            model:'model'
            slug:child.type


    Meteor.publish 'model_fields_from_child_id', (child_id)->
        child = Docs.findOne child_id
        model = Docs.findOne
            model:'model'
            slug:child.type
        Docs.find
            model:'field'
            parent_id:model._id
