Router.route '/dev', -> @render 'dev'


if Meteor.isClient
    Template.dev.events
        'keyup .method_name': (e,t)->
            if e.which is 13
                name = $('.method_name').val()
                Meteor.call name
