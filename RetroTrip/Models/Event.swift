//
//  Event.swift
//  RetroTrip
//
//  Created by Antonio Costa on 10/09/25.
//

import Foundation

struct Event {
    let id = UUID()
    let name: String
    let details: String
    let startedYear: Int
    let endedYear: Int
    let longitude: Double
    let latitude: Double
    let dificulty: String
}
