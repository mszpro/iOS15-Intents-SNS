//
//  ContentView.swift
//  SNS-Intent-Demo
//
//  Created by Shunzhe Ma on 2021/09/25.
//

import SwiftUI
import UserNotifications
import Intents

struct ContentView: View {
    
    @State private var isNotificationPermitted: Bool = false
    
    var body: some View {
        Form {
            
            // Notification center permission
            if !isNotificationPermitted {
                Button("Allow push notification") {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { permitted, _ in
                        self.isNotificationPermitted = permitted
                    }
                }
            }
            
            Section {
                Button("Schedule a notification (5 seconds later)") {
                    
                    let sender = [DemoParticipants.demoParticipant, DemoParticipants.demoParticipant2].randomElement()!
                    let currentUser = DemoParticipants.currentUser
                    let chatMessage = "テスト、テスト、テスト"
                    
                    var content = UNMutableNotificationContent()
                    content.title = "New chat message"
                    content.body = chatMessage

                    let intent = INSendMessageIntent(
                        recipients: [currentUser],
                        outgoingMessageType: .outgoingMessageText,
                        content: chatMessage,
                        speakableGroupName: INSpeakableString(spokenPhrase: sender.displayName),
                        conversationIdentifier: "chat001",
                        serviceName: nil,
                        sender: sender,
                        attachments: nil
                    )

                    intent.setImage(sender.image, forParameterNamed: \.sender)

                    let interaction = INInteraction(intent: intent, response: nil)
                    interaction.direction = .incoming

                    interaction.donate { error in
                        print(error?.localizedDescription)
                    }

                    do {
                        content = try content.updating(from: intent) as! UNMutableNotificationContent
                    } catch {
                        // Handle error
                        print(error.localizedDescription)
                    }

                    // Show the message after 5 seconds
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request)
                }
            }
            
        }
        .onAppear {
            // Check notification permission
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
                let isAuthorized = settings.authorizationStatus == .authorized
                self.isNotificationPermitted = isAuthorized
            })
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
