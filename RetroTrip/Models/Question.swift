//
//  Question.swift
//  RetroTrip
//
//  Created by Antonio Costa on 10/09/25.
//

import Foundation

struct Question {
    let id = UUID()
    let question: String
    let answer: [Answer]
    let tips: String
}
