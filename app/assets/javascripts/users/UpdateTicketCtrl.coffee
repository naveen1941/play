class UpdateTicketCtrl

  constructor: (@$log, @$location, @$routeParams, @TicketService) ->
      @$log.debug "constructing UpdateTicketController"
      @ticket = {}
      @comments = {}
      @comment={}
      @isAuth()
      @isClosed=false
      @findTicket()
      @listComments()
      @ticket.tokenId=localStorage.getItem 'tokenId'
      @users={}
      @getAllUsers()
      @status =  [{ id: 1, name: 'Open'},{ id: 2, name: 'Assigned'},{id: 3, name: 'Closed'}];
      @userName=localStorage.getItem 'userName'

    
    isAuth: () ->
        if localStorage.getItem 'userId'
            @$log.debug "Authenticated CteateTicketControl"
        else
            @$location.path("/")
            
            
    updateTicket: () ->
      @$log.debug "updateTicket()"
      @ticket.lastUpdatedDate=new Date()
      @TicketService.updateTicket(@$routeParams.ticketId, @ticket)
      .then(
          (data) =>
            @$log.debug "Promise returned #{data} Ticket"
            @ticket = data
            @$location.path("/api")
        ,
        (error) =>
            @$log.error "Unable to update Ticket: #{error}"
      )

    findTicket: () ->
      # route params must be same name as provided in routing url in app.coffee
      ticketId = @$routeParams.ticketId
      @$log.debug "findTicket route params: #{ticketId}"

      @TicketService.listTickets()
      .then(
        (data) =>
          @$log.debug "Promise returned #{data.length} Tickets"
          @ticket = (data.filter (ticket) -> ticket.ticketId is ticketId )[0]
          if @ticket.status == "3"
             @isClosed=true
           else
              @isClosed=false
      ,
        (error) =>
          @$log.error "Unable to get Ticket: #{error}"
      )
      
    listComments: () ->
        ticketId = @$routeParams.ticketId
        @$log.debug "findComments route params: #{ticketId}"
        @TicketService.listComments(ticketId)
        .then(
            (data) =>
              @$log.debug "Promise returned #{data.length} Comments"
              @comments=data
          ,
            (error) =>
              @$log.error "Unable to get Comments: #{error}"
          )
    createComment: () ->
        @$log.debug "createComment()"
        @comment.ticketId=@$routeParams.ticketId
        @comment.commentedDate= new Date()
        @comment.commentedBy=localStorage.getItem 'userId'
        @comment.userName=localStorage.getItem 'userName'
        @comment.tokenId=localStorage.getItem 'tokenId'
        @TicketService.createComment(@comment)
        .then(
            (data) =>
                @$log.debug "Promise returned #{data}"
                comment=@comment.comment
                @comments.push({"comment":comment,"userName":@userName,"userId":localStorage.getItem 'userId'})
                @comment.comment=""
            ,
            (error) =>
                @$log.error "Unable to create Comment: #{error}"
            )
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

controllersModule.controller('UpdateTicketCtrl', UpdateTicketCtrl)