//
//  NotificationService.swift
//  Mast Push
//
//  Created by Shihab Mehboob on 17/02/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            
            guard let storedState = PushNotificationReceiver.getSate() else {
                contentHandler(bestAttemptContent)
                return
            }
            
            do {
                let content = try bestAttemptContent.decrypt(state: storedState)
            } catch let error as Error {
                print(error)
            }
            
            if let content = try? bestAttemptContent.decrypt(state: storedState) {
                
                // Mark the message as still encrypted.
                bestAttemptContent.title = content.title
                bestAttemptContent.body = content.body
                
            }
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}
