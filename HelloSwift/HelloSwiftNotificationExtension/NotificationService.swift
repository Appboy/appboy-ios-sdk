import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    static let AppboyAPNSDictionaryKey                  = "ab"
    static let AppboyAPNSDictionaryAttachmentKey        = "att"
    static let AppboyAPNSDictionaryAttachmentURLKey     = "url"
    static let AppboyAPNSDictionaryAttachmentTypeKey    = "type"
    
    var contentHandler:           ((UNNotificationContent) -> Void)?
    var originalContent:          UNNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        self.originalContent = request.content
        
        print("[APPBOY] Push with mutable content received.")
        
        let userInfo = request.content.userInfo
        
        // Check that the push is from Appboy
        guard let appboyPayload = userInfo[NotificationService.AppboyAPNSDictionaryKey] as? [AnyHashable : Any]
            else
        {
            // Note: if you have other push senders and want to handler here, fork your code here to handle
            displayOriginalContent("Push is not from Appboy.")
            return
        }
        
        guard let attachmentPayload = appboyPayload[NotificationService.AppboyAPNSDictionaryAttachmentKey] as? [AnyHashable : Any]
            else {
                displayOriginalContent("Push has no attachment.")
                return
        }
        
        guard let attachmentURLString = attachmentPayload[NotificationService.AppboyAPNSDictionaryAttachmentURLKey] as? String
            else {
                displayOriginalContent("No Attachment URL key.")
                return
        }
        
        guard let attachmentType = attachmentPayload[NotificationService.AppboyAPNSDictionaryAttachmentTypeKey] as? String
            else {
                displayOriginalContent("Push attachment has no type.")
                return
        }
        
        guard let attachmentURL = URL(string: attachmentURLString) else {
            displayOriginalContent("Cannot parse \(attachmentURLString) to URL.")
            return
        }
        
        print("[APPBOY] Attachment URL string is \(attachmentURLString)")
        print("[APPBOY] Attachment type is \(attachmentType)")
        
        let fileSuffix: String = ".\(attachmentType)"
        
        // Download, store, and attach the content to the notification
        let session = URLSession(configuration: .default)
        
        session.downloadTask(with: attachmentURL) {
            (temporaryFileLocation, response, error) in
            
            guard let temporaryFileLocation = temporaryFileLocation, error == nil else {
                self.displayOriginalContent("Error fetching attachment, displaying content unaltered: \(String(describing: error?.localizedDescription))")
                return
            }
            
            print("[Appboy] Data fetched from server, processing with temporary file url \(temporaryFileLocation.absoluteString)")
            
            let typedAttachmentURL = URL(fileURLWithPath: "\(temporaryFileLocation.path)\(fileSuffix)")
            
            do {
                try FileManager.default.moveItem(at: temporaryFileLocation, to: typedAttachmentURL)
            } catch {
                self.displayOriginalContent("Failed to move file path.")
                return
            }
            
            guard let attachment = try? UNNotificationAttachment(identifier: "", url: typedAttachmentURL)
                else {
                    self.displayOriginalContent("Attachment returned error.")
                    return
            }
            
            if  let contentHandler = self.contentHandler,
                let bestAttemptContent = self.originalContent?.mutableCopy() as? UNMutableNotificationContent
            {
                bestAttemptContent.attachments = [attachment]
                contentHandler(bestAttemptContent)
            }
            }.resume()
    }
    
    func displayOriginalContent(_ extraLogging: String) {
        print("[APPBOY] \(extraLogging)")
        print("[APPBOY] Displaying original content.")
        
        if
            let contentHandler = self.contentHandler,
            let originalContent = self.originalContent
        {
            contentHandler(originalContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        displayOriginalContent("Service extension called, displaying original content.")
    }
}

