Meteor.methods
    set_facets: (model_slug)->
        delta = Docs.findOne
            model:'delta'
            _author_id:Meteor.userId()
        # model = Docs.findOne
        #     model:'model'
        #     slug:model_slug
        # fields =
        #     Docs.find
        #         model:'field'
        #         parent_id:model._id

        Docs.update delta._id,
            $set:model_filter:model_slug

        # Docs.update delta._id,
        #     $set:facets:[
        #         {
        #             key:'_timestamp_tags'
        #             filters:[]
        #             res:[]
        #         }
        #     ]

        facets = [
            {
                title:'tags'
                icon:'tags'
                key:'tags'
                rank:6
                field_type:'array'
                filters:[]
                res:[]
            }
            # {
            #     title:'_keys'
            #     icon:'key'
            #     key:'_keys'
            #     rank:10
            #     field_type:'array'
            #     filters:[]
            #     res:[]
            # }
            # {
            #     title:'model'
            #     icon:'block'
            #     key:'model'
            #     rank:13
            #     field_type:'array'
            #     filters:[]
            #     res:[]
            # }
        ]

        Docs.update delta._id,
            $set:facets:facets
        # for field in fields.fetch()
        #     unless field.field_type in ['textarea','image','youtube','html']
        #         # unless field.key in ['slug','icon']
        #             if field.faceted is true
        #                 Docs.update delta._id,
        #                     $addToSet:
        #                         facets: {
        #                             title:field.title
        #                             icon:field.icon
        #                             key:field.key
        #                             rank:field.rank
        #                             field_type:field.field_type
        #                             filters:[]
        #                             res:[]
        #                         }
        Meteor.call 'fum', delta._id


    fum: (delta_id)->
        delta = Docs.findOne delta_id
        # model = Docs.findOne
        #     model:'model'
        #     slug:delta.model_filter
        built_query = {}
        #
        # fields =
        #     Docs.find
        #         model:'field'
        #         parent_id:model._id
        # if model.collection and model.collection is 'users'
        #     built_query.roles = $in:[delta.model_filter]
        # else
        #     unless delta.model_filter is 'all'
        #         built_query.model = delta.model_filter

        # if delta.model_filter is 'model'
        #     if Meteor.user()
        #         unless 'dev' in Meteor.user().roles
        #             built_query.view_roles = $in:Meteor.user().roles
        #     else
        #         built_query.view_roles = $in:['user']


        for facet in delta.facets
            if facet.filters.length > 0
                built_query["#{facet.key}"] = $all: facet.filters

        total = Docs.find(built_query).count()
        # if model.collection and model.collection is 'users'
        #     total = Meteor.users.find(built_query).count()
        # else
        #     total = Docs.find(built_query).count()

        # response
        for facet in delta.facets
            values = []
            local_return = []

            agg_res = Meteor.call 'agg', built_query, facet.key
            # agg_res = Meteor.call 'agg', built_query, facet.key

            if agg_res
                Docs.update { _id:delta._id, 'facets.key':facet.key},
                    { $set: 'facets.$.res': agg_res }

        modifier =
            {
                fields:_id:1
                limit:5
                sort:_timestamp:-1
            }

        # results_cursor =
        #     Docs.find( built_query, modifier )

        # if model and model.collection and model.collection is 'users'
        #     results_cursor = Meteor.users.find(built_query, modifier)
        #     # else
        #     #     results_cursor = global["#{model.collection}"].find(built_query, modifier)
        # else
        results_cursor = Docs.find built_query, modifier


        if total < 4
            result_ids = results_cursor.fetch()
        else
            result_ids = []
        result_ids = results_cursor.fetch()


        Docs.update {_id:delta._id},
            {$set:
                total: total
                result_ids:result_ids
            }, ->
        return true
        # delta = Docs.findOne delta_id

    agg: (query, key)->
        limit=42
        options = { explain:false }
        pipe =  [
            { $match: query }
            { $project: "#{key}": 1 }
            { $unwind: "$#{key}" }
            { $group: _id: "$#{key}", count: $sum: 1 }
            { $sort: count: -1, _id: 1 }
            { $limit: limit }
            { $project: _id: 0, name: '$_id', count: 1 }
        ]
        if pipe
            # if collection and collection is 'users'
            #     agg = Meteor.users.rawCollection().aggregate(pipe,options)
            # else
            agg = global['Docs'].rawCollection().aggregate(pipe,options)
            # else
            res = {}
            if agg
                agg.toArray()
        else
            return null
