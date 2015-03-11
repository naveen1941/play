class UserDetailCtrl

  constructor: (@$log, @$location, @$routeParams, @UserService) ->
      @$log.debug "constructing UserDetailCtrl"
      @users = []
      @isAuth()
      @findUser()
    
    
    isAuth: () ->
        if localStorage.getItem 'userId'
            @$log.debug "Authenticated CteateTicketControl"
        else
            @$location.path("/")
  
    findUser: () ->
      userId = @$routeParams.userId
      @$log.debug "findUser route params: #{userId}"
      @UserService.listUserById(userId)
      .then(
        (data) =>
          @$log.debug "Promise returned #{data.length} Users"
          @$log.debug "Promise returned #{data} Users"
          @users = data
      ,
        (error) =>
          @$log.error "Unable to get Users: #{error}"
      )

controllersModule.controller('UserDetailCtrl', UserDetailCtrl)