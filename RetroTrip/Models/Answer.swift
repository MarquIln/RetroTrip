//
//  Answer.swift
//  RetroTrip
//
//  Created by Antonio Costa on 10/09/25.
//

import SwiftData

@Model
class Answer {
    var answer: String
    var isCorrect: Bool
    @Relationship(inverse: \Question.answers) var question: Question?

    init(answer: String, isCorrect: Bool, question: Question? = nil) {
        self.answer = answer
        self.isCorrect = isCorrect
        self.question = question
    }
}
