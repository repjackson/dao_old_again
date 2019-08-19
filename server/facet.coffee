# Meteor.methods
#     set_facets: ()->
#         delta = Docs.findOne
#             model:'delta'
#             _author_id:Meteor.userId()
#
#         Docs.update delta._id,
#             $set:facets:
#                 [
#                     {
#                         key:'tags'
#                         icon:'tags'
#                         filters:[]
#                         res:[]
#                     }
#                     {
#                         key:'_author_username'
#                         icon:'user'
#                         filters:[]
#                         res:[]
#                     }
#                     # {
#                     #     key:'_timestamp_tags'
#                     #     filters:[]
#                     #     res:[]
#                     # }
#                 ]
#         Meteor.call 'fum', delta._id
#
#
#     fum: (delta_id)->
#         delta = Docs.findOne delta_id
#         built_query = {model:$ne:'delta'}
#
#         for facet in delta.facets
#             if facet.filters.length > 0
#                 built_query["#{facet.key}"] = $all: facet.filters
#
#         total = Docs.find(built_query).count()
#
#         # response
#         for facet in delta.facets
#             values = []
#             local_return = []
#
#             # agg_res = Meteor.call 'agg', built_query, facet.key, model.collection
#             agg_res = Meteor.call 'agg', built_query, facet.key
#
#             if agg_res
#                 Docs.update { _id:delta._id, 'facets.key':facet.key},
#                     { $set: 'facets.$.res': agg_res }
#
#         modifier =
#             {
#                 fields:_id:1
#                 limit:3
#                 sort:_timestamp:-1
#             }
#
#         # results_cursor =
#         #     Docs.find( built_query, modifier )
#
#         results_cursor = Docs.find built_query, modifier
#
#
#         # if total is 1
#         #     result_ids = results_cursor.fetch()
#         # else
#         #     result_ids = []
#         result_ids = results_cursor.fetch()
#
#
#         Docs.update {_id:delta._id},
#             {$set:
#                 total: total
#                 result_ids:result_ids
#             }, ->
#         return true
#
#
#         # delta = Docs.findOne delta_id
#
#     agg: (query, key)->
#         limit=100
#         options = { explain:false }
#         pipe =  [
#             { $match: query }
#             { $project: "#{key}": 1 }
#             { $unwind: "$#{key}" }
#             { $group: _id: "$#{key}", count: $sum: 1 }
#             { $sort: count: -1, _id: 1 }
#             { $limit: limit }
#             { $project: _id: 0, name: '$_id', count: 1 }
#         ]
#         if pipe
#             agg = global['Docs'].rawCollection().aggregate(pipe,options)
#             # else
#             res = {}
#             if agg
#                 agg.toArray()
#         else
#             return null
