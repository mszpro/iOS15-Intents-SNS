//
//  ChatMessage.swift
//  SNS-Intent-Demo
//
//  Created by Shunzhe Ma on 2021/09/25.
//

import Foundation
import Intents
import UIKit

struct DemoParticipants {
    static let demoParticipant: INPerson = INPerson(
        personHandle: INPersonHandle(value: "John-Appleseed@mac.com", type: .emailAddress),
        nameComponents: try? PersonNameComponents("John Appleseed"),
        displayName: "@john",
        image: INImage(imageData: UIImage(systemName: "applelogo")!.pngData()!),
        contactIdentifier: nil,
        customIdentifier: "john",
        isMe: false,
        suggestionType: .instantMessageAddress
    )
    static let demoParticipant2: INPerson = INPerson(
        personHandle: INPersonHandle(value: "(555) 610-6679", type: .phoneNumber),
        nameComponents: try? PersonNameComponents("David Taylor"),
        displayName: "@david",
        image: INImage(imageData: UIImage(systemName: "capslock")!.pngData()!),
        contactIdentifier: nil,
        customIdentifier: "david",
        isMe: false,
        suggestionType: .instantMessageAddress
    )
    static let currentUser: INPerson = INPerson(
        personHandle: INPersonHandle(value: "test@example.com", type: .emailAddress),
        nameComponents: try? PersonNameComponents("Current User"),
        displayName: "@current",
        image: INImage(imageData: UIImage(systemName: "sun.max.fill")!.pngData()!),
        contactIdentifier: nil,
        customIdentifier: "current",
        isMe: true,
        suggestionType: .instantMessageAddress
    )
}
