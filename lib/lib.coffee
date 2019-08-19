@Docs = new Meteor.Collection 'docs'
@Tags = new Meteor.Collection 'tags'
@Usernames = new Meteor.Collection 'usernames'
Router.configure
    layoutTemplate: 'layout'
    notFoundTemplate: 'not_found'


# Router.route '/edit/:doc_id', -> @render 'edit'
# Router.route '/view/:doc_id', -> @render 'view'
#
# Router.route '/', (->
#     @layout 'layout'
#     @render 'cloud'
#     ), name:'front'


Docs.before.insert (userId, doc)->
    timestamp = Date.now()
    doc._author_id = Meteor.userId()
    doc._author_username = Meteor.user().username
    doc._timestamp = timestamp
    doc._timestamp_long = moment(timestamp).format("dddd, MMMM Do YYYY, h:mm:ss a")
    date = moment(timestamp).format('Do')
    weekdaynum = moment(timestamp).isoWeekday()
    weekday = moment().isoWeekday(weekdaynum).format('dddd')

    hour = moment(timestamp).format('h')
    minute = moment(timestamp).format('m')
    ap = moment(timestamp).format('a')
    month = moment(timestamp).format('MMMM')
    year = moment(timestamp).format('YYYY')

    date_array = [ap, "hour #{hour}", "min #{minute}", weekday, month, date, year]
    if _
        date_array = _.map(date_array, (el)-> el.toString().toLowerCase())
    # date_array = _.each(date_array, (el)-> console.log(typeof el))
    # console.log date_array
        doc._timestamp_tags = date_array
    return


Meteor.methods
    add_facet_filter: (delta_id, key, filter)->
        Docs.update { _id:delta_id, "facets.key":key},
            $addToSet: "facets.$.filters": filter
        Meteor.call 'fum', delta_id, (err,res)->


    remove_facet_filter: (delta_id, key, filter)->
        Docs.update { _id:delta_id, "facets.key":key},
            $pull: "facets.$.filters": filter
        Meteor.call 'fum', delta_id, (err,res)->
