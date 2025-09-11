//
//  Colection.swift
//  RetroTrip
//
//  Created by Antonio Costa on 10/09/25.
//

import Foundation
import SwiftData

@Model
class BadgeCollection {
    var name: String
    var image: Data
    @Relationship(deleteRule: .cascade) var badges: [Badges]

    init(name: String, image: Data, badges: [Badges] = []) {
        self.name = name
        self.image = image
        self.badges = badges
    }
}
