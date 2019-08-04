@selected_tags = new ReactiveArray []

Template.array_edit.events
    'keyup .new_element': (e,t)->
        if e.which is 13
            element_val = t.$('.new_element').val().trim().toLowerCase()
            # console.log @
            # console.log element_val
            parent = Template.parentData(5)

            doc = Docs.findOne parent._id
            Docs.update parent._id,
                $addToSet:"#{@valueOf()}":element_val
            t.$('.new_element').val('')

    'click .remove_element': (e,t)->
        element = @valueOf()
        field = Template.currentData()
        # console.log Template.parentData(1)
        # console.log Template.parentData(2)
        # console.log Template.parentData(3)
        # console.log Template.parentData(4)
        # console.log Template.parentData(5)
        # console.log Template.parentData(6)
        # console.log field
        # console.log element
        parent = Template.parentData(5)

        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $pull:"#{field}":element
        #
        t.$('.new_element').focus()
        t.$('.new_element').val(element)



    'keyup #quick_add': (e,t)->
        e.preventDefault
        tag = $('#quick_add').val().toLowerCase()
        if e.which is 13
            if tag.length > 0
                split_tags = tag.match(/\S+/g)
                $('#quick_add').val('')
                parent = Template.parentData(5)
                doc = Docs.findOne parent._id
                Docs.update parent._id,
                    $addToSet:tags:$each:split_tags


Template.textarea_edit.events
    # 'click .toggle_edit': (e,t)->
    #     t.editing.set !t.editing.get()

    'blur .edit_textarea': (e,t)->
        textarea_val = t.$('.edit_textarea').val()
        parent = Template.parentData(5)

        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":textarea_val


Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)

Template.registerHelper 'current_doc', ->
    doc = Docs.findOne Router.current().params.doc_id

Template.registerHelper 'field_value', () ->
    # console.log @valueOf()
    parent = Template.parentData()
    # console.log Template.parentData(1)
    # console.log Template.parentData(2)
    # console.log Template.parentData(3)
    # console.log Template.parentData(4)
    # console.log Template.parentData(5)
    # console.log Template.parentData(6)
    # parent5 = Template.parentData(5)
    # # parent6 = Template.parentData(6)
    #
    # console.log parent
    # console.log parent5
    # console.log parent6


    # parent = Template.parentData(5)
    if @direct
        parent = Template.parentData()
    else if parent5._id
        parent = Template.parentData(5)
    # else if parent6._id
    #     parent = Template.parentData(6)
    if @direct
        parent["#{@key}"]
    else if parent
        parent["#{@valueOf()}"]


Template.registerHelper 'calculated_size', (metric) ->
    # console.log metric
    # console.log typeof parseFloat(@relevance)
    # console.log typeof (@relevance*100).toFixed()
    whole = parseInt(@["#{metric}"]*10)
    # console.log whole

    if whole is 2 then 'f2'
    else if whole is 3 then 'f3'
    else if whole is 4 then 'f4'
    else if whole is 5 then 'f5'
    else if whole is 6 then 'f6'
    else if whole is 7 then 'f7'
    else if whole is 8 then 'f8'
    else if whole is 9 then 'f9'
    else if whole is 10 then 'f10'



Template.registerHelper 'in_dev', () -> Meteor.isDevelopment
Template.cloud.onCreated ->
    @autorun -> Meteor.subscribe('tags', selected_tags.array())
    # @autorun -> Meteor.subscribe('docs', selected_tags.array())


Template.cloud.helpers
    all_tags: ->
        doc_count = Docs.find({}).count()
        if 0 < doc_count < 3 then Tags.find { count: $lt: doc_count } else Tags.find({}, limit:100)

    cloud_tag_class: ->
        button_class = switch
            when @index <= 5 then 'large'
            when @index <= 12 then ''
            when @index <= 20 then 'small'
        return button_class

    selected_tags: -> selected_tags.array()

    settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Tags
                field: 'name'
                matchAll: true
                template: Template.tag_result
            }
            ]
    }

Template.cloud.events
    'click .select_tag': -> selected_tags.push @name
    'click .unselect_tag': -> selected_tags.remove @valueOf()
    'click #clear_tags': -> selected_tags.clear()
    'click .add_doc': ->
        new_doc_id = Docs.insert {
            "fields": [
                "textarea",
                "array"
            ],
            "_keys": [
                "new_html",
                "tags"
            ],
            "_new_html": {
                "field": "textarea"
            },
            "_tags": {
                "field": "array"
            }
        }
        Router.go "/edit/#{new_doc_id}"


    'keyup .import_subreddit': (e,t)->
        val = $('.import_subreddit').val().toLowerCase().trim()
        if e.which is 13
            alert val
            Meteor.call 'pull_subreddit', val
    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_tags.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_tags.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_tags.pop()

    'autocompleteselect #search': (event, template, doc) ->
        selected_tags.push doc.name
        $('#search').val ''



Template.edit.onCreated ->
    @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id

Template.edit.events
    'click #delete_doc': ->
        if confirm 'delete?'
            Docs.remove Router.current().params.doc_id
            Router.go "/"
    'keyup .new_site':(e,t)->
        if e.which is 13
            doc_id = Router.current().params.doc_id
            site = t.$('.new_site').val()
            # console.log site
            Meteor.call 'pull_site', doc_id, site,->
            # t.$('.add_comment').val('')



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



Template.view.onCreated ->
    @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id

Template.view.helpers
    sorted_matches: ->
        # console.log @
        sorted_matches = _.sortBy @matches, 'tag_match_count'
        sorted_matches.reverse()[..2]

Template.view.events
    'click .calculate': ->
        Meteor.call 'related_posts', Router.current().params.doc_id

# Template.related_posts.helpers
#     related_posts: ->
#         post = DocsfindOne @_id
#         if post.related_ids
#             Docs.find
#                 _id:$in:post.related_ids

Template.doc_match.onCreated ->
    # console.log @
    @autorun => Meteor.subscribe 'doc', @data.doc_id

Template.doc_match.events
    'click .doc_match': ->
        console.log @
        Router.go "/view/#{@doc_id}"


Template.doc_match.helpers
    matching_doc: ->
        # console.log @
        Docs.findOne @doc_id

    matching_tag_class: ->
        post = Docs.findOne Router.current().params.doc_id
        if @valueOf() in post.tags then 'grey' else 'basic'
        # console.log @
