'use strict';

angular.module('app.accounts', [])
    .factory('Account', [
        '$http', '$rootScope', 'appApi', function ($http, $rootScope, appApi) {
            var service = {};
            service.Add = Add;
            service.GetAll = GetAll;
            service.Balance = Balance;
            service.Show = Show;
            return service;

            function Balance(id){
                return $http({
                    method: 'GET',
                    url: appApi.path('bank_accounts/'+id+'/balance')
                });
            }

            function Show(id){
                return $http({
                    method: 'GET',
                    url: appApi.path('bank_accounts/'+id)
                });
            }

            function Add(account_data){
                return $http({
                    method: 'POST',
                    url: appApi.path('bank_accounts'),
                    data: account_data
                });
            }

            function GetAll(options){
                return $http({
                    method: 'GET',
                    headers: { 'Content-Type': 'application/json' },
                    url: appApi.path('bank_accounts'),
                });
            }
        }
    ])
    .controller('AccountsController',
        [ '$scope', '$rootScope', '$location', 'Account', function ($scope, $rootScope, $location, Account) {
            $scope.isList = true;
            $scope.balance = {};

            $scope.newAccount =function newAccount() {
                $scope.account = {}
                $scope.isList = false
            };

            $scope.getBalance = function getBalance(id) {
                Account.Balance(id).then(function(res){
                    $scope.balance[id] = res.data.balance || 0;
                })
                    .catch(function(err){
                        var err = err.data || {};
                        $rootScope.message['data'] = err.error_description || 'Something went wrong';
                        $rootScope.message['type'] = 'alert-danger';
                    });
            }

            $scope.listing = function listing() {
                $scope.isList = true
                Account.GetAll().then(function(res){
                    $scope.accounts = res.data.bank_accounts || [];
                })
                    .catch(function(err){
                        var err = err.data || {};
                        $rootScope.message['data'] = err.error_description || 'Something went wrong';
                        $rootScope.message['type'] = 'alert-danger';
                    });
            };

            $scope.crateAccount = function crateAccount() {
                var data = { bank_account: { 'username': $scope.account['username'] } };
                Account.Add(data).then(function(res){
                    $rootScope.message['data'] = 'Account created';
                    $rootScope.message['type'] = 'alert-success';
                    $scope.listing();
                })
                    .catch(function(err){
                        var err = err.data || {};
                        $rootScope.message['data'] = err.error_description || 'Username is blank or Something went wrong';
                        $rootScope.message['type'] = 'alert-danger';
                    });
            };


            $scope.statements = function transactions(id) {
                $location.path('/'+id+'/statements');
            };

            $scope.transactions = function transactions(id) {
                $location.path('/'+id+'/transactions');
            };

            $scope.listing();

        }]
    )