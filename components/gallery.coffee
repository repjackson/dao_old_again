# Router.route '/tasks', -> @render 'tasks'
Router.route '/t/:tribe_slug/gallery/', -> @render 'gallery_view'
Router.route '/t/:tribe_slug/picture/:doc_id/view', -> @render 'picture_view'
Router.route '/t/:tribe_slug/picture/:doc_id/edit', -> @render 'picture_edit'


if Meteor.isClient
    Template.gallery.onCreated ->
        @autorun => Meteor.subscribe 'tribe_by_slug', Router.current().params.tribe_slug
        @autorun => Meteor.subscribe 'docs', selected_tags.array(), Router.current().params.tribe_slug, 'picture'

    Template.picture_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.picture_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
    Template.gallery.helpers
        pictures: ->
            Docs.find
                model:'picture'
    Template.gallery.events
        'click .add_picture': ->
            tribe_slug = Router.current().params.tribe_slug
            new_id = Docs.insert
                model:'picture'
                tribe_slug:tribe_slug
            Router.go "/t/#{tribe_slug}/picture/#{new_id}/edit"
