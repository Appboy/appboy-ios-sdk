import UserNotifications
import UIKit

let AppboyAPNSDictionaryKey = "ab"
let AppboyAPNSDictionaryAttachmentKey = "att"
let AppboyAPNSDictionaryAttachmentURLKey = "url"
let AppboyAPNSDictionaryAttachmentTypeKey = "type"

class NotificationService: UNNotificationServiceExtension {
  
  var contentHandler: ((UNNotificationContent) -> Void)?
  var bestAttemptContent: UNMutableNotificationContent?
  var originalContent: UNMutableNotificationContent?
  var abortOnAttachmentFailure: Bool = false
  
  override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    self.contentHandler = contentHandler
    self.bestAttemptContent = (request.content.mutableCopy() as! UNMutableNotificationContent)
    self.originalContent = (request.content.mutableCopy() as! UNMutableNotificationContent)
    
    print("[APPBOY] Push with mutable content received.")
    
    var attachments : [UNNotificationAttachment] = []
    let userInfo: [AnyHashable : Any]! = request.content.userInfo
    
    // Check that the push is from Appboy
    if (userInfo![AppboyAPNSDictionaryKey] as Any? == nil) {
      // Note: if you have other push senders and want to handler here, fork your code here to handle
      self.displayOriginalContent("Push is not from Appboy.")
      return
    }
    
    let appboyPayload: [AnyHashable : Any]! = userInfo![AppboyAPNSDictionaryKey] as! [AnyHashable : Any]!
    // Check that the push has an attachment
    if (appboyPayload[AppboyAPNSDictionaryAttachmentKey] as Any? == nil) {
      self.displayOriginalContent("Push has no attachment.")
      return
    }
    
    let attachmentPayload: [AnyHashable : Any]! = appboyPayload[AppboyAPNSDictionaryAttachmentKey] as! [AnyHashable : Any]!
    // Check that the attachment has a URL
    if (attachmentPayload[AppboyAPNSDictionaryAttachmentURLKey] == nil ) {
      self.displayOriginalContent("Push attachment has no url.")
      return
    }
    
    let attachmentURLString: String! = attachmentPayload[AppboyAPNSDictionaryAttachmentURLKey] as! String
    print("[APPBOY] Attachment URL string is \(attachmentURLString)")
    // Get the type
    if(attachmentPayload[AppboyAPNSDictionaryAttachmentTypeKey] == nil) {
      self.displayOriginalContent("Push attachment has no type.")
      return
    }
    
    let attachmentType: String = attachmentPayload[AppboyAPNSDictionaryAttachmentTypeKey] as! String
    print("[APPBOY] Attachment type is \(attachmentType)")
    let fileSuffix: String = ".\(attachmentType)"
    
    // Download, store, and attach the content to the notification
    if (attachmentURLString != nil) {
      guard let attachmentURL = URL.init(string: attachmentURLString) else {
        self.displayOriginalContent("Cannot parse \(attachmentURLString) to URL.")
        return
      }
      let session = URLSession(configuration:URLSessionConfiguration.default)
      session.downloadTask(with: attachmentURL,
                           completionHandler: { (temporaryFileLocation, response, error) in
                            if (error != nil || temporaryFileLocation == nil) {
                              self.displayOriginalContent("Error fetching attachment, displaying content unaltered: \(String(describing: error?.localizedDescription))")
                              return
                            } else {
                              print("[Appboy] Data fetched from server, processing with temporary file url \(temporaryFileLocation!.absoluteString)")
                              
                              let fileManager = FileManager.default
                              let typedAttachmentURL = URL(fileURLWithPath:"\(temporaryFileLocation!.path)\(fileSuffix)")
                              do {
                                try fileManager.moveItem(at: temporaryFileLocation!, to: typedAttachmentURL)
                              } catch {
                                self.displayOriginalContent("Failed to move file path.")
                                return
                              }
                              
                              let attachment: UNNotificationAttachment? = try? UNNotificationAttachment.init(identifier: "",
                                                                                                             url: typedAttachmentURL,
                                                                                                             options: nil)
                              if (attachment == nil) {
                                self.displayOriginalContent("Attachment returned error.")
                                return
                              }
                              
                              attachments = [attachment!]
                              self.bestAttemptContent!.attachments = attachments;
                              self.contentHandler!(self.bestAttemptContent!);
                            }
      }).resume()
    }
  }
  
  func displayOriginalContent(_ extraLogging: String) {
    print("[APPBOY] \(extraLogging)")
    print("[APPBOY] Displaying original content.")
    self.contentHandler!(self.originalContent!)
  }
  
  override func serviceExtensionTimeWillExpire() {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.displayOriginalContent("Service extension called, displaying original content.")
  }
}
