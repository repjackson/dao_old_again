Docs.allow
    insert: (userId, doc) -> doc._author_id is userId
    update: (userId, doc) -> userId
    # update: (userId, doc) -> doc._author_id is userId or 'admin' in Meteor.user().roles
    remove: (userId, doc) -> doc._author_id is userId or 'admin' in Meteor.user().roles

Meteor.users.allow
    update: (userId, doc, fields, modifier) ->
        true
        # if userId and doc._id == userId
        #     true

Cloudinary.config
    cloud_name: 'facet'
    api_key: Meteor.settings.private.cloudinary_key
    api_secret: Meteor.settings.private.cloudinary_secret



Meteor.publish 'doc', (doc_id)->
    console.log doc_id
    Docs.find doc_id

Meteor.publish 'me', ()->
    Meteor.users.find Meteor.userId()

Meteor.publish 'docs', (selected_tags, selected_usernames)->
    # console.log selected_tags
    # self = @
    match = {}
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    if selected_usernames.length > 0 then match._author_username = selected_usernames[0]

    Docs.find(match, limit:5)
    # Docs.find({},limit:10)


Meteor.methods
    related_posts: (doc_id)->
        post = Docs.findOne doc_id
        unless post.matches
            Docs.update doc_id,
                $set:matches:[]
        related_ids = []

        matches = post.matches
        related_posts_with_counts = []
        # console.log 'finding matches for ', post
        for tag in post.tags
            found_matches = Docs.find
                _id:$ne:doc_id
                tags:$in:[tag]
            if found_matches.fetch().length > 0
                for found_match in found_matches.fetch()
                    related_ids.push found_match._id
                    match_subobject = _.where(matches, {doc_id: found_match._id})
                    # console.log 'match subobject', match_subobject
                    union = _.intersection(found_match.tags, post.tags)
                    if match_subobject.length > 0
                        Docs.update { _id:doc_id, "matches.doc_id":found_match._id},
                            $set: "matches.$.tag_match_count": union.length
                    else
                        match_subobject = {doc_id:found_match._id,tag_match_count:union.length}
                        Docs.update _id:doc_id,
                            $addToSet: "matches": match_subobject

            # console.log 'found match with ', tag, found_matches.fetch()
        # console.log 'related ids', related_ids
        Docs.update doc_id,
            $set:related_ids:related_ids



Meteor.publish 'related_posts', (doc_id)->
    post = Docs.findOne doc_id
    if post.related_ids
        Docs.find
            _id:$in:post.related_ids



Meteor.publish 'classic_facet', (selected_tags, selected_usernames)->
    self = @
    match = {}
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    if selected_usernames.length > 0 then match._author_username = selected_usernames[0]
    console.log 'match', match
    tag_cloud = Docs.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: "$tags" }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: 100 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
    # console.log tag_cloud.toArray()
    tag_cloud.forEach (tag, i) ->
        self.added 'tags', Random.id(),
            name: tag.name
            count: tag.count
            index: i
    username_cloud = Docs.aggregate [
        { $match: match }
        { $project: _author_username: 1 }
        { $group: _id: '$_author_username', count: $sum: 1 }
        { $match: _id: $nin: selected_usernames }
        { $sort: count: -1, _id: 1 }
        { $limit: 100 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
    # console.log username_cloud.toArray()
    username_cloud.forEach (username, i) ->
        self.added 'usernames', Random.id(),
            name: username.name
            count: username.count
            index: i
    self.ready()

if Meteor.isProduction
    SyncedCron.start()

Meteor.publish 'model_docs', (model,limit)->
    if limit
        Docs.find {
            model: model
        }, limit:limit
    else
        Docs.find
            model: model

Meteor.publish 'document_by_slug', (slug)->
    Docs.find
        model: 'document'
        slug:slug

Meteor.publish 'child_docs', (id)->
    Docs.find
        parent_id:id


Meteor.publish 'facet_doc', (tags)->
    split_array = tags.split ','
    Docs.find
        tags: split_array


Meteor.publish 'inline_doc', (slug)->
    Docs.find
        model:'inline_doc'
        slug:slug


Meteor.publish 'current_session', ->
    Docs.find
        model: 'healthclub_session'
        current:true


Meteor.publish 'user_from_username', (username)->
    Meteor.users.find username:username

Meteor.publish 'user_from_id', (user_id)->
    Meteor.users.find user_id

Meteor.publish 'author_from_doc_id', (doc_id)->
    doc = Docs.findOne doc_id
    Meteor.users.find user_id

Meteor.publish 'page', (slug)->
    Docs.find
        model:'page'
        slug:slug

Meteor.publish 'page_children', (slug)->
    page = Docs.findOne
        model:'page'
        slug:slug
    Docs.find
        parent_id:page._id



Meteor.publish 'checkin_guests', (doc_id)->
    session_document = Docs.findOne doc_id
        # model:'healthclub_session'
        # current:true
    Docs.find
        _id:$in:session_document.guest_ids


Meteor.publish 'resident', (guest_id)->
    guest = Docs.findOne guest_id
    Meteor.users.find
        _id:guest.resident_id



Meteor.publish 'health_club_members', (username_query)->
    existing_sessions =
        Docs.find(
            model:'healthclub_session'
            active:true
        ).fetch()
    active_session_ids = []
    for active_session in existing_sessions
        active_session_ids.push active_session.user_id
    Meteor.users.find({
        _id:$nin:active_session_ids
        username: {$regex:"#{username_query}", $options: 'i'}
        # healthclub_checkedin:$ne:true
        roles:$in:['resident','owner']
        },{ limit:20 })




Meteor.publish 'page_blocks', (slug)->
    page = Docs.findOne
        model:'page'
        slug:slug
    if page
        Docs.find
            parent_id:page._id


Meteor.publish 'doc_tags', (selected_tags)->

    user = Meteor.users.findOne @userId
    # current_herd = user.profile.current_herd

    self = @
    match = {}

    # selected_tags.push current_herd
    match.tags = $all: selected_tags

    cloud = Docs.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: "$tags" }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: 50 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
    cloud.forEach (tag, i) ->

        self.added 'tags', Random.id(),
            name: tag.name
            count: tag.count
            index: i

    self.ready()
