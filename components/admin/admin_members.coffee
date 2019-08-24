if Meteor.isClient
    Router.route '/t/:tribe_slug/admin/members', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_members_nav', {to:'sub_sub_nav'}
        @render 'admin_members'
        ), name:'admin_members'

    Router.route '/t/:tribe_slug/admin/members/list', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_members_nav', {to:'sub_sub_nav'}
        @render 'admin_members_list'
        ), name:'admin_members_list'

    Router.route '/t/:tribe_slug/admin/members/saved_searches', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_members_nav', {to:'sub_sub_nav'}
        @render 'admin_members_saved_searches'
        ), name:'admin_members_saved_searches'

    Router.route '/t/:tribe_slug/admin/members/levels', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_members_nav', {to:'sub_sub_nav'}
        @render 'admin_members_levels'
        ), name:'admin_members_levels'

    Router.route '/t/:tribe_slug/admin/members/groups', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_members_nav', {to:'sub_sub_nav'}
        @render 'admin_members_groups'
        ), name:'admin_members_groups'

    Router.route '/t/:tribe_slug/admin/members/membership_fields', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_members_nav', {to:'sub_sub_nav'}
        @render 'admin_members_membership_fields'
        ), name:'admin_members_membership_fields'

    Router.route '/t/:tribe_slug/admin/members/member_emails', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_members_nav', {to:'sub_sub_nav'}
        @render 'admin_members_member_emails'
        ), name:'admin_members_member_emails'

    Router.route '/t/:tribe_slug/admin/members/card', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_members_nav', {to:'sub_sub_nav'}
        @render 'admin_members_card'
        ), name:'admin_members_card'

    Router.route '/t/:tribe_slug/admin/members/polls', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_members_nav', {to:'sub_sub_nav'}
        @render 'admin_members_polls'
        ), name:'admin_members_polls'

    Router.route '/t/:tribe_slug/admin/members/other_settings', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_members_nav', {to:'sub_sub_nav'}
        @render 'admin_members_other_settings'
        ), name:'admin_members_other_settings'



    Template.admin_members.onCreated ->
        @autorun ->  Meteor.subscribe 'users'


    Template.admin_members.helpers
        users: -> Meteor.users.find {}


    Template.admin_members.events
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
