
class UserCtrl

    constructor: (@$log, @$location, @UserService) ->
        @$log.debug "constructing UserController"
        @user={}
        @errors={}
        @currentUserName=""
        @currentUserId=""
        @loginStatus=""
        @isAuth()
    
    isAuth: () ->
        if localStorage.getItem 'userId'
            @$location.path("/api")
    
    authenticateMe: () ->
        @$log.debug "authenticateMe()"
        @UserService.listUsers(@user)
        .then(
            (data) =>
                @$log.debug "Promise returned #{data.length} Users"
                if data.tokenId
                    localStorage.setItem 'tokenId',  data.tokenId
                    localStorage.setItem 'userName', data.userName
                    @currentUserName=data.userName
                    @currentUserId=data.userId
                    @loginStatus="LoggedIn"
                    localStorage.setItem 'userId',   data.userId
                    @$location.path("/api")
                else
                    @errors.message=data
            ,
            (error) =>
                @$log.error "Unable to authenticate: #{error}"
            )
controllersModule.controller('UserCtrl', UserCtrl)