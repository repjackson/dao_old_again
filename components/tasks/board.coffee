
if Meteor.isClient
    Template.task_boards.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'task'
    Template.board_view.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'task'
        @autorun => Meteor.subscribe 'model_docs', 'list'
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.task_boards.helpers
        boards: ->
            Docs.find
                model:'task_board'
    Template.task_boards.events
        'click .add_task_board': ->
            Docs.insert
                model:'task_board'


    Template.board_view.events
        'click .add_list': ->
            Docs.insert
                model:'list'
        'click .add_card': ->
            Docs.insert
                model:'task'

    Template.board_view.helpers
        cards: ->
            Docs.find
                model:'task'
        lists: ->
            Docs.find
                model:'list'




    Template.tasks.helpers
        task_stats_doc: ->
            Docs.findOne
                model:'task_stats'
        my_tasks: ->
            Docs.find
                model:'task'
    Template.tasks.events
        'click .calculate_task_stats': ->
            Meteor.call 'calculate_task_stats'

        'click .add_task': ->
            new_id = Docs.insert
                model:'task'
            Router.go "/task/#{new_id}/edit"
