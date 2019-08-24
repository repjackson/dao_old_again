if Meteor.isClient
    Router.route '/t/:tribe_slug/admin/store', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_store_nav', {to:'sub_sub_nav'}
        @render 'admin_store'
        ), name:'admin_store'

    Router.route '/t/:tribe_slug/admin/store/orders', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_store_nav', {to:'sub_sub_nav'}
        @render 'admin_store_orders'
        ), name:'admin_store_orders'

    Router.route '/t/:tribe_slug/admin/store/products', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_store_nav', {to:'sub_sub_nav'}
        @render 'admin_store_products'
        ), name:'admin_store_products'

    Router.route '/t/:tribe_slug/admin/store/delivery', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_store_nav', {to:'sub_sub_nav'}
        @render 'admin_store_delivery'
        ), name:'admin_store_delivery'

    Router.route '/t/:tribe_slug/admin/store/settings', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_store_nav', {to:'sub_sub_nav'}
        @render 'admin_store_settings'
        ), name:'admin_store_settings'



    Template.admin_store.onCreated ->
        @autorun ->  Meteor.subscribe 'users'


    Template.admin_store.helpers
        users: -> Meteor.users.find {}


    Template.admin_store.events
        'click #add_user': ->

    Template.user_role_toggle.helpers
        is_in_role: ->
            Template.parentData().roles and @role in Template.parentData().roles

    Template.user_role_toggle.events
        'click .add_role': ->
            parent_user = Template.parentData()
            Meteor.users.update parent_user._id,
                $addToSet:roles:@role

        'click .remove_role': ->
            parent_user = Template.parentData()
            Meteor.users.update parent_user._id,
                $pull:roles:@role



    # Template.article_list.onCreated ->
    #     @autorun ->  Meteor.subscribe 'type', 'article'
    #
    #
    # Template.article_list.helpers
    #     articles: ->
    #         Docs.find
    #             model:'article'
    #
    # Template.article_list.events
    #     'click .add_article': ->
    #         Docs.insert
    #             model:'article'
    #
    #     'click .delete_article': ->
    #         if confirm 'Delete article?'
    #             Docs.remove @_id
