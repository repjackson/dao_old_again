@selected_tags = new ReactiveArray []

# Meteor.startup ->
#     scheduler.init "scheduler_here", new Date()
#     scheduler.meteor(Docs.find(model:'event'), Docs);

$.cloudinary.config
    cloud_name:"facet"
# Router.notFound =
    # action: 'not_found'

# Meteor.startup ->
#     if Meteor.isClient
#         #This code is needed to detect if there is a subdomain. So the system wants to know the routes of the subdomain
#         hostnameArray = document.location.hostname.split('.')
#         if hostnameArray.length >= 3
#             subdomain = hostnameArray[0].toLowerCase().ucfirst()
#             defineFunctionString = 'define' + subdomain + 'Routes'
#             if typeof window[defineFunctionString] == 'function'
#                 Meteor['is' + subdomain] = true
#                 window[defineFunctionString]()
#                 console.log 'subdomain detected'
#                 #To call the function dynamically!
#         else
#             defineRoutes()




Template.body.events
    'click a': ->
        $('.global_container')
        .transition('fade out', 250)
        .transition('fade in', 250)


Template.registerHelper 'current_tribe', () ->
    # console.log Meteor.absoluteUrl.defaultOptions.rootUrl
    # console.log Meteor.absoluteUrl()
    # full = window.location.host
    # # //window.location.host is subdomain.domain.com
    # parts = full.split('.')
    # sub = parts[0]
    # domain = parts[1]
    # type = parts[2]
    # console.log 'sub', sub
    # console.log 'domain', domain
    # console.log 'type', type
    # if sub in ['localhost:3000','dao.af','dao2.com']
    #     console.log 'current tribe is dao root'
    #     'dao'
    #     tribe_doc = Docs.findOne
    #         model:'tribe'
    #         slug: 'dao'
    #     console.log tribe_doc
    #     tribe_doc
    # else
    #     console.log 'current tribe is ', sub
    #     sub
    #     tribe_doc = Docs.findOne
    #         model:'tribe'
    #         slug: sub
    #     console.log tribe_doc
    #     tribe_doc
    #     # window.open("dao.localhost:3000");
    #     Router.go "http://dao.localhost:3000"
    # //sub is 'subdomain', 'domain', type is 'com'
    # var newUrl = 'http://' + domain + '.' + type + '/your/other/path/' + subDomain
    # console.log Router.current().params.tribe_slug
    slug = Router.current().params.tribe_slug
    # console.log Meteor.user().current_tribe_slug
    if slug
        Docs.findOne
            model:'tribe'
            slug: slug

# Stripe.setPublishableKey Meteor.settings.public.stripe_publishable

Session.setDefault 'invert', false
Template.registerHelper 'current_tribe_slug', () ->
    Router.current().params.tribe_slug
Template.registerHelper 'tribe_by_slug', () ->
    if Router.current().params.doc_id
        Docs.findOne Router.current().params.doc_id
    else
        Docs.findOne
            model:'tribe'
            slug:Router.current().params.tribe_slug
Template.registerHelper 'loading_checkin', () -> Session.get 'loading_checkin'
Template.registerHelper 'parent', () -> Template.parentData()
Template.registerHelper 'invert_class', () -> if Session.equals('dark_mode',true) then 'invert' else ''
Template.registerHelper 'is_loading', () -> Session.get 'loading'
Template.registerHelper 'dev', () -> Meteor.isDevelopment
Template.registerHelper 'is_author', () -> @_author_id is Meteor.userId()
Template.registerHelper 'is_grandparent_author', () ->
    grandparent = Template.parentData(2)
    grandparent._author_id is Meteor.userId()
Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()
Template.registerHelper 'long_date', (input) -> moment(input).format("dddd, MMMM Do h:mm:ss a")
Template.registerHelper 'today', () -> moment(Date.now()).format("dddd, MMMM Do a")
Template.registerHelper 'when', () -> moment(@_timestamp).fromNow()
Template.registerHelper 'from_now', (input) -> moment(input).fromNow()
Template.registerHelper 'last_initial', (user) ->
    @last_name[0]+'.'
    # moment(input).fromNow()
Template.registerHelper 'first_initial', (user) ->
    @first_name[0]+'.'
    # moment(input).fromNow()
Template.registerHelper 'logging_out', () -> Session.get 'logging_out'
Template.registerHelper 'is_event', () -> @shop_type is 'event'
Template.registerHelper 'is_service', () -> @shop_type is 'service'
Template.registerHelper 'is_product', () -> @shop_type is 'product'


Template.registerHelper 'current_month', () -> moment(Date.now()).format("MMMM")
Template.registerHelper 'current_day', () -> moment(Date.now()).format("DD")
Template.registerHelper 'tribe_background', () ->
    if Meteor.user() and Meteor.user().current_tribe_slug
        tribe = Docs.findOne
            model:'tribe'
            slug:Meteor.user().current_tribe_slug
        if tribe
            tribe.background




Meteor.methods
Template.registerHelper 'referenced_product', () ->
    Docs.findOne
        _id:@product_id


Template.registerHelper 'author', () -> Meteor.users.findOne @_author_id
Template.registerHelper 'is_text', () ->
    # console.log @field_type
    @field_type is 'text'

Template.registerHelper 'template_parent', () ->
    # console.log Template.parentData()
    Template.parentData()

Template.registerHelper 'fields', () ->
    model = Docs.findOne
        model:'model'
        slug:Router.current().params.model_slug
    if model
        Docs.find {
            model:'field'
            parent_id:model._id
            view_roles:$in:Meteor.user().roles
        }, sort:rank:1

Template.registerHelper 'edit_fields', () ->
    model = Docs.findOne
        model:'model'
        slug:Router.current().params.model_slug
    if model
        if 'dev' in Meteor.user().roles
            Docs.find {
                model:'field'
                parent_id:model._id
            }, sort:rank:1
        else
            Docs.find {
                model:'field'
                parent_id:model._id
                edit_roles:$in:Meteor.user().roles
            }, sort:rank:1

Template.registerHelper 'current_user', (input) ->
    Meteor.user() and Meteor.user().username is Router.current().params.username


Template.registerHelper 'user_is_client', (input) ->
    user = Meteor.users.findOne username:Router.current().params.username
    if user and user.roles and 'client' in user.roles then true else false

Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)


Template.registerHelper 'loading_class', () ->
    if Session.get 'loading' then 'disabled' else ''

Template.registerHelper 'current_model', (input) ->
    Docs.findOne
        model:'model'
        slug: Router.current().params.model_slug

Template.registerHelper 'in_list', (key) ->
    if Meteor.userId()
        if Meteor.userId() in @["#{key}"] then true else false


Template.registerHelper 'is_admin', () ->
    if Meteor.user() and Meteor.user().roles
        # if _.intersection(['dev','admin'], Meteor.user().roles) then true else false
        if 'admin' in Meteor.user().roles then true else false

Template.registerHelper 'is_staff', () ->
    if Meteor.user() and Meteor.user().roles
        # if _.intersection(['dev','staff'], Meteor.user().roles) then true else false
        if 'staff' in Meteor.user().roles then true else false
Template.registerHelper 'is_dev', () ->
    if Meteor.user() and Meteor.user().roles
        if 'dev' in Meteor.user().roles then true else false

Template.registerHelper 'is_user', () ->
    if Meteor.user() and Meteor.user().roles
        if 'user' in Meteor.user().roles then true else false



Template.registerHelper 'user_is_user', () -> if @roles and 'user' in @roles then true else false
Template.registerHelper 'user_is_resident_or_owner', () -> if @roles and _.intersection(@roles,['resident','owner']) then true else false


Template.registerHelper 'is_eric', () -> if Meteor.userId() and 'CFTSK5ZtNpMpZFMwi' is Meteor.userId() then true else false

Template.registerHelper 'current_user', () ->  Meteor.users.findOne username:Router.current().params.username
Template.registerHelper 'is_current_user', () ->  Meteor.user().username is Router.current().params.username
Template.registerHelper 'view_template', -> "#{@field_type}_view"
Template.registerHelper 'edit_template', -> "#{@field_type}_edit"
Template.registerHelper 'is_model', -> @model is 'model'


# Template.body.events
#     'click .toggle_sidebar': -> $('.ui.sidebar').sidebar('toggle')

Template.registerHelper 'is_editing', () -> Session.equals 'editing_id', @_id


Template.registerHelper 'can_edit', () -> Meteor.userId() is @_author_id or 'admin' in Meteor.user().roles

Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()

Template.registerHelper 'current_doc', ->
    doc = Docs.findOne Router.current().params.doc_id
    user = Meteor.users.findOne Router.current().params.doc_id
    # console.log doc
    # console.log user
    if doc then doc else if user then user


Template.registerHelper 'user_from_username_param', () ->
    found = Meteor.users.findOne username:Router.current().params.username
    # console.log found
    found
Template.registerHelper 'field_value', () ->
    # console.log @
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
        parent["#{@key}"]


Template.registerHelper 'in_dev', () -> Meteor.isDevelopment

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
