Meteor.users.allow
    update: (userId, doc, fields, modifier) ->
        true
    remove: (userId, doc, fields, modifier) ->
        true
        # if userId and doc._id == userId
        #     true

# Cloudinary.config
#     cloud_name: 'facet'
#     api_key: Meteor.settings.private.cloudinary_key
#     api_secret: Meteor.settings.private.cloudinary_secret


Meteor.publish 'tags', (selected_tags)->
    console.log selected_tags
    self = @
    match = {}

    # match.tags = $all: selected_tags
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    cloud = Docs.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: "$tags" }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: 100 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]
    cloud.forEach (tag) ->
        self.added 'tags', Random.id(),
            name: tag.name
            count: tag.count
    self.ready()



# Meteor.publish 'doc_tags', (selected_tags)->
#     self = @
#     match = {}
#     match.tags = $all: selected_tags
#
#     cloud = Docs.aggregate [
#         { $match: match }
#         { $project: tags: 1 }
#         { $unwind: "$tags" }
#         { $group: _id: '$tags', count: $sum: 1 }
#         { $match: _id: $nin: selected_tags }
#         { $sort: count: -1, _id: 1 }
#         { $limit: 50 }
#         { $project: _id: 0, name: '$_id', count: 1 }
#         ]
#     cloud.forEach (tag, i) ->
#         self.added 'tags', Random.id(),
#             name: tag.name
#             count: tag.count
#             index: i
#     self.ready()
