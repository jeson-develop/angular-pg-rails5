var app = angular.module('app').config( [ '$controllerProvider', '$compileProvider', '$filterProvider', '$provide', '$httpProvider',
  function($controllerProvider, $compileProvider, $filterProvider, $provide, $httpProvider) {
    app.controller = $controllerProvider.register;
    app.directive = $compileProvider.directive;
    app.filter = $filterProvider.register;
    app.factory = $provide.factory;
    app.service = $provide.service;
    app.constant = $provide.constant;
    app.value = $provide.value;

    $httpProvider.defaults.useXDomain = true;
    delete $httpProvider.defaults.headers.common["X-Requested-With"];
    $httpProvider.defaults.headers.common["Accept"] = "application/json";
    $httpProvider.defaults.headers.common["Content-Type"] = "application/json";
  }
]);

var config = {
  "DOMAIN": 'http://localhost:3000',
  "VERSION": 'v1'
}

if(window.location.hostname != 'localhost') {
  config["DOMAIN"] = 'http://chillout-development.7jvxkzehdu.ap-southeast-1.elasticbeanstalk.com'
}

app.constant("API", config);

app.service('appApi', function (API) {
  this.path = function(path) {
      return '/api/' + API.VERSION + '/' + path;
  }
});