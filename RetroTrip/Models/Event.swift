//
//  Event.swift
//  RetroTrip
//
//  Created by Antonio Costa on 10/09/25.
//

import Foundation
import SwiftData

@Model
class Event {
    var name: String
    var details: String
    var startedYear: Int
    var endedYear: Int
    var longitude: Double
    var latitude: Double
    var difficulty: String
    var image: Data
    var image3D: Data
    var place: String
    @Relationship var quiz: Quiz?

    init(name: String,
         details: String,
         startedYear: Int,
         endedYear: Int,
         longitude: Double,
         latitude: Double,
         difficulty: String,
         image: Data,
         image3D: Data,
         place: String,
         quiz: Quiz? = nil) {
        self.name = name
        self.details = details
        self.startedYear = startedYear
        self.endedYear = endedYear
        self.longitude = longitude
        self.latitude = latitude
        self.difficulty = difficulty
        self.image = image
        self.image3D = image3D
        self.place = place
        self.quiz = quiz
    }
}
