package models

import java.util.Date
import org.joda.time._

case class User( email: String,
                 userName: String,
                 password: String,
                 active: Boolean,
                 userId: String,
                 tokenId: String)
                 
case class Comment( ticketId:String,
                 comment:String,
                 commentedBy: String,
                 userName:String,
                 commentedDate: Date,
                 tokenId: String
                 )

case class Ticket(  
                    customerName: String,
                    email: String,
                    title:String,
                    description:String,
                    status:String,
                    userName:String,
                    assignedTo:String,
                    createdBy:String,
                    lastUpdatedBy: String,
                    createdDate: Date,
                    lastUpdatedDate: Date,
                    ticketId: String,
                    tokenId: String,
                    active:Boolean
                   )
object JsonFormats {
  import play.api.libs.json.Json

  // Generates Writes and Reads for Feed and User thanks to Json Macros
  implicit val userFormat = Json.format[User]
  implicit val ticketFormat = Json.format[Ticket]
  implicit val commentFormat = Json.format[Comment]
}
