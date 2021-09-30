//
//  NotificationService.swift
//  Notification-Service
//
//  Created by Shunzhe Ma on 2021/09/25.
//

import UserNotifications
import Intents
import UIKit

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            
            /*
             Use the custom information included in this notification from the chat server to retrive the chat participant's information.
             - This is the information of the sender of the message.
             - Providing a user's accruate name helps the iOS system match this user with a contact in the system contact app.
             */
            if let senderAccountID = bestAttemptContent.userInfo["sender_id"] as? String,
               let senderName = bestAttemptContent.userInfo["sender_name"] as? String,
               let senderImageURLString = bestAttemptContent.userInfo["sender_image_url"] as? String,
               let senderImageURL = URL(string: senderImageURLString),
               let senderDisplayName = bestAttemptContent.userInfo["sender_nickname"] as? String,
               let senderEmailAddr = bestAttemptContent.userInfo["sender_email"] as? String,
               let chatSessionID = bestAttemptContent.userInfo["chat-session_id"] as? String
            {
                
                // You can also use the sender's phone number to initialize the `INPersonHandle` object. This will help the iOS system to match this sender with a contact.
                // TODO: - Here you need to download the image data from the URL. In this demo, we are using a system image instead.
                let messageSender = INPerson(
                    personHandle: INPersonHandle(value: senderEmailAddr, type: .emailAddress),
                    nameComponents: try? PersonNameComponents(senderName),
                    displayName: senderDisplayName,
                    image: INImage(imageData: UIImage(systemName: "applelogo")!.pngData()!),
                    contactIdentifier: nil,
                    customIdentifier: senderAccountID,
                    isMe: false,
                    suggestionType: .instantMessageAddress
                )
                
                let intent = INSendMessageIntent(recipients: nil,
                                                 outgoingMessageType: .outgoingMessageText,
                                                 content: bestAttemptContent.body,
                                                 speakableGroupName: INSpeakableString(spokenPhrase: senderDisplayName),
                                                 conversationIdentifier: chatSessionID,
                                                 serviceName: nil,
                                                 sender: messageSender,
                                                 attachments: nil)
                
                let interaction = INInteraction(intent: intent, response: nil)
                interaction.direction = .incoming
                interaction.donate(completion: nil)
                do {
                    let messageContent = try request.content.updating(from: intent)
                    contentHandler(messageContent)
                } catch {
                    print(error.localizedDescription)
                }
                
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
