// Meteor.startup(function () {
//   if(Meteor.isClient) {
//     //This code is needed to detect if there is a subdomain. So the system wants to know the routes of the subdomain
//     var hostnameArray = document.location.hostname.split( "." );
//     if(hostnameArray.length >= 3)   {
//         var subdomain = hostnameArray[0].toLowerCase().ucfirst();
//         var defineFunctionString = "define" + subdomain + "Routes";
//
//         if (typeof window[defineFunctionString] === "function") {
//           Meteor['is'+ subdomain] = true;
//           window[defineFunctionString](); //To call the function dynamically!
//         }
//       }
//       // else {
//       //   defineRoutes();
//       // }
//     }
// });
