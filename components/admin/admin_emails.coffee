if Meteor.isClient
    Router.route '/t/:tribe_slug/admin/emails', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_emails_nav', {to:'sub_sub_nav'}
        @render 'admin_emails'
        ), name:'admin_emails'

    Router.route '/t/:tribe_slug/admin/emails/summary', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_emails_nav', {to:'sub_sub_nav'}
        @render 'admin_emails_summary'
        ), name:'admin_emails_summary'

    Router.route '/t/:tribe_slug/admin/emails/list', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_emails_nav', {to:'sub_sub_nav'}
        @render 'admin_emails_list'
        ), name:'admin_emails_list'

    Router.route '/t/:tribe_slug/admin/emails/templates', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_emails_nav', {to:'sub_sub_nav'}
        @render 'admin_emails_templates'
        ), name:'admin_emails_templates'

    Router.route '/t/:tribe_slug/admin/emails/log', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_emails_nav', {to:'sub_sub_nav'}
        @render 'admin_emails_log'
        ), name:'admin_emails_log'

    Router.route '/t/:tribe_slug/admin/emails/settings', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_emails_nav', {to:'sub_sub_nav'}
        @render 'admin_emails_settings'
        ), name:'admin_emails_settings'


    # Template.article_list.onCreated ->
    #     @autorun ->  Meteor.subscribe 'type', 'article'
    # Template.article_list.helpers
    #     articles: ->
    #         Docs.find
    #             model:'article'
    # Template.article_list.events
    #     'click .add_article': ->
    #         Docs.insert
    #             model:'article'
    #     'click .delete_article': ->
    #         if confirm 'Delete article?'
    #             Docs.remove @_id
