
class CreateUserCtrl

    constructor: (@$log, @$location,  @UserService) ->
        @$log.debug "constructing CreateUserController"
        @user = {}
        @errors={}

    createUser: () ->
        @$log.debug "createUser()"
        @user.userId=uniqueId(20)
        @user.active = true
        @user.tokenId="DEFAULT_TOKEN_ID"
        @UserService.createUser(@user)
        .then(
            (data) =>
                @$log.debug "Promise returned #{data} User"
                @$log.debug "After create User #{data.tokenId} User"
                localStorage.setItem 'tokenId', data.tokenId
                @user = data
                @$location.path("/")
            ,
            (error) =>
                @$log.error "Unable to create User: #{error}"
            )
            
    validateForm: () ->
        if @user.password1 == @user.password2
            @errors.passwordDonotMatch=""
        else
            @errors.passwordDonotMatch="Passwords Don't Match." 
        
    uniqueId = (length=8) ->
          id = ""
          id += Math.random().toString(36).substr(2) while id.length < length
          id.substr 0, length   

controllersModule.controller('CreateUserCtrl', CreateUserCtrl)