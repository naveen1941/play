
class GlobalCtrl

    constructor: (@$log, @$location, @UserService) ->
        @logMeOut()
    
    logMeOut: () ->
        @$log.debug "logMeOut()"
        localStorage.removeItem 'userName'
        localStorage.removeItem 'userId'
        localStorage.removeItem 'tokenId'
               
controllersModule.controller('GlobalCtrl', GlobalCtrl)