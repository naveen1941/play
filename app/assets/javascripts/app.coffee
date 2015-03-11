
dependencies = [
    'ngRoute',
    'ui.bootstrap',
    'myApp.filters',
    'myApp.services',
    'myApp.controllers',
    'myApp.directives',
    'myApp.common',
    'myApp.routeConfig'
]

app = angular.module('myApp', dependencies)
angular.module('myApp.routeConfig', ['ngRoute'])
    .config ($routeProvider) ->
        $routeProvider
            .when('/', {
                templateUrl: '/assets/partials/view.html'
            })
            .when('/users/create', {
                templateUrl: '/assets/partials/create.html'
            })
            .when('/users/:userId', {
                templateUrl: '/assets/partials/user_detail.html'
            })
            .when('/api', {
                templateUrl: '/assets/partials/view_tickets.html'
              })
            .when('/logout', {
                templateUrl: '/assets/partials/logout.html'
            })
            .when('/tickets/create', {
                templateUrl: '/assets/partials/create_ticket.html'
              })
            .when('/tickets/edit/:ticketId', {
                templateUrl: '/assets/partials/update_ticket.html'
              })
            .otherwise({redirectTo: '/'})
    .config ($locationProvider) ->
        $locationProvider.html5Mode({
            enabled: true,
            requireBase: false
        })

@commonModule = angular.module('myApp.common', [])
@controllersModule = angular.module('myApp.controllers', [])
@servicesModule = angular.module('myApp.services', [])
@modelsModule = angular.module('myApp.models', [])
@directivesModule = angular.module('myApp.directives', [])
@filtersModule = angular.module('myApp.filters', [])