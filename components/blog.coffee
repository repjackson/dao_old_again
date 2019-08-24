# Router.route '/tasks', -> @render 'tasks'
Router.route '/t/:tribe_slug/blog/', -> @render 'blog_view'
Router.route '/post/:doc_id/view', -> @render 'post_view'
Router.route '/post/:doc_id/edit', -> @render 'post_edit'


if Meteor.isClient
    Template.blog.onCreated ->
        # @autorun => Meteor.subscribe 'tribe_docs', Router.current().params.tribe_slug, 'post'
        @autorun => Meteor.subscribe 'docs', selected_tags.array(), Router.current().params.tribe_slug, 'post'

    Template.post_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.post_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.blog.helpers
        posts: ->
            Docs.find
                model:'post'
    Template.blog.events
        'click .add_post': ->
            new_id = Docs.insert
                model:'post'
                tribe_slug:Router.current().params.tribe_slug
            Router.go "/post/#{new_id}/edit"