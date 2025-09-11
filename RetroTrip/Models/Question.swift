//
//  Question.swift
//  RetroTrip
//
//  Created by Antonio Costa on 10/09/25.
//

import SwiftData

@Model
class Question {
    var question: String
    var tips: String
    @Relationship(deleteRule: .cascade) var answers: [Answer]
    @Relationship(inverse: \Quiz.questions) var quiz: Quiz?

    init(question: String, tips: String, answers: [Answer] = [], quiz: Quiz? = nil) {
        self.question = question
        self.tips = tips
        self.answers = answers
        self.quiz = quiz
    }
}
