if Meteor.isClient
    Router.route '/t/:tribe_slug/admin/finance', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_finance_nav', {to:'sub_sub_nav'}
        @render 'admin_finance'
        ), name:'admin_finance'

    Router.route '/t/:tribe_slug/admin/finance/summary', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_finance_nav', {to:'sub_sub_nav'}
        @render 'admin_finance_summary'
        ), name:'admin_finance_summary'

    Router.route '/t/:tribe_slug/admin/finance/invoices', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_finance_nav', {to:'sub_sub_nav'}
        @render 'admin_finance_invoices'
        ), name:'admin_finance_invoices'

    Router.route '/t/:tribe_slug/admin/finance/payments_refunds', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_finance_nav', {to:'sub_sub_nav'}
        @render 'admin_finance_payments_refunds'
        ), name:'admin_finance_payments_refunds'

    Router.route '/t/:tribe_slug/admin/finance/reports', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_finance_nav', {to:'sub_sub_nav'}
        @render 'admin_finance_reports'
        ), name:'admin_finance_reports'

    Router.route '/t/:tribe_slug/admin/finance/audit_log', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_finance_nav', {to:'sub_sub_nav'}
        @render 'admin_finance_audit_log'
        ), name:'admin_finance_audit_log'

    Router.route '/t/:tribe_slug/admin/finance/taxes', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_finance_nav', {to:'sub_sub_nav'}
        @render 'admin_finance_taxes'
        ), name:'admin_finance_taxes'

    Router.route '/t/:tribe_slug/admin/finance/tenders', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_finance_nav', {to:'sub_sub_nav'}
        @render 'admin_finance_tenders'
        ), name:'admin_finance_tenders'

    Router.route '/t/:tribe_slug/admin/finance/quickbooks', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_finance_nav', {to:'sub_sub_nav'}
        @render 'admin_finance_quickbooks'
        ), name:'admin_finance_quickbooks'

    Router.route '/t/:tribe_slug/admin/finance/finance_settings', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_finance_nav', {to:'sub_sub_nav'}
        @render 'admin_finance_finance_settings'
        ), name:'admin_finance_finance_settings'



    Template.admin_finance.onCreated ->
        @autorun ->  Meteor.subscribe 'users'
    Template.admin_finance.helpers
        users: -> Meteor.users.find {}
    Template.admin_finance.events
        'click #add_user': ->


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
