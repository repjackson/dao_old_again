# @selected_tags = new ReactiveArray []
# @selected_usernames = new ReactiveArray []
#
# $.cloudinary.config
#     cloud_name:"facet"
#
# Template.registerHelper 'current_doc', ->
#     doc = Docs.findOne Router.current().params.doc_id
#
# Template.registerHelper 'field_value', () ->
#     # console.log @valueOf()
#     parent = Template.parentData()
#     if @direct
#         parent["#{@key}"]
#
# Accounts.ui.config
#     passwordSignupFields: 'USERNAME_ONLY'
#
# # Template.cloud.onCreated ->
# #     @autorun -> Meteor.subscribe 'me'
#
# # Template.cloud.onCreated ->
# #     @autorun -> Meteor.subscribe('classic_facet', selected_tags.array(),selected_usernames.array())
# #     @autorun -> Meteor.subscribe('docs', selected_tags.array(),selected_usernames.array())
#
#
# Template.doc.events
#     'click .embed': ->
#         $('.ui.embed').embed();
#     'click .delete_doc': ->
#         Docs.remove @_id
#     'blur .new_author': (e,t)->
#         current = Template.currentData()
#         author = t.$('.new_author').val()
#         Docs.update current._id,
#             $set:_author_username: author
#
# Template.change_author.events
#     'click .change_author': ->
#         current = Template.parentData()
#         Docs.update current._id,
#             $set:_author_username: @name
#
#
#
#
# Template.doc.helpers
#     one_doc: ->
#         count = Docs.find({}).count()
#         if count is 1 then true else false
#     last_doc: -> Docs.findOne({})
#
# # Template.cloud.helpers
# #     results: -> Docs.find {},
# #         {
# #             sort:points:-1
# #             limit:1
# #         }
# #     all_tags: ->
# #         doc_count = Docs.find({}).count()
# #         if 0 < doc_count < 3 then Tags.find({count:$lt:doc_count},{limit:42}) else Tags.find({}, limit:42)
# #     cloud_tag_class: ->
# #         button_class = switch
# #             when @index <= 5 then 'large'
# #             when @index <= 12 then ''
# #             when @index <= 20 then 'small'
# #         return button_class
# #     selected_tags: -> selected_tags.array()
# #     all_usernames: ->
# #         doc_count = Usernames.find({}).count()
# #         if 0 < doc_count < 3 then Usernames.find({count:$lt:doc_count},{limit:42}) else Usernames.find({}, limit:42)
# #     cloud_tag_class: ->
# #         button_class = switch
# #             when @index <= 5 then 'large'
# #             when @index <= 12 then ''
# #             when @index <= 20 then 'small'
# #         return button_class
# #     selected_usernames: -> selected_usernames.array()
# #     settings: -> {
# #         position: 'bottom'
# #         limit: 20
# #         noMatchTemplate:'no_match'
# #         rules: [
# #             {
# #                 # token: '#'
# #                 collection: Tags
# #                 field: 'name'
# #                 matchAll: true
# #                 template: Template.tag_result
# #             }
# #             ]
# #     }
# #
# # Template.doc.events
# #     'click .toggle_selection': -> selected_tags.push @valueOf()
# #     'click .unselect_tag': -> selected_tags.remove @valueOf()
# # Template.cloud.events
# #     'click .select_tag': -> selected_tags.push @name
# #     'click .unselect_tag': -> selected_tags.remove @valueOf()
# #     'click #clear_tags': -> selected_tags.clear()
# #
# #     'click .select_username': -> selected_usernames.push @name
# #     'click .unselect_username': -> selected_usernames.remove @valueOf()
# #     'click #clear_usernames': -> selected_usernames.clear()
# #     'click .add_doc': ->
# #         new_doc_id = Docs.insert {}
# #         Router.go "/edit/#{new_doc_id}"
# #
# #     'keyup .import_subreddit': (e,t)->
# #         val = $('.import_subreddit').val().toLowerCase().trim()
# #         if e.which is 13
# #             alert val
# #             Meteor.call 'pull_subreddit', val
# #     'keyup #search': (e,t)->
# #         e.preventDefault()
# #         val = $('#search').val().toLowerCase().trim()
# #         switch e.which
# #             when 13 #enter
# #                 switch val
# #                     when 'clear'
# #                         selected_tags.clear()
# #                         $('#search').val ''
# #                     else
# #                         unless val.length is 0
# #                             selected_tags.push val.toString()
# #                             $('#search').val ''
# #             when 8
# #                 if val.length is 0
# #                     selected_tags.pop()
# #
# #     'autocompleteselect #search': (event, template, doc) ->
# #         selected_tags.push doc.name
# #         $('#search').val ''
# #
#
#
# Template.edit.onCreated ->
#     @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
#
# Template.edit.events
#     'click #delete_doc': ->
#         if confirm 'delete?'
#             Docs.remove Router.current().params.doc_id
#             Router.go "/"
#
#     'click .autotag': ->
#         doc = Docs.findOne Router.current().params.doc_id
#         console.log doc.new_html
#         Meteor.call 'call_watson', doc._id, 'new_html', 'text'
#
#     'keyup .new_site':(e,t)->
#         if e.which is 13
#             doc_id = Router.current().params.doc_id
#             site = t.$('.new_site').val()
#             # console.log site
#             Meteor.call 'pull_site', doc_id, site,->
#             # t.$('.add_comment').val('')
#
#     'click .delete_doc': ->
#         Docs.remove @_id
#
#
# Template.edit.helpers
#     current_doc: ->
#         Docs.findOne Router.current().params.doc_id
#
#     fields: ->
#         Docs.find
#             model:'field_type'
#
# Template.view.onCreated ->
#     @autorun -> Meteor.subscribe 'doc', Router.current().params.doc_id
#
# Template.view.helpers
#     sorted_matches: ->
#         # console.log @
#         sorted_matches = _.sortBy @matches, 'tag_match_count'
#         sorted_matches.reverse()[..2]
#
# Template.view.events
#     'click .calculate': ->
#         Meteor.call 'related_posts', Router.current().params.doc_id
#
# # Template.related_posts.helpers
# #     related_posts: ->
# #         post = DocsfindOne @_id
# #         if post.related_ids
# #             Docs.find
# #                 _id:$in:post.related_ids
#
# Template.doc_match.onCreated ->
#     # console.log @
#     @autorun => Meteor.subscribe 'doc', @data.doc_id
#
# Template.doc_match.events
#     'click .doc_match': ->
#         console.log @
#         Router.go "/view/#{@doc_id}"
#
#
# Template.doc_match.helpers
#     matching_doc: ->
#         # console.log @
#         Docs.findOne @doc_id
#
#     matching_tag_class: ->
#         post = Docs.findOne Router.current().params.doc_id
#         if @valueOf() in post.tags then 'grey' else 'basic'
#         # console.log @
