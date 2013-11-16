window.app = angular.module('multifinderApp', ['multifinderApp.directives', '$strap.directives'])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
