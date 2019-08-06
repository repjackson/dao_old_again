# NaturalLanguageUnderstandingV1 = require('watson-developer-cloud/natural-language-understanding/v1.js');

Docs.allow
    insert: () -> true
    update: () -> true
    remove: () -> true

Meteor.publish 'doc', (doc_id)->
    Docs.find doc_id

Meteor.publish 'docs', (selected_tags)->
    # console.log selected_tags
    # self = @
    match = {}
    if selected_tags.length > 0 then match.tags = $all: selected_tags

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



Meteor.publish 'tags', (selected_tags)->
    self = @
    match = {}
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
    cloud.forEach (tag, i) ->
        self.added 'tags', Random.id(),
            name: tag.name
            count: tag.count
            index: i
    self.ready()
