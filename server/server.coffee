NaturalLanguageUnderstandingV1 = require('watson-developer-cloud/natural-language-understanding/v1.js');

Docs.allow
    insert: () -> true
    update: () -> true
    remove: () -> true

Meteor.publish 'doc', (doc_id)->
    Docs.find doc_id

SyncedCron.add(
    {
        name: 'science'
        schedule: (parser) ->
            parser.text 'every 31 minutes'
        job: ->
            Meteor.call 'pull_subreddit', 'science', (err, res)->
    }
)
SyncedCron.add(
    {
        name: 'news'
        schedule: (parser) ->
            parser.text 'every 32 minutes'
        job: ->
            Meteor.call 'pull_subreddit', 'news', (err, res)->
    }
)

SyncedCron.add(
    {
        name: 'environment'
        schedule: (parser) ->
            parser.text 'every 33 minutes'
        job: ->
            Meteor.call 'pull_subreddit', 'environment', (err, res)->
    }
)

SyncedCron.add(
    {
        name: 'economics'
        schedule: (parser) ->
            parser.text 'every 34 minutes'
        job: ->
            Meteor.call 'pull_subreddit', 'economics', (err, res)->
    }
)

SyncedCron.add(
    {
        name: 'technology'
        schedule: (parser) ->
            parser.text 'every 35 minutes'
        job: ->
            Meteor.call 'pull_subreddit', 'technology', (err, res)->
    }
)

SyncedCron.add(
    {
        name: 'business'
        schedule: (parser) ->
            parser.text 'every 36 minutes'
        job: ->
            Meteor.call 'pull_subreddit', 'business', (err, res)->
    }
)

SyncedCron.add(
    {
        name: 'worldnews'
        schedule: (parser) ->
            parser.text 'every 37 minutes'
        job: ->
            Meteor.call 'pull_subreddit', 'worldnews', (err, res)->
    }
)

SyncedCron.add(
    {
        name: 'philosophy'
        schedule: (parser) ->
            parser.text 'every 38 minutes'
        job: ->
            Meteor.call 'pull_subreddit', 'philosophy', (err, res)->
    }
)

SyncedCron.add(
    {
        name: 'anthropology'
        schedule: (parser) ->
            parser.text 'every 39 minutes'
        job: ->
            Meteor.call 'pull_subreddit', 'anthropology', (err, res)->
    }
)

SyncedCron.add(
    {
        name: 'politics'
        schedule: (parser) ->
            parser.text 'every 33 minutes'
        job: ->
            Meteor.call 'pull_subreddit', 'politics', (err, res)->
    }
)

SyncedCron.add(
    {
        name: 'food for thought'
        schedule: (parser) ->
            parser.text 'every 35 minutes'
        job: ->
            Meteor.call 'pull_subreddit', 'Foodforthought', (err, res)->
    }
)

SyncedCron.add(
    {
        name: 'psychology'
        schedule: (parser) ->
            parser.text 'every 40 minutes'
        job: ->
            Meteor.call 'pull_subreddit', 'psychology', (err, res)->
    }
)

SyncedCron.add(
    {
        name: 'artificial'
        schedule: (parser) ->
            parser.text 'every 42 minutes'
        job: ->
            Meteor.call 'pull_subreddit', 'artificial', (err, res)->
    }
)

SyncedCron.add(
    {
        name: 'compsci'
        schedule: (parser) ->
            parser.text 'every 45 minutes'
        job: ->
            Meteor.call 'pull_subreddit', 'compsci', (err, res)->
    }
)

SyncedCron.add(
    {
        name: 'math'
        schedule: (parser) ->
            parser.text 'every 44 minutes'
        job: ->
            Meteor.call 'pull_subreddit', 'math', (err, res)->
    }
)


if Meteor.isProduction
    SyncedCron.start()

Meteor.publish 'docs', (selected_tags)->
    console.log selected_tags
    self = @
    match = {}
    if selected_tags.length > 0 then match.tags = $all: selected_tags

    Docs.find match


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



Meteor.publish 'tags', (selected_tags, filter)->
    self = @
    match = {}
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    if filter then match.model = filter
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



natural_language_understanding = new NaturalLanguageUnderstandingV1(
    version: '2018-11-16'
    iam_apikey: Meteor.settings.private.language.apikey
    url: Meteor.settings.private.language.url)


Meteor.methods
    call_watson: (doc_id, key, mode) ->
        self = @
        console.log doc_id
        console.log key
        console.log mode
        doc = Docs.findOne doc_id
        parameters =
            concepts:
                limit:20
            features:
                entities:
                    emotion: false
                    sentiment: false
                    # limit: 2
                keywords:
                    emotion: false
                    sentiment: false
                    # limit: 2
                concepts: {}
                categories: {}
                # emotion: {}
                # metadata: {}
                # relations: {}
                # semantic_roles: {}
                # sentiment: {}

        switch mode
            when 'html'
                parameters.html = doc["#{key}"]
            when 'text'
                parameters.text = doc["#{key}"]
            when 'url'
                parameters.url = doc["#{key}"]
                parameters.return_analyzed_text = true

        natural_language_understanding.analyze parameters, Meteor.bindEnvironment((err, response) ->
            if err then console.log err
            else
                keyword_array = _.pluck(response.keywords, 'text')
                lowered_keywords = keyword_array.map (keyword)-> keyword.toLowerCase()
                # console.log 'categories',response.categories
                adding_tags = []
                for category in response.categories
                    console.log category.label.split('/')
                    for tag in category.label.split('/')
                        if tag.length > 0 then adding_tags.push tag
                console.log 'adding tags', adding_tags
                Docs.update { _id: doc_id },
                    $addToSet:
                        tags:$each:adding_tags

                for entity in response.entities
                    Docs.update { _id: doc_id },
                        $addToSet:
                            # "#{entity.type}":entity.text
                            tags:entity.text.toLowerCase()

                concept_array = _.pluck(response.concepts, 'text')
                lowered_concepts = concept_array.map (concept)-> concept.toLowerCase()
                # Docs.update { _id: doc_id },
                #     $set:
                #         analyzed_text:response.analyzed_text
                #         watson: response
                #         watson_concepts: lowered_concepts
                #         watson_keywords: lowered_keywords
                        # doc_sentiment_score: response.sentiment.document.score
                        # doc_sentiment_label: response.sentiment.document.label
                Docs.update { _id: doc_id },
                    $addToSet:
                        tags:$each:lowered_concepts
                Docs.update { _id: doc_id },
                    $addToSet:
                        tags:$each:lowered_keywords



        )


    pull_site: (doc_id, url)->
        console.log 'pulling site', doc_id, url
        this_id = doc_id
        doc = Docs.findOne doc_id
        parameters =
            url: url
            features:
                entities:
                    emotion: false
                    sentiment: false
                    # limit: 2
                keywords:
                    emotion: false
                    sentiment: false
                    # limit: 2
                concepts: {}
                categories: {}
                # emotion: {}
                # metadata: {}
                # relations: {}
                # semantic_roles: {}
                # sentiment: {}
            return_analyzed_text: true
            clean:true

        natural_language_understanding.analyze parameters, Meteor.bindEnvironment((err, response) =>
            if err
                console.error err
            else
                adding_tags = []
                for category in response.categories
                    console.log category.label.split('/')
                    for tag in category.label.split('/')
                        if tag.length > 0 then adding_tags.push tag
                console.log 'adding tags', adding_tags
                Docs.update { _id: doc_id },
                    $addToSet:
                        tags:$each:adding_tags


                keyword_array = _.pluck(response.keywords, 'text')
                lowered_keywords = keyword_array.map (keyword)-> keyword.toLowerCase()

                concept_array = _.pluck(response.concepts, 'text')
                lowered_concepts = concept_array.map (concept)-> concept.toLowerCase()

                for entity in response.entities
                    Docs.update { _id: doc_id },
                        $addToSet:
                            # "#{entity.type}":entity.text
                            tags:entity.text.toLowerCase()


                Docs.update {_id:this_id},
                    $set:
                        # model:'website'
                        # watson: response
                        # watson_keywords: lowered_keywords
                        # watson_concepts: lowered_concepts
                        # doc_sentiment_score: response.sentiment.document.score
                        # doc_sentiment_label: response.sentiment.document.label
                        new_html: response.analyzed_text
                Docs.update { _id: doc_id },
                    $addToSet:
                        tags:$each:lowered_concepts
                Docs.update { _id: doc_id },
                    $addToSet:
                        tags:$each:lowered_keywords
                final_doc = Docs.findOne doc_id

                # console.log final_doc.tags
                final_doc.tags
        )



    pull_subreddit: (subreddit)->
        response = HTTP.get("http://reddit.com/r/#{subreddit}.json")
        # return response.content

        _.each(response.data.data.children[..5], (item)->
            data = item.data
            len = 200

            reddit_post =
                reddit_id: data.id
                url: data.url
                domain: data.domain
                comment_count: data.num_comments
                permalink: data.permalink
                title: data.title
                selftext: false
                thumbnail: false
                site: 'reddit'
                type: 'reddit'

            console.log data.url
            existing_doc = Docs.findOne url:data.url
            unless existing_doc
                if data.url
                    console.log 'no existing doc, creating', data.url

                    new_doc_id = Docs.insert url:data.url
                    Meteor.call 'pull_site', new_doc_id, data.url, (err,res)->
                        console.log res
            else
                console.log 'found existing doc', data.url, existing_doc.tags[..6]
        )
