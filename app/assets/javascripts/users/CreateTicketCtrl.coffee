
class CreateTicketCtrl

    constructor: (@$log, @$location,  @TicketService) ->
        @$log.debug "constructing CreateTicketController"
        @ticket = {}
        @status =  [{ id: 1, name: 'Open'},{ id: 2, name: 'Assigned'},{id: 3, name: 'Closed'}];
        @users={}
        @isAuth()
        @getAllUsers()
        @userName=localStorage.getItem 'userName'
    
    isAuth: () ->
        if localStorage.getItem 'userId'
            @$log.debug "Authenticated CteateTicketControl"
        else
            @$location.path("/")
    
    createTicket: () ->
        @$log.debug "createTicket()"
        @ticket.ticketId=uniqueId(20)
        @ticket.createdBy=localStorage.getItem 'userId'
        @ticket.lastUpdatedBy=localStorage.getItem 'userId'
        @ticket.userName=localStorage.getItem 'userName'
        @ticket.createdDate= new Date()
        @ticket.active= true
        @ticket.lastUpdatedDate=new Date()
        @ticket.tokenId=localStorage.getItem 'tokenId'
        @TicketService.createTicket(@ticket)
        .then(
            (data) =>
                @$log.debug "Promise returned #{data} Ticket"
                @ticket = data
                @$location.path("/api")
            ,
            (error) =>
                @$log.error "Unable to create Ticket: #{error}"
            )
    uniqueId = (length=8) ->
          id = ""
          id += Math.random().toString(36).substr(2) while id.length < length
          id.substr 0, length
    
    getAllUsers: () ->
        @$log.debug "getAllUsers()"
        @TicketService.listAllUsers()
        .then(
            (data) =>
                @$log.debug "Promise returned #{data.length} Users"
                @users = data
            ,
            (error) =>
                @$log.error "Unable to get Users: #{error}"
            )


controllersModule.controller('CreateTicketCtrl', CreateTicketCtrl)