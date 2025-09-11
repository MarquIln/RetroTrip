//
//  DTOs.swift
//  RetroTrip
//
//  Created by Marcos on 11/09/25.
//

import Foundation
import CloudKit

struct QuizDTO {
    let id: CKRecord.ID
    let title: String
}

struct QuestionDTO {
    let id: CKRecord.ID
    let question: String
    let tips: String
    let quizRef: CKRecord.Reference?
}

struct AnswerDTO {
    let id: CKRecord.ID
    let answer: String
    let isCorrect: Bool
    let questionRef: CKRecord.Reference?
}

struct EventDTO {
    let id: CKRecord.ID
    let name: String
    let details: String
    let startedYear: Int
    let endedYear: Int
    let longitude: Double
    let latitude: Double
    let difficulty: String
    let place: String
    let quizRef: CKRecord.Reference?
}

struct BadgeDTO {
    let id: CKRecord.ID
    let name: String
    let details: String
}

struct BadgeCollectionDTO {
    let id: CKRecord.ID
    let name: String
    let badgeRefs: [CKRecord.Reference]
}

struct UserDTO {
    let id: CKRecord.ID
    let name: String
    let badgeRefs: [CKRecord.Reference]
}
