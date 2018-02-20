'use strict';
angular.module('app').
  config(['$locationProvider', '$routeProvider', function($locationProvider, $routeProvider) {
    // $locationProvider.html5Mode({
    //    enabled: true,
    //    requireBase: false
    //  });
    $routeProvider.otherwise({redirectTo: '/'});

     $routeProvider
       .when("/", {
           templateUrl : "assets/ng_app/accounts/list.html"
       })
       .when("/:id/transactions", {
           templateUrl : "assets/ng_app/transactions/make.html"
       })
       .when("/:id/statements", {
           templateUrl : "assets/ng_app/transactions/list.html"
       })
   }]);

