Router.route '/restaurants', (->
    @layout 'layout'
    @render 'restaurants'
    ), name:'restaurants'
Router.route '/restaurant/:doc_id/view', (->
    @layout 'layout'
    @render 'restaurant_view'
    ), name:'restaurant_view'
Router.route '/restaurant/:doc_id/edit', (->
    @layout 'layout'
    @render 'restaurant_edit'
    ), name:'restaurant_edit'
Router.route '/kiosk_restaurant_view/:doc_id', (->
    @layout 'layout'
    @render 'kiosk_restaurant_view'
    ), name:'kiosk_restaurant_view'


if Meteor.isClient
    Template.restaurant_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.kiosk_restaurant_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.restaurant_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id

    Template.restaurants.onCreated ->
        @autorun -> Meteor.subscribe 'restaurant_docs', selected_restaurant_tags.array()
        # @autorun -> Meteor.subscribe 'model_docs', 'restaurant'
    Template.restaurants.helpers
        restaurants: ->
            Docs.find {
                model:'restaurant'
            },
                sort: _timestamp: -1
                # limit:7
    Template.restaurant_small.onCreated ->
        @autorun -> Meteor.subscribe 'restaurant_docs', selected_restaurant_tags.array()
        # @autorun -> Meteor.subscribe 'model_docs', 'restaurant'
    Template.restaurant_small.helpers
        restaurants: ->
            Docs.find {
                model:'restaurant'
            },
                sort: _timestamp: -1
                # limit:7
    Template.restaurant_small.events
        'click .log_restaurant_view': ->
            console.log 'hi'
            # Docs.update @_id,
            #     $inc: views: 1


if Meteor.isServer
    Meteor.methods
        calc_restaurant_stats: ->
            restaurant_stat_doc = Docs.findOne(model:'restaurant_stats')
            unless restaurant_stat_doc
                new_id = Docs.insert
                    model:'restaurant_stats'
                restaurant_stat_doc = Docs.findOne(model:'restaurant_stats')
            console.log restaurant_stat_doc
            total_count = Docs.find(model:'restaurant').count()
            complete_count = Docs.find(model:'restaurant', complete:true).count()
            incomplete_count = Docs.find(model:'restaurant', complete:$ne:true).count()
            Docs.update restaurant_stat_doc._id,
                $set:
                    total_count:total_count
                    complete_count:complete_count
                    incomplete_count:incomplete_count
