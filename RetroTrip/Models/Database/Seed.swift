//
//  Seed.swift
//  RetroTrip
//
//  Created by Marcos on 11/09/25.
//

import Foundation
import CloudKit

final class Seed {
    static let shared = Seed()
    private init() {}

    func runSeedIfNeeded(completion: @escaping () -> Void) {
        Database.shared.fetchAllQuizzes { result in
            switch result {
            case .success(let quizzes):
                if quizzes.isEmpty {
                    self.seedAll(completion: completion)
                } else {
                    completion()
                }
            case .failure:
                completion()
            }
        }
    }

    private func seedAll(completion: @escaping () -> Void) {
        let outer = DispatchGroup()

        outer.enter()
        Database.shared.createQuiz(title: "French Revolution") { result in
            switch result {
            case .success(let quiz):
                self.seedFrenchRevolution(quiz: quiz.id) { outer.leave() }
            case .failure:
                outer.leave()
            }
        }

        outer.enter()
        Database.shared.createQuiz(title: "Industrial Revolutions") { result in
            switch result {
            case .success(let quiz):
                self.seedIndustrialRevolutions(quiz: quiz.id) { outer.leave() }
            case .failure:
                outer.leave()
            }
        }

        outer.enter()
        Database.shared.createQuiz(title: "World History Highlights") { result in
            switch result {
            case .success(let quiz):
                self.seedWorldHighlights(quiz: quiz.id) { outer.leave() }
            case .failure:
                outer.leave()
            }
        }

        outer.notify(queue: .main) { completion() }
    }
}

private extension Seed {
    func seedFrenchRevolution(quiz: CKRecord.ID, completion: @escaping () -> Void) {
        let g = DispatchGroup()

        g.enter()
        createQuestionWithAnswers(
            text: "In which year did the French Revolution begin?",
            tips: "Late 18th century",
            answers: [("1789", true), ("1776", false), ("1799", false), ("1804", false)],
            quiz: quiz
        ) { g.leave() }

        g.enter()
        createQuestionWithAnswers(
            text: "Which event symbolized the start of the French Revolution?",
            tips: "It happened in Paris",
            answers: [("Storming of the Bastille", true), ("Treaty of Versailles", false), ("Napoleon’s Coronation", false), ("Congress of Vienna", false)],
            quiz: quiz
        ) { g.leave() }

        g.enter()
        createQuestionWithAnswers(
            text: "Which document was adopted in August 1789?",
            tips: "It proclaimed universal rights",
            answers: [("Declaration of the Rights of Man and of the Citizen", true), ("Magna Carta", false), ("English Bill of Rights", false), ("Napoleonic Code", false)],
            quiz: quiz
        ) { g.leave() }

        g.enter()
        Database.shared.createEvent(
            name: "Storming of the Bastille",
            details: "The fall of the Bastille on July 14, 1789.",
            startedYear: 1789,
            endedYear: 1789,
            longitude: 2.3522,
            latitude: 48.8566,
            difficulty: "Medium",
            place: "Paris",
            quiz: quiz
        ) { _ in g.leave() }

        g.enter()
        Database.shared.createBadge(name: "1789", details: "French Revolution mastery") { bRes in
            switch bRes {
            case .success(let badge):
                Database.shared.createBadgeCollection(name: "French Revolution", badgeIds: [badge.id]) { _ in g.leave() }
            case .failure:
                g.leave()
            }
        }

        g.notify(queue: .main) { completion() }
    }

    func seedIndustrialRevolutions(quiz: CKRecord.ID, completion: @escaping () -> Void) {
        let g = DispatchGroup()

        g.enter()
        createQuestionWithAnswers(
            text: "Which energy source powered the First Industrial Revolution?",
            tips: "Think steam engines",
            answers: [("Steam power", true), ("Electricity", false), ("Nuclear energy", false), ("Solar energy", false)],
            quiz: quiz
        ) { g.leave() }

        g.enter()
        createQuestionWithAnswers(
            text: "The Third Industrial Revolution is also known as the…",
            tips: "Computers and electronics",
            answers: [("Digital Revolution", true), ("Green Revolution", false), ("Space Age", false), ("Agricultural Revolution", false)],
            quiz: quiz
        ) { g.leave() }

        g.enter()
        createQuestionWithAnswers(
            text: "Which country led textile mechanization in the 18th century?",
            tips: "Islands in Europe",
            answers: [("United Kingdom", true), ("Germany", false), ("United States", false), ("France", false)],
            quiz: quiz
        ) { g.leave() }

        g.enter()
        Database.shared.createEvent(
            name: "First Industrial Revolution",
            details: "Mechanization, steam power, and factories (c. 1760–1840).",
            startedYear: 1760,
            endedYear: 1840,
            longitude: -2.2426,
            latitude: 53.4808,
            difficulty: "Medium",
            place: "United Kingdom",
            quiz: quiz
        ) { _ in g.leave() }

        g.enter()
        Database.shared.createEvent(
            name: "Third Industrial Revolution",
            details: "Digital Revolution: semiconductors, computers, internet.",
            startedYear: 1970,
            endedYear: 2000,
            longitude: -122.0575,
            latitude: 37.3875,
            difficulty: "Medium",
            place: "Silicon Valley",
            quiz: quiz
        ) { _ in g.leave() }

        g.enter()
        Database.shared.createBadge(name: "Steam & Silicon", details: "Industrial Revolutions mastery") { bRes in
            switch bRes {
            case .success(let badge):
                Database.shared.createBadgeCollection(name: "Industrial Revolutions", badgeIds: [badge.id]) { _ in g.leave() }
            case .failure:
                g.leave()
            }
        }

        g.notify(queue: .main) { completion() }
    }

    func seedWorldHighlights(quiz: CKRecord.ID, completion: @escaping () -> Void) {
        let g = DispatchGroup()

        g.enter()
        createQuestionWithAnswers(
            text: "In what year did Pedro Álvares Cabral reach Brazil?",
            tips: "Turn of the 16th century",
            answers: [("1500", true), ("1492", false), ("1530", false), ("1822", false)],
            quiz: quiz
        ) { g.leave() }

        g.enter()
        createQuestionWithAnswers(
            text: "In which year did humans first land on the Moon?",
            tips: "Apollo 11",
            answers: [("1969", true), ("1957", false), ("1961", false), ("1972", false)],
            quiz: quiz
        ) { g.leave() }

        g.enter()
        createQuestionWithAnswers(
            text: "The fall of the Berlin Wall occurred in…",
            tips: "Late 20th century",
            answers: [("1989", true), ("1991", false), ("1980", false), ("1975", false)],
            quiz: quiz
        ) { g.leave() }

        g.enter()
        Database.shared.createEvent(
            name: "Discovery of Brazil",
            details: "Pedro Álvares Cabral reached the Brazilian coast in 1500.",
            startedYear: 1500,
            endedYear: 1500,
            longitude: -39.0833,
            latitude: -16.4333,
            difficulty: "Easy",
            place: "Porto Seguro",
            quiz: quiz
        ) { _ in g.leave() }

        g.enter()
        Database.shared.createEvent(
            name: "Discovery of Fire",
            details: "Mastery of fire by early humans.",
            startedYear: -400000,
            endedYear: -400000,
            longitude: 0.0,
            latitude: 0.0,
            difficulty: "Hard",
            place: "Prehistory",
            quiz: quiz
        ) { _ in g.leave() }

        g.enter()
        Database.shared.createEvent(
            name: "Moon Landing",
            details: "Apollo 11; first human steps on the Moon.",
            startedYear: 1969,
            endedYear: 1969,
            longitude: -80.6480,
            latitude: 28.5721,
            difficulty: "Medium",
            place: "Cape Canaveral",
            quiz: quiz
        ) { _ in g.leave() }

        g.enter()
        Database.shared.createEvent(
            name: "Fall of the Berlin Wall",
            details: "1989 marked the opening of the Berlin Wall.",
            startedYear: 1989,
            endedYear: 1989,
            longitude: 13.3777,
            latitude: 52.5163,
            difficulty: "Easy",
            place: "Berlin",
            quiz: quiz
        ) { _ in g.leave() }

        g.enter()
        Database.shared.createEvent(
            name: "Construction of the Pyramids",
            details: "Great Pyramid of Giza (Khufu) as reference.",
            startedYear: -2580,
            endedYear: -2560,
            longitude: 31.1342,
            latitude: 29.9792,
            difficulty: "Hard",
            place: "Giza",
            quiz: quiz
        ) { _ in g.leave() }

        g.enter()
        Database.shared.createEvent(
            name: "Bubonic Plague (Black Death)",
            details: "Pandemic in Europe (c. 1347–1351).",
            startedYear: 1347,
            endedYear: 1351,
            longitude: 2.3522,
            latitude: 48.8566,
            difficulty: "Hard",
            place: "Europe",
            quiz: quiz
        ) { _ in g.leave() }

        g.enter()
        Database.shared.createEvent(
            name: "Great Wall of China",
            details: "Major Ming works concluded by 1644.",
            startedYear: -700,
            endedYear: 1644,
            longitude: 116.5704,
            latitude: 40.4319,
            difficulty: "Hard",
            place: "China",
            quiz: quiz
        ) { _ in g.leave() }

        g.enter()
        Database.shared.createBadge(name: "World Explorer", details: "Global history highlights") { bRes in
            switch bRes {
            case .success(let badge):
                Database.shared.createBadgeCollection(name: "World History Highlights", badgeIds: [badge.id]) { _ in g.leave() }
            case .failure:
                g.leave()
            }
        }

        g.notify(queue: .main) { completion() }
    }
}

private extension Seed {
    func createQuestionWithAnswers(text: String,
                                   tips: String?,
                                   answers: [(String, Bool)],
                                   quiz: CKRecord.ID,
                                   completion: @escaping () -> Void) {
        Database.shared.createQuestion(text: text, tips: tips, quiz: quiz) { qRes in
            switch qRes {
            case .success(let question):
                let g = DispatchGroup()
                for (t, ok) in answers {
                    g.enter()
                    Database.shared.createAnswer(text: t, isCorrect: ok, question: question.id) { _ in g.leave() }
                }
                g.notify(queue: .main) { completion() }
            case .failure:
                completion()
            }
        }
    }
}
