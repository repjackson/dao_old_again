Router.configure
    layoutTemplate: 'layout'
    notFoundTemplate: 'not_found'
    loadingTemplate: 'splash'
    trackPageView: true

force_loggedin =  ()->
    if !Meteor.userId()
        @render 'login'
    else
        @next()

# Router.onBeforeAction(force_loggedin, {
#   # only: ['admin']
#   # except: ['register', 'forgot_password','reset_password','front','delta','doc_view','verify-email']
#   except: ['register','forgot_password','reset_password','delta','doc_view','verify-email','home','front','shop','events']
# });

Router.route '/register', -> @render 'register'

Router.route '/m/:model_slug', (->
    @render 'delta'
    ), name:'delta'
Router.route '/m/:model_slug/:doc_id/edit', -> @render 'model_doc_edit'
Router.route '/m/:model_slug/:doc_id/view', (->
    @render 'model_doc_view'
    ), name:'doc_view'
Router.route '/model/edit/:doc_id', -> @render 'model_edit'


Router.route '/edit/:doc_id', -> @render 'edit'
Router.route '/view/:doc_id', -> @render 'view'


# Router.route '/user/:username', -> @render 'user'
# Router.route '/user/:username/m/:type', -> @render 'profile_layout', 'user_section'
Router.route '/forgot_password', -> @render 'forgot_password'

Router.route '/user/:username/edit', -> @render 'user_edit'
Router.route '/p/:slug', -> @render 'page'
# Router.route "/meal/:meal_id", -> @render 'meal_doc'

Router.route '/reset_password/:token', (->
    @render 'reset_password'
    ), name:'reset_password'


Router.route '/login', -> @render 'login'

# Router.route '/', -> @redirect '/m/model'
# Router.route '/', -> @redirect "/user/#{Meteor.user().username}"
Router.route '/home', -> @render 'home'

Router.route '/', (->
    @layout 'layout'
    @render 'cloud'
    ), name:'front'
