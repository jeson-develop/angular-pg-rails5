'use strict';

angular.module('app.transactions', ['ngRoute'])
    .factory('Transaction', [
        '$http', '$rootScope', 'appApi', function ($http, $rootScope, appApi) {
            var service = {};
            service.GetAll = GetAll;
            service.Create = Create;
            return service;

            function GetAll(id, _data){
                return $http({
                    method: 'GET',
                    url: appApi.path('bank_accounts/'+id+'/transactions'),
                    params: _data
                });
            }

            function Create(id, _data){
                console.log(_data)
                return $http({
                    method: 'POST',
                    url: appApi.path('bank_accounts/'+id+'/transactions'),
                    data: _data
                });
            }
        }
    ])
    .controller('TransactionsController',
        [ '$scope', '$rootScope', '$routeParams', '$location', 'Account', 'Transaction', function ($scope, $rootScope, $routeParams, $location, Account, Transaction) {
            $scope.isReset = true;
            $scope.isWithdraw = false;
            $scope.isDeposit = false;
            $scope.isTransfer = false;
            $scope.accountId = $routeParams.id;

            $scope.accountListing = function accountListing() {
                Account.GetAll({ delete: $scope.accountId, start_date: $scope.start_date, end_date: $scope.end_date }).then(function(res){
                    $scope.accounts = res.data.bank_accounts || [];
                })
                    .catch(function(err){
                        var err = err.data || {};
                        $rootScope.message['data'] = err.error_description || 'Something went wrong';
                        $rootScope.message['type'] = 'alert-danger';
                    });
            };

            $scope.listing = function listing() {
                Transaction.GetAll($scope.accountId,
                    { start_date: $scope.start_date, end_date: $scope.end_date }).then(function(res){
                    $scope.transactions = res.data.transactions || [];
                })
                    .catch(function(err){
                        var err = err.data || {};
                        $rootScope.message['data'] = err.error_description || 'Something went wrong';
                        $rootScope.message['type'] = 'alert-danger';
                    });
            };

            $scope.createTransaction = function createTransaction(state) {
                var _data = { 'amount': $scope.transaction['amount'], state: state, creditor_id: $scope.transaction['creditor_id'] };
                Transaction.Create($scope.accountId, _data).then(function(res){
                    console.debug(res);
                    $rootScope.message['data'] = res.data.message;
                    $rootScope.message['type'] = 'alert-success';
                    $scope.back();
                })
                    .catch(function(err){
                        var err = err.data || {};
                        $rootScope.message['data'] = err.error_description || 'Something went wrong';
                        $rootScope.message['type'] = 'alert-danger';
                    });
            };

            $scope.showAccount = function showAccount() {
                Account.Show($scope.accountId).then(function(res){
                    $scope.account = res.data || {};
                })
                    .catch(function(err){
                        var err = err.data || {};
                        $rootScope.message['data'] = err.error_description || 'Something went wrong';
                        $rootScope.message['type'] = 'alert-danger';
                    });
            }

            $scope.back = function back() {
                $location.path('/');
            };

            $scope.reset = function reset() {
                $scope.transaction = {}

                $scope.isReset = true;
                $scope.isWithdraw = false;
                $scope.isDeposit = false;
                $scope.isTransfer = false;
            };

            $scope.makeWithdraw = function makeWithdraw() {
                $scope.reset()
                $scope.isReset = false;
                $scope.isWithdraw = true;
            };

            $scope.makeDeposit = function makeDeposit() {
                $scope.reset()
                $scope.isReset = false;
                $scope.isDeposit = true;
            };

            $scope.makeTransfer = function makeTransfer() {
                $scope.reset()
                $scope.isReset = false;
                $scope.isTransfer = true;
            };

            $scope.reset();
            $scope.accountListing();
            $scope.listing();
            $scope.showAccount()

        }]
    )