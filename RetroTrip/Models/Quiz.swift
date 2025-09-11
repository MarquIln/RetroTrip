//
//  Quiz.swift
//  RetroTrip
//
//  Created by Antonio Costa on 10/09/25.
//

import Foundation
import SwiftData

@Model
class Quiz {
    @Relationship(deleteRule: .cascade) var questions: [Question]

    init(questions: [Question] = []) {
        self.questions = questions
    }
}
