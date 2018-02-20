'use strict';

angular.module('app.errors', [])
    .controller('ErrorsController',
        [ '$scope', '$rootScope', '$location', function ($scope, $rootScope, $location) {
            $rootScope.location = $location.path()
            if (!$rootScope.message || $rootScope.location != $location.path()) {
                $rootScope.message = {}
            }
        }]
    )