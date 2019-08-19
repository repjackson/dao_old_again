# if Meteor.isClient
#     Template.delta.onCreated ->
#         @autorun -> Meteor.subscribe 'my_delta'
#     Template.delta.helpers
#         current_delta: ->
#             Docs.findOne
#                 model:'delta'
#                 # _author_id:Meteor.userId()
#         sorted_facets: ->
#             current_delta =
#                 Docs.findOne
#                     model:'delta'
#                     # _author_id:Meteor.userId()
#             if current_delta
#                 _.sortBy current_delta.facets,'rank'
#         global_tags: ->
#             doc_count = Docs.find().count()
#             if 0 < doc_count < 3 then Tags.find { count: $lt: doc_count } else Tags.find()
#         single_doc: ->
#             delta = Docs.findOne model:'delta'
#             count = delta.result_ids.length
#             if count is 1 then true else false
#
#
#     Template.delta.events
#         'click .create_delta': (e,t)->
#             Docs.insert
#                 model:'delta'
#         'click .print_delta': (e,t)->
#             delta = Docs.findOne model:'delta'
#             console.log delta
#         'click .reset': ->
#             model_slug =  Router.current().params.model_slug
#             Session.set 'loading', true
#             Meteor.call 'set_facets', model_slug, ->
#                 Session.set 'loading', false
#         'click .delete_delta': (e,t)->
#             delta = Docs.findOne model:'delta'
#             if delta
#                 # if confirm "delete  #{delta._id}?"
#                 Docs.remove delta._id
#         'click .add_model_doc': ->
#             new_doc_id = Docs.insert {}
#             Router.go "/edit/#{new_doc_id}"
#
#         # 'keyup #search': (e)->
#             # switch e.which
#             #     when 13
#             #         if e.target.value is 'clear'
#             #             selected_tags.clear()
#             #             $('#search').val('')
#             #         else
#             #             selected_tags.push e.target.value.toLowerCase().trim()
#             #             $('#search').val('')
#             #     when 8
#             #         if e.target.value is ''
#             #             selected_tags.pop()
#
#
#
#     Template.facet.events
#         'click .toggle_selection': ->
#             delta = Docs.findOne model:'delta'
#             facet = Template.currentData()
#             Session.set 'loading', true
#             if facet.filters and @name in facet.filters
#                 Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
#                     Session.set 'loading', false
#             else
#                 Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->
#                     Session.set 'loading', false
#
#         'keyup .add_filter': (e,t)->
#             if e.which is 13
#                 delta = Docs.findOne model:'delta'
#                 facet = Template.currentData()
#                 if @field_type is 'number'
#                     filter = parseInt t.$('.add_filter').val()
#                 else
#                     filter = t.$('.add_filter').val()
#                 Session.set 'loading', true
#                 Meteor.call 'add_facet_filter', delta._id, facet.key, filter, ->
#                     Session.set 'loading', false
#                 t.$('.add_filter').val('')
#
#
#
#
#     Template.facet.helpers
#         filtering_res: ->
#             delta = Docs.findOne model:'delta'
#             filtering_res = []
#             # @res
#             for filter in @res
#                 if filter.count < delta.total
#                     filtering_res.push filter
#                 else if filter.name in @filters
#                     filtering_res.push filter
#             filtering_res
#
#         toggle_value_class: ->
#             facet = Template.parentData()
#             delta = Docs.findOne model:'delta'
#             if Session.equals 'loading', true
#                  'disabled'
#             else if facet.filters.length > 0 and @name in facet.filters
#                 'active'
#             else ''
#
#     Template.delta_result.onCreated ->
#         @autorun => Meteor.subscribe 'doc', @data._id
#         @autorun => Meteor.subscribe 'user_from_id', @data._id
#
#     Template.delta_result.helpers
#         result: ->
#             if Docs.findOne @_id
#                 result = Docs.findOne @_id
#                 if result.private is true
#                     if result._author_id is Meteor.userId()
#                         result
#                 else
#                     result
#             else if Meteor.users.findOne @_id
#                 Meteor.users.findOne @_id
#
#
#
#     Template.delta_result.events
#         'click .make_reddit': ->
#             Docs.update @_id,
#                 $set:_author_username: 'reddit'
#         'click .make_': ->
#             Docs.update @_id,
#                 $set:_author_username: 'wikipedia'
#         'click .delete_doc': ->
#             Docs.remove @_id
#
# if Meteor.isServer
#     Meteor.publish 'my_delta', ->
#         if Meteor.userId()
#             Docs.find
#                 # _author_id:Meteor.userId()
#                 model:'delta'
#         else
#             Docs.find
#                 _author_id:null
#                 model:'delta'
