//
//  Event.swift
//  RetroTrip
//
//  Created by Marcos on 12/09/25.
//

import Foundation
import CloudKit

struct Event {
    let id: CKRecord.ID
    let name: String
    let details: String?
    let startedYear: Int
    let endedYear: Int
    let longitude: Double
    let latitude: Double
    let difficulty: String?
    let place: String?
    let quiz: CKRecord.ID?
}
