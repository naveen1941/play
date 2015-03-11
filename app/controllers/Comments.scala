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
class Comments extends Controller with MongoController {

  private final val logger: Logger = LoggerFactory.getLogger(classOf[Comments])


  def collection: JSONCollection = db.collection[JSONCollection]("comments")
  def user_collection: JSONCollection = db.collection[JSONCollection]("users")

  import models._
  import models.JsonFormats._

  def createComment = Action.async(parse.json) {
    request =>
      var tokenId="DEFAULT_TOKEN_ID"
        (request.body \ "tokenId").asOpt[String].map { token =>
            tokenId=token
        }
        
        request.body.validate[Comment].map {
            comment =>
              collection.insert(comment).map {
                lastError =>
                  logger.debug(s"Successfully inserted with LastError: $lastError")
                  Created(s"Comment Created")
              }
              
          }.getOrElse(Future.successful(BadRequest("invalid json")))
       
  }
  

  def findComments(ticketId: String) =  Action.async {
        
        val cursor: Cursor[Comment] = collection.
        find(Json.obj("ticketId" -> ticketId)).
        sort(Json.obj("created" -> -1)).
        cursor[Comment]
        val futureCommentsList: Future[List[Comment]] = cursor.collect[List]()
        val futurePersonsJsonArray: Future[JsArray] = futureCommentsList.map { Comments =>
          Json.arr(Comments)
        }
        futurePersonsJsonArray.map {
          Comments =>
            Ok(Comments(0))
        }
  }
  def isAuthenticated( tokenId:String ) : Boolean = {
      val cursor: Cursor[User] = collection.
      find(Json.obj("tokenId" -> tokenId)).
      sort(Json.obj("created" -> -1)).
      cursor[User]
      val futureUsersList: Future[List[User]] = cursor.collect[List]()

      val futureUsersJsonArray: Future[JsArray] = futureUsersList.map { users =>
          if(users.length==1)
            return true
          else
            return false
      }
      return false
   }

}
