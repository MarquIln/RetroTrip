//
//  Database.swift
//  RetroTrip
//
//  Created by Marcos on 11/09/25.
//

import Foundation
import CloudKit

class Database {
    static let shared = Database()
    
    private let container: CKContainer
    private let publicDatabase: CKDatabase
    
    private init() {
        container = CKContainer(identifier: "iCloud.com.retrotrip")
        publicDatabase = container.publicCloudDatabase
    }
    
    // MARK: - Quiz (Create)
    func createQuiz(title: String, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let quiz = CKRecord(recordType: "Quiz")
        quiz["title"] = title as CKRecordValue
        
        publicDatabase.save(quiz) { record, error in
            if let error = error {
                completion(.failure(error))
            } else if let record = record {
                completion(.success(record))
            }
        }
    }
    
    // MARK: - Quiz (Fetch all raw CKRecord)
    func fetchQuizzes(completion: @escaping (Result<[CKRecord], Error>) -> Void) {
        let query = CKQuery(recordType: "Quiz", predicate: NSPredicate(value: true))
        let operation = CKQueryOperation(query: query)
        
        var fetchedRecords: [CKRecord] = []
        
        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                fetchedRecords.append(record)
            case .failure(let error):
                print("❌ Erro ao buscar \(recordID): \(error)")
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success:
                completion(.success(fetchedRecords))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        publicDatabase.add(operation)
    }
}

// ======================================================
// MARK: - Generic fetch helpers
// ======================================================

extension Database {
    private func fetchAllRecords(recordType: String,
                                 completion: @escaping (Result<[CKRecord], Error>) -> Void) {
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
        let operation = CKQueryOperation(query: query)
        
        var results: [CKRecord] = []
        
        operation.recordMatchedBlock = { _, result in
            if case .success(let record) = result {
                results.append(record)
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success:
                completion(.success(results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        publicDatabase.add(operation)
    }
    
    private func fetchRecordById(recordID: CKRecord.ID,
                                 completion: @escaping (Result<CKRecord, Error>) -> Void) {
        publicDatabase.fetch(withRecordID: recordID) { record, error in
            if let error = error {
                completion(.failure(error))
            } else if let record = record {
                completion(.success(record))
            }
        }
    }
}

// ======================================================
// MARK: - Fetch DTOs
// ======================================================

extension Database {
    // MARK: - Quiz
    func fetchAllQuizzes(completion: @escaping (Result<[QuizDTO], Error>) -> Void) {
        fetchAllRecords(recordType: "Quiz") { result in
            switch result {
            case .success(let records):
                let mapped = records.map {
                    QuizDTO(id: $0.recordID, title: $0["title"] as? String ?? "")
                }
                completion(.success(mapped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchQuizById(id: CKRecord.ID,
                       completion: @escaping (Result<QuizDTO, Error>) -> Void) {
        fetchRecordById(recordID: id) { result in
            switch result {
            case .success(let record):
                let quiz = QuizDTO(id: record.recordID,
                                   title: record["title"] as? String ?? "")
                completion(.success(quiz))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Question
    func fetchAllQuestions(completion: @escaping (Result<[QuestionDTO], Error>) -> Void) {
        fetchAllRecords(recordType: "Question") { result in
            switch result {
            case .success(let records):
                let mapped = records.map {
                    QuestionDTO(id: $0.recordID,
                                question: $0["question"] as? String ?? "",
                                tips: $0["tips"] as? String ?? "",
                                quizRef: $0["quiz"] as? CKRecord.Reference)
                }
                completion(.success(mapped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchQuestionById(id: CKRecord.ID,
                           completion: @escaping (Result<QuestionDTO, Error>) -> Void) {
        fetchRecordById(recordID: id) { result in
            switch result {
            case .success(let record):
                let q = QuestionDTO(id: record.recordID,
                                    question: record["question"] as? String ?? "",
                                    tips: record["tips"] as? String ?? "",
                                    quizRef: record["quiz"] as? CKRecord.Reference)
                completion(.success(q))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Answer
    func fetchAllAnswers(completion: @escaping (Result<[AnswerDTO], Error>) -> Void) {
        fetchAllRecords(recordType: "Answer") { result in
            switch result {
            case .success(let records):
                let mapped = records.map {
                    AnswerDTO(id: $0.recordID,
                              answer: $0["answer"] as? String ?? "",
                              isCorrect: $0["isCorrect"] as? Bool ?? false,
                              questionRef: $0["question"] as? CKRecord.Reference)
                }
                completion(.success(mapped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchAnswerById(id: CKRecord.ID,
                         completion: @escaping (Result<AnswerDTO, Error>) -> Void) {
        fetchRecordById(recordID: id) { result in
            switch result {
            case .success(let record):
                let a = AnswerDTO(id: record.recordID,
                                  answer: record["answer"] as? String ?? "",
                                  isCorrect: record["isCorrect"] as? Bool ?? false,
                                  questionRef: record["question"] as? CKRecord.Reference)
                completion(.success(a))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Event
    func fetchAllEvents(completion: @escaping (Result<[EventDTO], Error>) -> Void) {
        fetchAllRecords(recordType: "Event") { result in
            switch result {
            case .success(let records):
                let mapped = records.map {
                    EventDTO(id: $0.recordID,
                             name: $0["name"] as? String ?? "",
                             details: $0["details"] as? String ?? "",
                             startedYear: $0["startedYear"] as? Int ?? 0,
                             endedYear: $0["endedYear"] as? Int ?? 0,
                             longitude: $0["longitude"] as? Double ?? 0.0,
                             latitude: $0["latitude"] as? Double ?? 0.0,
                             difficulty: $0["difficulty"] as? String ?? "",
                             place: $0["place"] as? String ?? "",
                             quizRef: $0["quiz"] as? CKRecord.Reference)
                }
                completion(.success(mapped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchEventById(id: CKRecord.ID,
                        completion: @escaping (Result<EventDTO, Error>) -> Void) {
        fetchRecordById(recordID: id) { result in
            switch result {
            case .success(let record):
                let event = EventDTO(id: record.recordID,
                                     name: record["name"] as? String ?? "",
                                     details: record["details"] as? String ?? "",
                                     startedYear: record["startedYear"] as? Int ?? 0,
                                     endedYear: record["endedYear"] as? Int ?? 0,
                                     longitude: record["longitude"] as? Double ?? 0.0,
                                     latitude: record["latitude"] as? Double ?? 0.0,
                                     difficulty: record["difficulty"] as? String ?? "",
                                     place: record["place"] as? String ?? "",
                                     quizRef: record["quiz"] as? CKRecord.Reference)
                completion(.success(event))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Badge
    func fetchAllBadges(completion: @escaping (Result<[BadgeDTO], Error>) -> Void) {
        fetchAllRecords(recordType: "Badge") { result in
            switch result {
            case .success(let records):
                let mapped = records.map {
                    BadgeDTO(id: $0.recordID,
                             name: $0["name"] as? String ?? "",
                             details: $0["details"] as? String ?? "")
                }
                completion(.success(mapped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchBadgeById(id: CKRecord.ID,
                        completion: @escaping (Result<BadgeDTO, Error>) -> Void) {
        fetchRecordById(recordID: id) { result in
            switch result {
            case .success(let record):
                let badge = BadgeDTO(id: record.recordID,
                                     name: record["name"] as? String ?? "",
                                     details: record["details"] as? String ?? "")
                completion(.success(badge))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - BadgeCollection
    func fetchAllBadgeCollections(completion: @escaping (Result<[BadgeCollectionDTO], Error>) -> Void) {
        fetchAllRecords(recordType: "BadgeCollection") { result in
            switch result {
            case .success(let records):
                let mapped = records.map {
                    BadgeCollectionDTO(id: $0.recordID,
                                       name: $0["name"] as? String ?? "",
                                       badgeRefs: ($0["badges"] as? [CKRecord.Reference]) ?? [])
                }
                completion(.success(mapped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchBadgeCollectionById(id: CKRecord.ID,
                                  completion: @escaping (Result<BadgeCollectionDTO, Error>) -> Void) {
        fetchRecordById(recordID: id) { result in
            switch result {
            case .success(let record):
                let collection = BadgeCollectionDTO(id: record.recordID,
                                                    name: record["name"] as? String ?? "",
                                                    badgeRefs: (record["badges"] as? [CKRecord.Reference]) ?? [])
                completion(.success(collection))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - User
    func fetchAllUsers(completion: @escaping (Result<[UserDTO], Error>) -> Void) {
        fetchAllRecords(recordType: "User") { result in
            switch result {
            case .success(let records):
                let mapped = records.map {
                    UserDTO(id: $0.recordID,
                            name: $0["name"] as? String ?? "",
                            badgeRefs: ($0["badges"] as? [CKRecord.Reference]) ?? [])
                }
                completion(.success(mapped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUserById(id: CKRecord.ID,
                       completion: @escaping (Result<UserDTO, Error>) -> Void) {
        fetchRecordById(recordID: id) { result in
            switch result {
            case .success(let record):
                let user = UserDTO(id: record.recordID,
                                   name: record["name"] as? String ?? "",
                                   badgeRefs: (record["badges"] as? [CKRecord.Reference]) ?? [])
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// ======================================================
// MARK: - Create methods for all entities
// ======================================================

extension Database {
    
    func createQuestion(text: String, tips: String, quiz: CKRecord,
                        completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "Question")
        record["question"] = text as CKRecordValue
        record["tips"] = tips as CKRecordValue
        record["quiz"] = CKRecord.Reference(recordID: quiz.recordID, action: .deleteSelf)
        
        publicDatabase.save(record) { saved, error in
            if let error = error { completion(.failure(error)) }
            else if let saved = saved { completion(.success(saved)) }
        }
    }
    
    func createAnswer(text: String, isCorrect: Bool, question: CKRecord,
                      completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "Answer")
        record["answer"] = text as CKRecordValue
        record["isCorrect"] = isCorrect as CKRecordValue
        record["question"] = CKRecord.Reference(recordID: question.recordID, action: .deleteSelf)
        
        publicDatabase.save(record) { saved, error in
            if let error = error { completion(.failure(error)) }
            else if let saved = saved { completion(.success(saved)) }
        }
    }
    
    func createEvent(name: String, details: String, startedYear: Int, endedYear: Int,
                     longitude: Double, latitude: Double, difficulty: String, place: String,
                     image: CKAsset?, image3D: CKAsset?, quiz: CKRecord,
                     completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "Event")
        record["name"] = name as CKRecordValue
        record["details"] = details as CKRecordValue
        record["startedYear"] = startedYear as CKRecordValue
        record["endedYear"] = endedYear as CKRecordValue
        record["longitude"] = longitude as CKRecordValue
        record["latitude"] = latitude as CKRecordValue
        record["difficulty"] = difficulty as CKRecordValue
        record["place"] = place as CKRecordValue
        record["quiz"] = CKRecord.Reference(recordID: quiz.recordID, action: .deleteSelf)
        if let image = image { record["image"] = image }
        if let image3D = image3D { record["image3D"] = image3D }
        
        publicDatabase.save(record) { saved, error in
            if let error = error { completion(.failure(error)) }
            else if let saved = saved { completion(.success(saved)) }
        }
    }
    
    func createBadge(name: String, details: String, image: CKAsset?,
                     completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "Badge")
        record["name"] = name as CKRecordValue
        record["details"] = details as CKRecordValue
        if let image = image { record["image"] = image }
        
        publicDatabase.save(record) { saved, error in
            if let error = error { completion(.failure(error)) }
            else if let saved = saved { completion(.success(saved)) }
        }
    }
    
    func createBadgeCollection(name: String, image: CKAsset?, badges: [CKRecord],
                               completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "BadgeCollection")
        record["name"] = name as CKRecordValue
        if let image = image { record["image"] = image }
        record["badges"] = badges.map { CKRecord.Reference(recordID: $0.recordID, action: .none) } as CKRecordValue
        
        publicDatabase.save(record) { saved, error in
            if let error = error { completion(.failure(error)) }
            else if let saved = saved { completion(.success(saved)) }
        }
    }
    
    func createUser(name: String, badges: [CKRecord],
                    completion: @escaping (Result<CKRecord, Error>) -> Void) {
        let record = CKRecord(recordType: "User")
        record["name"] = name as CKRecordValue
        record["badges"] = badges.map { CKRecord.Reference(recordID: $0.recordID, action: .none) } as CKRecordValue
        
        publicDatabase.save(record) { saved, error in
            if let error = error { completion(.failure(error)) }
            else if let saved = saved { completion(.success(saved)) }
        }
    }
}
