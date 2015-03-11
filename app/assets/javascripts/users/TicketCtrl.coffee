
class TicketCtrl
    constructor: (@$log,@$location, @TicketService) ->
        @$log.debug "constructing TicketController"
        @tickets = []
        @userName=""
        @isAuth()
        @getAllTickets()
        @orderByField = 'createdDate'
        @reverseSort = false

    isAuth: () ->
        if localStorage.getItem 'userId'
            @userName=localStorage.getItem 'userName'
            @$log.debug "Authenticated CteateTicketControl"
        else
            @$location.path("/logout")
    getAllTickets: () ->
        @$log.debug "getAllTickets()"
        @TicketService.listTickets(localStorage.getItem 'tokenId')
        .then(
            (data) =>
                @$log.debug "Promise returned #{data.length} Tickets"
                @tickets = data
            ,
            (error) =>
                @$log.error "Unable to get Tickets: #{error}"
            )

controllersModule.controller('TicketCtrl', TicketCtrl)