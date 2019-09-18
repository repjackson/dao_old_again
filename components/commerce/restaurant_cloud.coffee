# if Meteor.isClient
#     Template.restaurant_cloud.onCreated ->
#         @autorun -> Meteor.subscribe('restaurant_tags', selected_restaurant_tags.array())
#
#     Template.restaurant_cloud.helpers
#         all_restaurant_tags: ->
#             restaurant_count = Docs.find(model:'restaurant').count()
#             if 0 < restaurant_count < 3 then Restaurant_tags.find { count: $lt: restaurant_count } else Restaurant_tags.find({},{limit:42})
#         # cloud_tag_class: ->
#         #     button_class = switch
#         #         when @index <= 5 then 'large'
#         #         when @index <= 12 then ''
#         #         when @index <= 20 then 'small'
#         #     return button_class
#         selected_restaurant_tags: -> selected_restaurant_tags.array()
#         # settings: -> {
#         #     position: 'bottom'
#         #     limit: 10
#         #     rules: [
#         #         {
#         #             collection: Restaurant_tags
#         #             field: 'name'
#         #             matchAll: true
#         #             template: Template.tag_result
#         #         }
#         #     ]
#         # }
#
#
#     Template.restaurant_cloud.events
#         'click .select_restaurant_tag': -> selected_restaurant_tags.push @name
#         'click .unselect_restaurant_tag': -> selected_restaurant_tags.remove @valueOf()
#         'click #clear_tags': -> selected_restaurant_tags.clear()
#
#         # 'keyup #search': (e,t)->
#         #     e.preventDefault()
#         #     val = $('#search').val().toLowerCase().trim()
#         #     switch e.which
#         #         when 13 #enter
#         #             switch val
#         #                 when 'clear'
#         #                     selected_restaurant_tags.clear()
#         #                     $('#search').val ''
#         #                 else
#         #                     unless val.length is 0
#         #                         selected_restaurant_tags.push val.toString()
#         #                         $('#search').val ''
#         #         when 8
#         #             if val.length is 0
#         #                 selected_restaurant_tags.pop()
#         #
#         # 'autocompleteselect #search': (event, template, doc) ->
#         #     selected_restaurant_tags.push doc.name
#         #     $('#search').val ''
#
#
# if Meteor.isServer
#     Meteor.publish 'restaurant_tags', (selected_restaurant_tags)->
#         # user = Meteor.users.finPdOne @userId
#         # current_herd = user.profile.current_herd
#
#         self = @
#         match = {}
#
#         # selected_restaurant_tags.push current_herd
#
#         if selected_restaurant_tags.length > 0 then match.tags = $all: selected_restaurant_tags
#         # match.model = 'restaurant'
#         cloud = Docs.aggregate [
#             { $match: match }
#             { $project: tags: 1 }
#             { $unwind: "$tags" }
#             { $group: _id: '$tags', count: $sum: 1 }
#             { $match: _id: $nin: selected_restaurant_tags }
#             { $sort: count: -1, _id: 1 }
#             { $limit: 42 }
#             { $project: _id: 0, name: '$_id', count: 1 }
#             ]
#
#         cloud.forEach (tag, i) ->
#             self.added 'restaurant_tags', Random.id(),
#                 name: tag.name
#                 count: tag.count
#                 index: i
#
#         self.ready()
#
#
#     Meteor.publish 'restaurant_docs', (selected_restaurant_tags)->
#         # user = Meteor.users.findOne @userId
#         console.log selected_restaurant_tags
#         # console.log filter
#         self = @
#         match = {}
#         # if filter is 'shop'
#         #     match.active = true
#         if selected_restaurant_tags.length > 0 then match.tags = $all: selected_restaurant_tags
#         # match.model = 'restaurant'
#         Docs.find match, sort:_timestamp:-1
