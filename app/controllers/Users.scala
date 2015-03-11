package controllers

import javax.inject.{Singleton, Inject}
import services.UUIDGenerator
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
class Users @Inject() (uuidGenerator: UUIDGenerator) extends Controller with MongoController {

  private final val logger: Logger = LoggerFactory.getLogger(classOf[Users])

  def collection: JSONCollection = db.collection[JSONCollection]("users")

  import models._
  import models.JsonFormats._

  def createUser = Action.async(parse.json) {
    request =>
    /*
     * request.body is a JsValue.
     * There is an implicit Writes that turns this JsValue as a JsObject,
     * so you can call insert() with this JsValue.
     * (insert() takes a JsObject as parameter, or anything that can be
     * turned into a JsObject using a Writes.)
     */
      request.body.validate[User].map {
        user =>
          val token=uuidGenerator.generate.toString
          collection.insert(Json.obj("tokenId" -> token,"userId" -> user.userId,"active" -> true, "userName" -> user.userName, "password" -> user.password, "email" -> user.email)).map {
            lastError =>
              logger.debug(s"Successfully inserted with LastError: $lastError")
              Created(s"User Created")
              Ok(Json.obj("tokenId" -> token))
          }
      }.getOrElse(Future.successful(BadRequest("invalid json")))
  }


  def findUsers(email:String,password:String) = Action.async {
      val cursor: Cursor[User] = collection.
      find(Json.obj("email" -> email, "password" -> password)).
      sort(Json.obj("created" -> -1)).
      cursor[User]

     val futureUsersList: Future[List[User]] = cursor.collect[List]()
        futureUsersList.map { users =>
        if(users.length==1){
            Ok(Json.obj("tokenId" -> users(0).tokenId, "userName" -> users(0).userName, "userId" -> users(0).userId))
        }
        else{
            Ok("Invalid. Please check Username and Password.")
        }
      }
  }
  def findUserById(userId:String) = Action.async {
      val cursor: Cursor[User] = collection.
      find(Json.obj("userId" -> userId)).
      sort(Json.obj("created" -> -1)).
      cursor[User]

        val futureUsersList: Future[List[User]] = cursor.collect[List]()
        val futureUsersJsonArray: Future[JsArray] = futureUsersList.map { users =>
          Json.arr(users)
        }
        futureUsersJsonArray.map {
          users =>
            Ok(users(0))
        }
  }
  def findAllUsers() = Action.async {
      request =>
        val cursor: Cursor[User] = collection.
        find(Json.obj("active" -> true)).
        sort(Json.obj("created" -> -1)).
        cursor[User]
        val futureUsersList: Future[List[User]] = cursor.collect[List]()
        val futureUsersJsonArray: Future[JsArray] = futureUsersList.map { users =>
          Json.arr(users)
        }
        futureUsersJsonArray.map {
          users =>
            Ok(users(0))
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
