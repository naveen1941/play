
class TicketService

    @headers = {'Accept': 'application/json', 'Content-Type': 'application/json'}
    @defaultConfig = { headers: @headers }

    constructor: (@$log, @$http, @$q) ->
        @$log.debug "constructing TicketService"

    listTickets: (tokenId) ->
        @$log.debug "listTickets()"
        deferred = @$q.defer()
        @$http.get("/api/tickets/#{tokenId}")
        .success((data, status, headers) =>
                @$log.info("Successfully listed Tickets - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to list Tickets - status #{status}")
                deferred.reject(data)
            )
        deferred.promise
        
    listAllUsers: () ->
        @$log.debug "listAllUsers()"
        deferred = @$q.defer()
        @$http.get("/users")
        .success((data, status, headers) =>
                @$log.info("Successfully listed Users - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to list Users - status #{status}")
                deferred.reject(data)
            )
        deferred.promise
        
    listComments: (ticketId) ->
        @$log.debug "listComments()"
        deferred = @$q.defer()

        @$http.get("/api/comments/#{ticketId}")
        .success((data, status, headers) =>
                @$log.info("Successfully listed Comments - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to list Comments - status #{status}")
                deferred.reject(data)
            )
        deferred.promise
        
    createComment: (comment) ->
        @$log.debug "createComment #{angular.toJson(comment, true)}"
        deferred = @$q.defer()

        @$http.post('/api/comment', comment)
        .success((data, status, headers) =>
                @$log.info("Successfully created Comment - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to create Comment - status #{status}")
                deferred.reject(data)
            )
        deferred.promise

    createTicket: (ticket) ->
        @$log.debug "createTicket #{angular.toJson(ticket, true)}"
        deferred = @$q.defer()

        @$http.post('/api/ticket', ticket)
        .success((data, status, headers) =>
                @$log.info("Successfully created Ticket - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to create ticket - status #{status}")
                deferred.reject(data)
            )
        deferred.promise

    updateTicket: (ticketId, ticket) ->
      @$log.debug "updateTicket #{angular.toJson(ticket, true)}"
      deferred = @$q.defer()

      @$http.put("/api/ticket/#{ticketId}", ticket)
      .success((data, status, headers) =>
              @$log.info("Successfully updated Ticket - status #{status}")
              deferred.resolve(data)
            )
      .error((data, status, header) =>
              @$log.error("Failed to update ticket - status #{status}")
              deferred.reject(data)
            )
      deferred.promise

servicesModule.service('TicketService', TicketService)