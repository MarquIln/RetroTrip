//
//  Database+Quiz.swift
//  RetroTrip
//
//  Created by Marcos on 12/09/25.
//

import Foundation
import CloudKit

extension Database {
    func createQuiz(title: String, completion: @escaping (Result<Quiz, Error>) -> Void) {
        let record = CKRecord(recordType: "Quiz")
        record["title"] = title as CKRecordValue

        publicDatabase.save(record) { saved, error in
            if let error = error { completion(.failure(error)) }
            else if let saved = saved {
                completion(.success(Quiz(id: saved.recordID, title: saved["title"] as? String ?? "")))
            }
        }
    }
    
    func fetchAllQuizzes(completion: @escaping (Result<[Quiz], Error>) -> Void) {
        fetchAllRecords(recordType: "Quiz") { result in
            switch result {
            case .success(let records):
                let mapped = records.map {
                    Quiz(id: $0.recordID,
                         title: $0["title"] as? String ?? "")
                }
                completion(.success(mapped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchQuizById(id: CKRecord.ID,
                       completion: @escaping (Result<Quiz, Error>) -> Void) {
        fetchRecordById(recordID: id) { result in
            switch result {
            case .success(let record):
                let quiz = Quiz(id: record.recordID,
                                title: record["title"] as? String ?? "")
                completion(.success(quiz))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
