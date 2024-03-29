ToneAnalyzerV3 = require('watson-developer-cloud/tone-analyzer/v3')
VisualRecognitionV3 = require('watson-developer-cloud/visual-recognition/v3')
NaturalLanguageUnderstandingV1 = require('watson-developer-cloud/natural-language-understanding/v1.js');
PersonalityInsightsV3 = require('watson-developer-cloud/personality-insights/v3')

tone_analyzer = new ToneAnalyzerV3(
    iam_apikey: Meteor.settings.private.tone.apikey
    url: Meteor.settings.private.tone.url
    version_date: '2017-09-21')
# pFbEpJ4Onu3XV6K5juyIkkljoid92Qja2HXc_e8-voJQ


natural_language_understanding = new NaturalLanguageUnderstandingV1(
    version: '2018-11-16'
    iam_apikey: Meteor.settings.private.language.apikey
    url: Meteor.settings.private.language.url)


visual_recognition = new VisualRecognitionV3(
    version:'2018-03-19'
    iam_apikey: Meteor.settings.private.visual.apikey)


personality_insights = new PersonalityInsightsV3(
    version:'2017-10-13',
    iam_apikey: Meteor.settings.private.personality.apikey,
    url: Meteor.settings.private.personality.url)



Meteor.methods
    call_personality: (doc_id, key)->
        self = @
        doc = Docs.findOne doc_id
        params =
            content: doc.new_html,
            content_type: 'text/html',
            consumption_preferences: true,
            raw_scores: false
        personality_insights.profile params, Meteor.bindEnvironment((err, response)->
            if err
                Docs.update { _id: doc_id},
                    $set:
                        personality: false
            else
                # console.dir response
                Docs.update { _id: doc_id},
                    $set:
                        personality: response
        )


    call_tone: (doc_id, key, mode)->
        self = @
        doc = Docs.findOne doc_id
        # if doc.html or doc.body
        #     # stringed = JSON.stringify(doc.html, null, 2)
        if mode is 'html'
            params =
                tone_input:doc["#{key}"]
                content_type:'text/html'
        if mode is 'text'
            params =
                tone_input:doc["#{key}"]
                content_type:'text/plain'
        tone_analyzer.tone params, Meteor.bindEnvironment((err, response)->
            if err
            else
                # console.dir response
                Docs.update { _id: doc_id},
                    $set:
                        tone: response
            )
        # else return


    call_visual_link: (doc_id, field)->
        self = @
        doc = Docs.findOne doc_id
        link = doc["#{field}"]

        params =
            url:link
            # images_file: images_file
            # classifier_ids: classifier_ids
        visual_recognition.classify params, Meteor.bindEnvironment((err, response)->
            if err
            else
                Docs.update { _id: doc_id},
                    $set:
                        visual_classes: response.images[0].classifiers[0].classes
        )

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

        # Meteor.call 'call_personality', doc_id, ->
        # Meteor.call 'call_tone', doc_id, key, mode, ->


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
                keyword_array = _.pluck(response.keywords, 'text')
                lowered_keywords = keyword_array.map (keyword)-> keyword.toLowerCase()

                concept_array = _.pluck(response.concepts, 'text')
                lowered_concepts = concept_array.map (concept)-> concept.toLowerCase()

                for entity in response.entities
                    Docs.update { _id: doc_id },
                        $addToSet:
                            # "#{entity.type}":entity.text
                            tags:entity.text.toLowerCase()

                adding_tags = []
                for category in response.categories
                    console.log category.label.split('/')
                    for tag in category.label.split('/')
                        if tag.length > 0 then adding_tags.push tag
                Docs.update { _id: doc_id },
                    $addToSet:
                        tags:$each:adding_tags


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

        )
