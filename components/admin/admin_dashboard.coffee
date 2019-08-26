if Meteor.isClient
    Router.route '/t/:tribe_slug/admin/dashboard', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_dashboard_nav', {to:'sub_sub_nav'}
        @render 'admin_dashboard'
        ), name:'admin_dashboard'

    Router.route '/t/:tribe_slug/admin/dashboard/summary', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_dashboard_nav', {to:'sub_sub_nav'}
        @render 'admin_dashboard_summary'
        ), name:'admin_dashboard_summary'

    Router.route '/t/:tribe_slug/admin/dashboard/account', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_dashboard_nav', {to:'sub_sub_nav'}
        @render 'admin_dashboard_account'
        ), name:'admin_dashboard_account'

    Router.route '/t/:tribe_slug/admin/dashboard/organization', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_dashboard_nav', {to:'sub_sub_nav'}
        @render 'admin_dashboard_organization'
        ), name:'admin_dashboard_organization'

    Router.route '/t/:tribe_slug/admin/dashboard/referrals', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_dashboard_nav', {to:'sub_sub_nav'}
        @render 'admin_dashboard_referrals'
        ), name:'admin_dashboard_referrals'

    Router.route '/t/:tribe_slug/admin/dashboard/getting_started', (->
        @layout 'tribe_edit_layout'
        @render 'tribe_edit_nav', {to:'sub_nav'}
        @render 'te_dashboard_nav', {to:'sub_sub_nav'}
        @render 'admin_dashboard_getting_started'
        ), name:'admin_dashboard_getting_started'

    Template.admin_dashboard.onCreated ->
        @autorun => Meteor.subscribe 'tribe_docs', Router.current().params.tribe_slug, 'donation'
        @autorun => Meteor.subscribe 'tribe_stats_doc', Router.current().params.tribe_slug

    Template.admin_dashboard.events
        'click .add_donation': ->
            Docs.insert
                tribe_slug:Router.current().params.tribe_slug
                model:'donation'
        'click .set_donation': ->
            Session.set 'current_donation', @_id

        'click .calculate_tribe_stats': ->
            Meteor.call 'calculate_tribe_stats', Router.current().params.tribe_slug


    Template.admin_dashboard.helpers
        dashboard: ->
            Docs.find
                tribe_slug:Router.current().params.tribe_slug
                model:'donation'

        tribe_stats_doc: ->
            Docs.findOne
                model:'tribe_stats'

        donation_menu_item_class: ->
            console.log @_id
            console.log Session.get('current_donation')
            if Session.equals(@_id, Session.get('current_donation'))
                console.log 'this is active'
                return 'active'
            else ''


if Meteor.isServer
    Meteor.publish 'tribe_stats_doc', (tribe_slug)->
        Docs.find(
            model:'tribe_stats'
            tribe_slug:tribe_slug
            )


    Meteor.methods
        calculate_tribe_stats: (tribe_slug)->
            tribe_doc =
                Docs.findOne
                    model:'tribe'
                    slug:tribe_slug
            tribe_stat_doc = Docs.findOne(
                model:'tribe_stats'
                tribe_slug:tribe_slug
                )
            unless tribe_stat_doc
                new_id = Docs.insert
                    model:'tribe_stats'
                    tribe_slug:tribe_slug
                tribe_stat_doc = Docs.findOne(
                    model:'tribe_stats'
                    tribe_slug:tribe_slug
                    )
            console.log tribe_stat_doc
            post_count = Docs.find(
                model:'post'
                tribe_slug:tribe_slug
                ).count()
            event_count = Docs.find(
                model:'event'
                tribe_slug:tribe_slug
                ).count()
            products_count = Docs.find(
                model:'product'
                tribe_slug:tribe_slug
                ).count()
            task_count = Docs.find(
                model:'task'
                tribe_slug:tribe_slug
                ).count()
            page_count = Docs.find(
                model:'page'
                tribe_slug:tribe_slug
                ).count()
            model_count = Docs.find(
                model:'page'
                tribe_slug:tribe_slug
                ).count()
            doc_count = Docs.find(
                tribe_slug:tribe_slug
                ).count()
            course_count = Docs.find(
                model:'course'
                tribe_slug:tribe_slug
                ).count()
            chat_count = Docs.find(
                model:'chat'
                tribe_slug:tribe_slug
                ).count()
            Docs.update tribe_doc._id,
                $set:
                    post_count:post_count
                    event_count:event_count
                    task_count:task_count
                    page_count:page_count
                    model_count:model_count
                    course_count:course_count
                    chat_count:chat_count
                    products_count:products_count
                    doc_count:doc_count
