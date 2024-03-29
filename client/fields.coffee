Template.color_edit.events
    'blur .edit_color': (e,t)->
        val = t.$('.edit_color').val()
        parent = Template.parentData(5)
        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":val

Template.clear_value.events
    'click .clear_value': ->
        if confirm "Clear #{@title} field?"
            if @direct
                parent = Template.parentData()
            else
                parent = Template.parentData(5)
            doc = Docs.findOne parent._id
            user = Meteor.users.findOne parent._id
            Docs.update parent._id,
                $unset:"#{@valueOf()}":1


Template.link_edit.events
    'blur .edit_url': (e,t)->
        val = t.$('.edit_url').val()
        parent = Template.parentData(5)
        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":val


Template.color_icon_edit.events
    'blur .color_icon': (e,t)->
        icon_class = t.$('.color_icon').val()
        parent = Template.parentData(5)
        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":icon_class


Template.icon_edit.events
    'blur .icon_val': (e,t)->
        val = t.$('.icon_val').val()
        parent = Template.parentData(5)
        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":val



Template.html_edit.events
    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        parent = Template.parentData(5)
        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":html


Template.html_edit.helpers
    getFEContext: ->
        parent = Template.parentData(5)
        # @current_doc = Docs.findOne Router.current().params.doc_id
        # @current_doc = Docs.findOne @_id
        self = @
        {
            _value: parent["#{@valueOf()}"]
            _keepMarkers: true
            _className: 'froala-reactive-meteorized-override'
            toolbarInline: false
            initOnClick: false
            toolbarButtons:
                [
                  'fullscreen'
                  'bold'
                  'italic'
                  'underline'
                  'strikeThrough'
                #   'subscript'
                #   'superscript'
                  '|'
                #   'fontFamily'
                  'fontSize'
                  'color'
                #   'inlineStyle'
                #   'paragraphStyle'
                  '|'
                  'paragraphFormat'
                  'align'
                  'formatOL'
                  'formatUL'
                  'outdent'
                  'indent'
                  'quote'
                #   '-'
                  'insertLink'
                #   'insertImage'
                #   'insertVideo'
                #   'embedly'
                #   'insertFile'
                  'insertTable'
                #   '|'
                  'emoticons'
                #   'specialCharacters'
                #   'insertHR'
                  'selectAll'
                  'clearFormatting'
                  '|'
                #   'print'
                #   'spellChecker'
                #   'help'
                  'html'
                #   '|'
                  'undo'
                  'redo'
                ]
            # toolbarButtonsMD: ['bold', 'italic', 'underline']
            # toolbarButtonsSM: ['bold', 'italic', 'underline']
            toolbarButtonsXS: ['bold', 'italic', 'underline']
            imageInsertButtons: ['imageBack', '|', 'imageByURL']
            tabSpaces: false
            height: 200
        }


Template.image_edit.events
    "change input[name='upload_image']": (e) ->
        files = e.currentTarget.files
        parent = Template.parentData(5)
        Cloudinary.upload files[0],
            # folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
            # model:"private" # optional: makes the image accessible only via a signed url. The signed url is available publicly for 1 hour.
            (err,res) => #optional callback, you can catch with the Cloudinary collection as well
                # console.dir res
                if err
                    console.error 'Error uploading', err
                else
                    doc = Docs.findOne parent._id
                    Docs.update parent._id,
                        $set:"#{@valueOf()}":res.public_id


    'blur .cloudinary_id': (e,t)->
        cloudinary_id = t.$('.cloudinary_id').val()
        parent = Template.parentData(5)
        Docs.update parent._id,
            $set:"#{@valueOf()}":cloudinary_id


    'click #remove_photo': ->
        parent = Template.parentData(5)

        if confirm 'Remove Photo?'
            # Docs.update parent._id,
            #     $unset:"#{@valueOf()}":1
            doc = Docs.findOne parent._id
            user = Meteor.users.findOne parent._id
            Docs.update parent._id,
                $unset:"#{@valueOf()}":1




Template.pdf_edit.events
    "change input[name='upload_pdf']": (e) ->
        files = e.currentTarget.files
        parent = Template.parentData(5)
        Cloudinary.upload files[0],
            # folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
            # model:"private" # optional: makes the image accessible only via a signed url. The signed url is available publicly for 1 hour.
            (err,res) => #optional callback, you can catch with the Cloudinary collection as well
                # console.dir res
                if err
                    console.error 'Error uploading', err
                else
                    doc = Docs.findOne parent._id
                    Docs.update parent._id,
                        $set:"#{@valueOf()}":res.public_id


    'blur .cloudinary_id': (e,t)->
        cloudinary_id = t.$('.cloudinary_id').val()
        parent = Template.parentData(5)
        Docs.update parent._id,
            $set:"#{@valueOf()}":cloudinary_id


    'click #remove_photo': ->
        parent = Template.parentData(5)

        if confirm 'Remove PDF?'
            # Docs.update parent._id,
            #     $unset:"#{@valueOf()}":1
            doc = Docs.findOne parent._id
            user = Meteor.users.findOne parent._id
            Docs.update parent._id,
                $unset:"#{@valueOf()}":1





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

# Template.textarea.onCreated ->
#     @editing = new ReactiveVar false

# Template.textarea.helpers
#     is_editing: -> Template.instance().editing.get()


Template.textarea_edit.events
    # 'click .toggle_edit': (e,t)->
    #     t.editing.set !t.editing.get()

    'blur .edit_textarea': (e,t)->
        textarea_val = t.$('.edit_textarea').val()
        parent = Template.parentData(5)

        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":textarea_val



Template.text_edit.events
    'blur .edit_text': (e,t)->
        val = t.$('.edit_text').val()
        parent = Template.parentData(5)

        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":val


Template.slug_edit.events
    'blur .edit_text': (e,t)->
        val = t.$('.edit_text').val()
        parent = Template.parentData(5)

        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":val


    'click .slugify_title': (e,t)->
        page_doc = Docs.findOne Router.current().params.doc_id
        # val = t.$('.edit_text').val()
        parent = Template.parentData(5)
        doc = Docs.findOne parent._id
        Meteor.call 'slugify', page_doc._id, (err,res)=>
            Docs.update page_doc._id,
                $set:slug:res

Template.phone_edit.events
    'blur .edit_phone': (e,t)->
        val = t.$('.edit_phone').val()
        parent = Template.parentData(5)

        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":val


Template.boolean_edit.helpers
    boolean_toggle_class: ->
        parent = Template.parentData(5)
        if parent["#{@valueOf()}"] then 'active' else 'basic'


Template.boolean_edit.events
    'click .toggle_boolean': (e,t)->
        parent = Template.parentData(5)

        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":!parent["#{@valueOf()}"]



Template.number_edit.events
    'blur .edit_number': (e,t)->
        parent = Template.parentData(5)
        val = parseInt t.$('.edit_number').val()
        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":val


Template.float_edit.events
    'blur .edit_float': (e,t)->
        parent = Template.parentData(5)
        val = parseFloat t.$('.edit_float').val()
        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":val



Template.dollar_price_edit.events
    'blur .edit_price': (e,t)->
        parent = Template.parentData(5)
        val = parseInt t.$('.edit_price').val()
        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":val


Template.dollar_price_view.events
    'click .buy_now': ->
        parent = Template.parentData()
        parent5 = Template.parentData(5)
        parent6 = Template.parentData(6)
        if @direct
            parent = Template.parentData()
        else if parent5._id
            parent = Template.parentData(5)
        else if parent6._id
            parent = Template.parentData(6)
        if parent
            value = parent["#{@valueOf()}"]

            Template.instance().checkout.open
                name: parent.title
                # email:Meteor.user().emails[0].address
                description: 'gold run market'
                amount: value*100

    # 'click .add_to_tab': ->
    # 'blur .edit_price': (e,t)->
    #     if @direct
    #         parent = Template.parentData()
    #     else
    #         parent = Template.parentData(5)
    #     val = parseInt t.$('.edit_price').val()
    #     doc = Docs.findOne parent._id
    #     user = Meteor.users.findOne parent._id
    #     if doc
    #         Docs.update parent._id,
    #             $set:"#{@valueOf()}":val
    #     else if user
    #         Meteor.users.update parent._id,
    #             $set:"#{@valueOf()}":val




Template.date_edit.events
    'blur .edit_date': (e,t)->
        parent = Template.parentData(5)
        val = t.$('.edit_date').val()

        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":val




Template.datetime_edit.events
    'blur .edit_datetime': (e,t)->
        parent = Template.parentData(5)
        val = t.$('.edit_datetime').val()
        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":val





Template.time_edit.events
    'blur .edit_time': (e,t)->
        parent = Template.parentData(5)
        val = t.$('.edit_time').val()

        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":val


Template.youtube_edit.onRendered ->
    Meteor.setTimeout ->
        $('.ui.embed').embed();
    , 1000

Template.youtube_view.onRendered ->
    Meteor.setTimeout ->
        $('.ui.embed').embed();
    , 1000


Template.youtube_edit.events
    'blur .youtube_id': (e,t)->
        parent = Template.parentData(5)
        val = t.$('.youtube_id').val()
        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{@valueOf()}":val


Template.children_view.onCreated ->
    # @autorun => Meteor.subscribe 'children', @data.ref_model, Template.parentData(5)._id
    @autorun => Meteor.subscribe 'child_docs', Template.parentData(5)._id
    @autorun => Meteor.subscribe 'model_from_slug', @data.ref_model
    @autorun => Meteor.subscribe 'model_fields_from_slug', @data.ref_model

Template.children_view.onRendered ->
    Meteor.setTimeout ->
        $('.accordion').accordion()
    , 1000

Template.children_view.helpers
    children: ->
        field = @
        # if Template.parentData(5)
        # else
        parent = Template.parentData(5)
        Docs.find {
            model: @ref_model
            parent_id: parent._id
            # view_roles:$in:Meteor.user().roles
        }, sort:rank:1


Template.children_edit.onCreated ->
    @autorun => Meteor.subscribe 'children', @data.ref_model, Template.parentData(5)._id
    # @autorun => Meteor.subscribe 'child_docs', Template.parentData(5)._id
    @autorun => Meteor.subscribe 'model_from_slug', @data.ref_model
    @autorun => Meteor.subscribe 'model_fields', @data.ref_model
Template.children_view.onCreated ->
    @autorun => Meteor.subscribe 'children', @data.ref_model, Template.parentData(5)._id
    # @autorun => Meteor.subscribe 'child_docs', Template.parentData(5)._id
    @autorun => Meteor.subscribe 'model_from_slug', @data.ref_model
    @autorun => Meteor.subscribe 'model_fields', @data.ref_model

Template.children_edit.onRendered ->
    Meteor.setTimeout ->
        $('.accordion').accordion()
    , 1000
Template.child_edit.helpers
    child_fields: ->
        model = Docs.findOne
            model:'model'
            slug:@model
        Docs.find
            model:'field'
            parent_id:model._id

Template.child_view.helpers
    child_fields: ->
        model = Docs.findOne
            model:'model'
            slug:@model
        Docs.find
            model:'field'
            parent_id:model._id


Template.children_edit.helpers
    children: ->
        field = @

        # if Template.parentData(5)
        # else
        parent = Template.parentData(5)
        Docs.find {
            model: @ref_model
            parent_id: parent._id
            # view_roles:$in:Meteor.user().roles
        }, sort:rank:1


Template.children_edit.events
    'click .add_child': ->
        parent = Template.parentData()
        parent2 = Template.parentData(2)
        parent3 = Template.parentData(3)
        parent4 = Template.parentData(4)
        parent5 = Template.parentData(5)
        parent6 = Template.parentData(6)


        new_id = Docs.insert
            model: @ref_model
            parent_id: parent5._id
            parent_model:Router.current().params.model_slug






Template.html_view.onRendered ->
    Meteor.setTimeout ->
        $('.accordion').accordion()
    , 1000

Template.textarea_view.onRendered ->
    Meteor.setTimeout ->
        $('.accordion').accordion()
    , 1000




Template.single_doc_view.onCreated ->
    @autorun => Meteor.subscribe 'model_docs', @data.ref_model

Template.single_doc_view.helpers
    choices: ->
        Docs.find
            model:@ref_model

    single_doc_value: ->
        # console.log @
        # console.log Template.currentData()
        parent = Template.parentData(5)
        # console.log parent
        referenced_doc = Docs.findOne(parent["#{@valueOf()}"])
        if Template.instance().subscriptionsReady()
            # console.log 'hi'
            if referenced_doc
                # console.log @key
                # console.log referenced_doc
                referenced_doc["#{@lookup_field}"]

    single_doc_ref_doc: ->
        # console.log @
        # console.log Template.currentData()
        parent = Template.parentData(5)
        # console.log parent
        referenced_doc = Docs.findOne(parent["#{@valueOf()}"])
        if Template.instance().subscriptionsReady()
            referenced_doc


Template.single_doc_edit.onCreated ->
    if @data.direct = true
        parent = Template.parentData()
    else
        parent = Template.parentData(5)
    @autorun => Meteor.subscribe 'doc', parent["#{@data.key}"]
    # console.log @
    @autorun => Meteor.subscribe 'model_docs', @data.ref_model
    @doc_results = new ReactiveVar
Template.single_doc_edit.helpers
    doc_results: ->Template.instance().doc_results.get()
    single_doc_value: ->
        # console.log @
        # console.log Template.currentData()
        parent = Template.parentData(5)
        referenced_doc = Docs.findOne(parent["#{@valueOf()}"])
        if Template.instance().subscriptionsReady()
            # console.log 'hi'
            if referenced_doc
                # console.log @key
                console.log referenced_doc
                referenced_doc["#{@lookup_field}"]

    choices: ->
        if @ref_model
            Docs.find {
                model:@ref_model
            }, sort:slug:1
    calculated_label: ->
        ref_doc = Template.currentData()
        key = Template.parentData().button_label
        ref_doc["#{key}"]

    choice_class: ->
        selection = @
        current = Template.currentData()
        ref_field = Template.parentData(1)
        if ref_field.direct
            parent = Template.parentData(2)
        else
            parent = Template.parentData(5)
        target = Template.parentData(2)
        if @direct
            if target["#{ref_field.key}"]
                if @ref_field is target["#{ref_field.key}"] then 'active' else ''
            else ''
        else
            if parent["#{ref_field.key}"]
                if @slug is parent["#{ref_field.key}"] then 'active' else ''
            else ''


Template.single_doc_edit.events
    'click .clear_results': (e,t)->
        t.user_results.set null

    'keyup #single_doc_input': (e,t)->
        # console.log @
        search_value = $(e.currentTarget).closest('#single_doc_input').val().trim()
        # console.log search_value
        if search_value.length > 1
            Meteor.call 'lookup_doc', @lookup_field, search_value, @ref_model, (err,res)=>
                if err then console.error err
                else
                    t.doc_results.set res

    'click .select_doc': (e,t) ->
        page_doc = Docs.findOne Router.current().params.doc_id
        field = Template.currentData()
        # console.log field
        # console.log @
        if field.direct
            parent = Template.parentData()
        else
            parent = Template.parentData(7)
        # console.log parent

        doc = Docs.findOne page_doc._id
        user = Meteor.users.findOne page_doc._id
        if doc
            Docs.update page_doc._id,
                $set:"#{field.key}":@_id
        else if user
            Meteor.users.update page_doc._id,
                $set:"#{field.key}":@_id

        t.doc_results.set null
        $('#single_doc_input').val ''
        # Docs.update page_doc._id,
        #     $set: assignment_timestamp:Date.now()



    'click .pull_doc': ->
        parent = Template.parentData(5)
        field = Template.currentData()
        Docs.update parent._id,
            $unset:"#{field.key}":1

        # if confirm "Remove #{@username}?"
        #     page_doc = Docs.findOne Router.current().params.id
            # Meteor.call 'unassign_user', page_doc._id, @



    'click .select_choice': ->
        selection = @
        ref_field = Template.currentData()
        if ref_field.direct
            parent = Template.parentData()
        else
            parent = Template.parentData(5)
        # parent = Template.parentData(1)

        # key = ref_field.button_key
        key = ref_field.key


        # if parent["#{key}"] and @["#{ref_field.button_key}"] in parent["#{key}"]
        if parent["#{key}"] and @slug in parent["#{key}"]
            doc = Docs.findOne parent._id
            Docs.update parent._id,
                $unset:"#{ref_field.key}":1
        else
            doc = Docs.findOne parent._id
            Docs.update parent._id,
                $set: "#{ref_field.key}": @slug


Template.multi_doc_view.onCreated ->
    @autorun => Meteor.subscribe 'model_docs', @data.ref_model

Template.multi_doc_view.helpers
    choices: ->
        Docs.find {
            model:@ref_model
        }, sort:slug:-1

# Template.multi_doc_edit.onRendered ->
#     $('.ui.dropdown').dropdown(
#         clearable:true
#         action: 'activate'
#         onChange: (text,value,$selectedItem)->
#         )



Template.multi_doc_edit.onCreated ->
    @autorun => Meteor.subscribe 'model_docs', @data.ref_model
Template.multi_doc_edit.helpers
    choices: ->
        Docs.find model:@ref_model

    choice_class: ->
        selection = @
        current = Template.currentData()
        parent = Template.parentData(5)
        ref_field = Template.parentData(1)
        target = Template.parentData(2)

        if target["#{ref_field.key}"]
            if @slug in target["#{ref_field.key}"] then 'active' else 'basic'
        else
            'basic'


Template.multi_doc_edit.events
    'click .select_choice': ->
        selection = @
        ref_field = Template.currentData()
        if ref_field.direct
            parent = Template.parentData(2)
        else
            parent = Template.parentData(6)
        parent = Template.parentData(1)
        parent2 = Template.parentData(2)
        parent3 = Template.parentData(3)
        parent4 = Template.parentData(4)
        parent5 = Template.parentData(5)
        parent6 = Template.parentData(6)
        parent7 = Template.parentData(7)

        #

        if parent["#{ref_field.key}"] and @slug in parent["#{ref_field.key}"]
            doc = Docs.findOne parent._id
            user = Meteor.users.findOne parent._id
            if doc
                Docs.update parent._id,
                    $pull:"#{ref_field.key}":@slug
            else if user
                Meteor.users.update parent._id,
                    $pull: "#{ref_field.key}": @slug
        else
            doc = Docs.findOne parent._id
            user = Meteor.users.findOne parent._id
            if doc
                Docs.update parent._id,
                    $addToSet: "#{ref_field.key}": @slug
            else if user
                Meteor.users.update parent._id,
                    $addToSet: "#{ref_field.key}": @slug


Template.single_user_edit.onCreated ->
    @user_results = new ReactiveVar
Template.single_user_edit.helpers
    user_results: ->Template.instance().user_results.get()
Template.single_user_edit.events
    'click .clear_results': (e,t)->
        t.user_results.set null

    'keyup #single_user_select_input': (e,t)->
        search_value = $(e.currentTarget).closest('#single_user_select_input').val().trim()
        if search_value.length > 1
            Meteor.call 'lookup_user', search_value, @role_filter, (err,res)=>
                if err then console.error err
                else
                    t.user_results.set res

    'click .select_user': (e,t) ->
        # page_doc = Docs.findOne Router.current().params.id
        field = Template.currentData()

        val = t.$('.edit_text').val()
        if field.direct
            parent = Template.parentData()
        else
            parent = Template.parentData(5)


        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $set:"#{field.key}":@username

        t.user_results.set null
        $('#single_user_select_input').val ''
        # Docs.update page_doc._id,
        #     $set: assignment_timestamp:Date.now()

    'click .pull_user': ->
        parent = Template.parentData(5)
        field = Template.currentData()
        Docs.update parent._id,
            $unset:"#{field.key}":1

        # if confirm "Remove #{@username}?"
        #     page_doc = Docs.findOne Router.current().params.id
            # Meteor.call 'unassign_user', page_doc._id, @


Template.document_view.onCreated ->
    @autorun => Meteor.subscribe 'document_by_slug', @data.key
Template.document_view.onRendered ->
    Meteor.setTimeout ->
        $('.accordion').accordion()
    , 1000
Template.document_view.helpers
    referenced_document: ->
        Docs.findOne
            model:'document'
            slug:@key


Template.document_edit.onCreated ->
    @autorun => Meteor.subscribe 'document_by_slug', @data.key
Template.document_edit.onRendered ->
    Meteor.setTimeout ->
        $('.accordion').accordion()
    , 1000
Template.document_edit.helpers
    referenced_document: ->
        Docs.findOne
            model:'document'
            slug:@key






Template.single_person_edit.onCreated ->
    @person_results = new ReactiveVar
Template.single_person_edit.helpers
    # selected_person: ->
    #     parent = Template.parentData(5)
    #     # val = t.$('.edit_date').val()
    #     brick = Template.parentData(4)
    #     parent = Template.parentData(5)

    #     if brick
    #         Docs.update parent._id,
    #             $set:"#{@valueOf()}":val
    #     else
    #         Docs.update parent._id,
    #             $set:"#{@valueOf()}":val


    person_results: ->
        person_results = Template.instance().person_results.get()
        person_results
Template.single_person_edit.events
    'click .clear_results': (e,t)->
        t.person_results.set null
    'click .clear_selection': (e,t)->
        if confirm "clear selection?"
            Docs.update parent._id,
                $unset:"#{@valueOf()}":1

    'keyup #single_person_select_input': (e,t)->
        search_value = $(e.currentTarget).closest('#single_person_select_input').val().trim()
        Meteor.call 'lookup_username', search_value, (err,res)=>
            if err then console.error err
            else
                t.person_results.set res


    'click .select_person': (e,t) ->
        page_doc = Docs.findOne Router.current().params.id
        val = t.$('.edit_text').val()
        parent = Template.parentData(5)

        Docs.update parent._id,
            $set:"#{@valueOf()}":@_id
        # else
        #     Docs.update parent._id,
        #         $set:"#{@valueOf()}":val

        t.person_results.set null
        $('#single_person_select_input').val ''
        # Docs.update page_doc._id,
        #     $set: assignment_timestamp:Date.now()



    'click .pull_user': ->
        parent = Template.currentData(0)
        if confirm "Remove #{@username}?"
            page_doc = Docs.findOne Router.current().params.id
            Meteor.call 'unassign_user', page_doc._id, @







Template.multi_user_edit.onCreated ->
    @user_results = new ReactiveVar
Template.multi_user_edit.helpers
    user_results: -> Template.instance().user_results.get()
Template.multi_user_edit.events
    'click .clear_results': (e,t)->
        t.user_results.set null
    'keyup #multi_user_select_input': (e,t)->
        search_value = $(e.currentTarget).closest('#multi_user_select_input').val().trim()
        if e.which is 8
            t.user_results.set null
        else if search_value and search_value.length > 1
            Meteor.call 'lookup_user', search_value, @role_filter, (err,res)=>
                if err then console.error err
                else
                    t.user_results.set res
    'click .select_user': (e,t) ->
        page_doc = Docs.findOne Router.current().params.id
        val = t.$('.edit_text').val()
        field = Template.currentData()

        if field.direct
            parent = Template.parentData()
        else
            parent = Template.parentData(5)

        doc = Docs.findOne parent._id
        Docs.update parent._id,
            $addToSet:"#{field.key}":@username


        t.user_results.set null
        $('#multi_user_select_input').val ''
        # Docs.update page_doc._id,
        #     $set: assignment_timestamp:Date.now()

    'click .pull_user': ->
        if confirm "remove #{@username}?"
            page_doc = Docs.findOne Router.current().params.id
            parent = Template.parentData(5)
            doc = Docs.findOne parent._id
            user = Meteor.users.findOne parent._id
            if doc
                Docs.update parent._id,
                    $pull:"#{@valueOf()}":@_id
            else if user
                Meteor.users.update parent._id,
                    $pull:"#{@valueOf()}":@_id
            # Meteor.call 'unassign_user', page_doc._id, @



Template.multi_doc_input.onCreated ->
    # @autorun => Meteor.subscribe 'model_docs', 'guest'
    @doc_results = new ReactiveVar
Template.multi_doc_input.helpers
    doc_results: -> Template.instance().doc_results.get()
Template.multi_doc_input.events
    'click .clear_results': (e,t)->
        t.doc_results.set null
    'keyup #multi_doc_select_input': (e,t)->
        search_value = $(e.currentTarget).closest('#multi_doc_select_input').val().trim()
        if search_value.length is 0
            t.doc_results.set null
        else if search_value
            Meteor.call 'lookup_doc', search_value, 'guest', (err,res)=>
                if err then console.error err
                else
                    t.doc_results.set res
    'click .select_doc': (e,t) ->
        # session_document = Docs.findOne Session.get('session_document')
        # if @direct
        #     parent = Template.parentData(1)
        # else
        #     parent = Template.parentData(5)
        parent = Docs.findOne _id: Router.current().params.doc_id
        Docs.update parent._id,
            $addToSet:guest_ids:@_id
        t.doc_results.set null
        $('#multi_user_select_input').val ''

    'click .pull_user': ->
        if confirm "Remove #{@username}?"
            page_doc = Docs.findOne Router.current().params.id
            parent = Template.parentData(5)
            doc = Docs.findOne parent._id
            user = Meteor.users.findOne parent._id
            if doc
                Docs.update parent._id,
                    $pull:"#{@valueOf()}":@_id
            else if user
                Meteor.users.update parent._id,
                    $pull:"#{@valueOf()}":@_id
            # Meteor.call 'unassign_user', page_doc._id, @






Template.range_edit.onRendered ->
    # rental = Template.currentData()
    $('#rangestart').calendar({
      type: 'datetime',
      endCalendar: $('#rangeend')
    });
    $('#rangeend').calendar({
      type: 'datetime',
      startCalendar: $('#rangestart')
    });
Template.range_edit.events
    'click .get_start': ->
        val = $('.ui.calendar').calendar('get startDate')[2]
        Docs.update @_id,
            $set:start_datetime:val
        # console.log $('.ui.calendar').calendar('get startDate')[2].getDate()
    'click .get_end': ->
        val = $('.ui.calendar').calendar('get endDate')[0]
        Docs.update @_id,
            $set:end_datetime:val
