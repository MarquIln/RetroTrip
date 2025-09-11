//
//  User.swift
//  RetroTrip
//
//  Created by Antonio Costa on 10/09/25.
//

import Foundation
import SwiftData

@Model
class User {
    var name: String
    @Relationship var badges: [Badges]

    init(name: String, badges: [Badges] = []) {
        self.name = name
        self.badges = badges
    }
}
