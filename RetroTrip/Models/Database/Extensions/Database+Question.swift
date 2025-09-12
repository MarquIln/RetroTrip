//
//  Database+Question.swift
//  RetroTrip
//
//  Created by Marcos on 12/09/25.
//

import Foundation
import CloudKit

extension Database {
    func createQuestion(text: String, tips: String?, quiz: CKRecord.ID,
                        completion: @escaping (Result<Question, Error>) -> Void) {
        let record = CKRecord(recordType: "Question")
        record["text"] = text as CKRecordValue
        if let tips = tips { record["tips"] = tips as CKRecordValue }
        record["quiz"] = CKRecord.Reference(recordID: quiz, action: .deleteSelf)

        publicDatabase.save(record) { saved, error in
            if let error = error { completion(.failure(error)) }
            else if let saved = saved {
                completion(.success(Question(
                    id: saved.recordID,
                    text: saved["text"] as? String ?? "",
                    tips: saved["tips"] as? String,
                    quiz: (saved["quiz"] as? CKRecord.Reference)?.recordID
                )))
            }
        }
    }
    
    func fetchAllQuestions(completion: @escaping (Result<[Question], Error>) -> Void) {
        fetchAllRecords(recordType: "Question") { result in
            switch result {
            case .success(let records):
                let mapped = records.map {
                    Question(id: $0.recordID,
                             text: $0["text"] as? String ?? "",
                             tips: $0["tips"] as? String,
                             quiz: ($0["quiz"] as? CKRecord.Reference)?.recordID)
                }
                completion(.success(mapped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchQuestionById(id: CKRecord.ID,
                           completion: @escaping (Result<Question, Error>) -> Void) {
        fetchRecordById(recordID: id) { result in
            switch result {
            case .success(let record):
                let q = Question(id: record.recordID,
                                 text: record["text"] as? String ?? "",
                                 tips: record["tips"] as? String,
                                 quiz: (record["quiz"] as? CKRecord.Reference)?.recordID)
                completion(.success(q))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
