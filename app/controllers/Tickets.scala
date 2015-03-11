package controllers

import play.modules.reactivemongo.MongoController
import play.modules.reactivemongo.json.collection.JSONCollection
import scala.concurrent.Future
import reactivemongo.api.Cursor
import play.api.libs.concurrent.Execution.Implicits.defaultContext
import org.slf4j.{LoggerFactory, Logger}
import javax.inject.Singleton
import play.api.mvc._
import play.api.libs.json._



@Singleton
class Tickets extends Controller with MongoController {

  private final val logger: Logger = LoggerFactory.getLogger(classOf[Tickets])


  def collection: JSONCollection = db.collection[JSONCollection]("tickets")
  def user_collection: JSONCollection = db.collection[JSONCollection]("users")

  import models._
  import models.JsonFormats._

  var isAuthenticatedBool=false
  
  def createTicket = Action.async(parse.json) {
    request =>
        var tokenId="DEFAULT_TOKEN_ID"
        (request.body \ "tokenId").asOpt[String].map { token =>
            tokenId=token
        }
        request.body.validate[Ticket].map {
        ticket =>
              collection.insert(ticket).map {
                lastError =>
                  logger.debug(s"Successfully inserted with LastError: $lastError")
                  Created(s"Ticket Created")
              }
        }.getOrElse(Future.successful(BadRequest("invalid json")))
        
  }
  
   def updateTicket(ticketId: String) = Action.async(parse.json) {
    request =>
        var tokenId="DEFAULT_TOKEN_ID"
        (request.body \ "tokenId").asOpt[String].map { token =>
            tokenId=token
        }
        request.body.validate[Ticket].map {
            ticket =>
              // find our user by first name and last name
              val nameSelector = Json.obj("ticketId" -> ticketId)
              collection.update(nameSelector, ticket).map {
                lastError =>
                  logger.debug(s"Successfully updated with LastError: $lastError")
                  Created(s"Ticket Updated")
              }
          }.getOrElse(Future.successful(BadRequest("invalid json")))
  }
  
  def findTickets(tokenId: String) = Action.async{
    val cursor: Cursor[Ticket] = collection.
    find(Json.obj("active" -> true)).
    sort(Json.obj("created" -> -1)).
    cursor[Ticket]
    val futureTicketsList: Future[List[Ticket]] = cursor.collect[List]()
    val futurePersonsJsonArray: Future[JsArray] = futureTicketsList.map { Tickets =>
        Json.arr(Tickets)
    }
    futurePersonsJsonArray.map {
      Tickets =>
        Ok(Tickets(0))
    }
  }
  
  def isAuthenticated( tokenId:String ) : Unit = {
      val cursor: Cursor[User] = user_collection.
      find(Json.obj("tokenId" -> tokenId)).
      cursor[User]
      val futureUsersList: Future[List[User]] = cursor.collect[List]()
      val futureUsersJsonArray: Future[JsArray] = futureUsersList.map { users =>
          if(users.length==1){
            println ("Set to true")
            isAuthenticatedBool=true}
          else
            isAuthenticatedBool=false
        println ("Done witht this")
        Json.arr(users)
      }
   }
}
