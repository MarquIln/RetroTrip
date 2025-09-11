//
//  Seed.swift
//  RetroTrip
//
//  Created by Marcos on 11/09/25.
//

import Foundation
import CloudKit

class Seed {
    static let shared = Seed()
    
    private init() {}
    
    func runSeedIfNeeded(completion: @escaping () -> Void) {
        Database.shared.fetchAllQuizzes { result in
            switch result {
            case .success(let quizzes):
                if quizzes.isEmpty {
                    print("🌱 Banco vazio → rodando seed...")
                    self.seedData {
                        completion()
                    }
                } else {
                    print("✅ Banco já populado (\(quizzes.count) quizzes)")
                    completion()
                }
            case .failure(let error):
                print("⚠️ Erro ao verificar seed: \(error)")
                completion()
            }
        }
    }
    
    private func seedData(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        
        // --- QUIZ 1: História do Brasil ---
        group.enter()
        Database.shared.createQuiz(title: "História do Brasil") { result in
            if case .success(let quiz) = result {
                self.seedQuestionsForHistoria(quiz: quiz)
                self.seedEventForHistoria(quiz: quiz)
                self.seedBadgeCollectionForHistoria()
            }
            group.leave()
        }
        
        // --- QUIZ 2: Revolução Francesa ---
        group.enter()
        Database.shared.createQuiz(title: "Revolução Francesa") { result in
            if case .success(let quiz) = result {
                self.seedQuestionsForFrancesa(quiz: quiz)
                self.seedEventForFrancesa(quiz: quiz)
                self.seedBadgeCollectionForFrancesa()
            }
            group.leave()
        }
        
        // --- QUIZ 3: Segunda Guerra Mundial ---
        group.enter()
        Database.shared.createQuiz(title: "Segunda Guerra Mundial") { result in
            if case .success(let quiz) = result {
                self.seedQuestionsForGuerra(quiz: quiz)
                self.seedEventForGuerra(quiz: quiz)
                self.seedBadgeCollectionForGuerra()
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("🌱 Seed completo finalizado!")
            completion()
        }
    }
}

// MARK: - Seeds detalhados
extension Seed {
    private func seedQuestionsForHistoria(quiz: CKRecord) {
        Database.shared.createQuestion(text: "Em que ano foi a Proclamação da República?", tips: "Final do século XIX", quiz: quiz) { qResult in
            if case .success(let question) = qResult {
                Database.shared.createAnswer(text: "1889", isCorrect: true, question: question) { _ in }
                Database.shared.createAnswer(text: "1822", isCorrect: false, question: question) { _ in }
            }
        }
    }
    
    private func seedEventForHistoria(quiz: CKRecord) {
        Database.shared.createEvent(
            name: "Proclamação da República",
            details: "Mudança do Brasil Império para a República em 1889.",
            startedYear: 1889,
            endedYear: 1889,
            longitude: -47.9292,
            latitude: -15.7801,
            difficulty: "Médio",
            place: "Rio de Janeiro",
            image: nil,
            image3D: nil,
            quiz: quiz
        ) { _ in }
    }
    
    private func seedBadgeCollectionForHistoria() {
        Database.shared.createBadge(name: "República 1889",
                                    details: "Conquistado ao responder sobre a Proclamação da República.",
                                    image: nil) { bResult in
            if case .success(let badge) = bResult {
                Database.shared.createBadgeCollection(name: "História do Brasil",
                                                      image: nil,
                                                      badges: [badge]) { _ in }
            }
        }
    }
    
    private func seedQuestionsForFrancesa(quiz: CKRecord) {
        Database.shared.createQuestion(text: "Em que ano começou a Revolução Francesa?", tips: "Final do século XVIII", quiz: quiz) { qResult in
            if case .success(let question) = qResult {
                Database.shared.createAnswer(text: "1789", isCorrect: true, question: question) { _ in }
                Database.shared.createAnswer(text: "1804", isCorrect: false, question: question) { _ in }
            }
        }
    }
    
    private func seedEventForFrancesa(quiz: CKRecord) {
        Database.shared.createEvent(
            name: "Queda da Bastilha",
            details: "Símbolo do início da Revolução Francesa.",
            startedYear: 1789,
            endedYear: 1789,
            longitude: 2.3522,
            latitude: 48.8566,
            difficulty: "Médio",
            place: "Paris",
            image: nil,
            image3D: nil,
            quiz: quiz
        ) { _ in }
    }
    
    private func seedBadgeCollectionForFrancesa() {
        Database.shared.createBadge(name: "1789",
                                    details: "Conquistado ao responder sobre a Revolução Francesa.",
                                    image: nil) { bResult in
            if case .success(let badge) = bResult {
                Database.shared.createBadgeCollection(name: "Revolução Francesa",
                                                      image: nil,
                                                      badges: [badge]) { _ in }
            }
        }
    }
    
    private func seedQuestionsForGuerra(quiz: CKRecord) {
        Database.shared.createQuestion(text: "Quando começou a Segunda Guerra Mundial?", tips: "Fim da década de 1930", quiz: quiz) { qResult in
            if case .success(let question) = qResult {
                Database.shared.createAnswer(text: "1939", isCorrect: true, question: question) { _ in }
                Database.shared.createAnswer(text: "1941", isCorrect: false, question: question) { _ in }
            }
        }
    }
    
    private func seedEventForGuerra(quiz: CKRecord) {
        Database.shared.createEvent(
            name: "Invasão da Polônia",
            details: "Ato que marcou o início da Segunda Guerra Mundial.",
            startedYear: 1939,
            endedYear: 1939,
            longitude: 21.0122,
            latitude: 52.2297,
            difficulty: "Difícil",
            place: "Varsóvia",
            image: nil,
            image3D: nil,
            quiz: quiz
        ) { _ in }
    }
    
    private func seedBadgeCollectionForGuerra() {
        Database.shared.createBadge(name: "1939",
                                    details: "Conquistado ao responder sobre a Segunda Guerra Mundial.",
                                    image: nil) { bResult in
            if case .success(let badge) = bResult {
                Database.shared.createBadgeCollection(name: "Segunda Guerra Mundial",
                                                      image: nil,
                                                      badges: [badge]) { _ in }
            }
        }
    }
}
