if Meteor.isClient
    Template.home.onCreated ->
        @autorun -> Meteor.subscribe 'docs', selected_tags.array()
        # @autorun -> Meteor.subscribe 'model_docs', 'restaurant'
    Template.home.helpers
        docs: ->
            Docs.find {
                model:$nin:['role']
            },
                sort: _timestamp: -1
                # limit:7

# if Meteor.isServer
#     Meteor.publish 'docs', (selected_tags)->
#         # user = Meteor.users.findOne @userId
#         console.log selected_tags
#         # console.log filter
#         self = @
#         match = {}
#         if selected_tags.length > 0 then match.tags = $all: selected_tags
#         Docs.find match,
#             limit:10
#             sort:_timestamp:-1
