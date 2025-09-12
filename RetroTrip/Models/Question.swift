//
//  Question.swift
//  RetroTrip
//
//  Created by Marcos on 12/09/25.
//

import Foundation
import CloudKit

struct Question {
    let id: CKRecord.ID
    let text: String
    let tips: String?
    let quiz: CKRecord.ID?
}
