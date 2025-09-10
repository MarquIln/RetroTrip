//
//  Colection.swift
//  RetroTrip
//
//  Created by Antonio Costa on 10/09/25.
//

import Foundation

struct Collection {
    let id = UUID()
    let name: String
    let badgesId: [UUID]
    let image: Data
}
