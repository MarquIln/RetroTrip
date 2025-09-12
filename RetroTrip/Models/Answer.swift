//
//  Answer.swift
//  RetroTrip
//
//  Created by Marcos on 12/09/25.
//

import Foundation
import CloudKit

struct Answer {
    let id: CKRecord.ID
    let text: String
    let isCorrect: Bool
    let question: CKRecord.ID?
}
