//
//  Answer.swift
//  RetroTrip
//
//  Created by Marcos on 12/09/25.
//

import Foundation
import CloudKit

extension Database {
    func createAnswer(text: String, isCorrect: Bool, question: CKRecord.ID,
                      completion: @escaping (Result<Answer, Error>) -> Void) {
        let record = CKRecord(recordType: "Answer")
        record["text"] = text as CKRecordValue
        record["isCorrect"] = isCorrect as CKRecordValue
        record["question"] = CKRecord.Reference(recordID: question, action: .deleteSelf)

        publicDatabase.save(record) { saved, error in
            if let error = error { completion(.failure(error)) }
            else if let saved = saved {
                completion(.success(Answer(
                    id: saved.recordID,
                    text: saved["text"] as? String ?? "",
                    isCorrect: saved["isCorrect"] as? Bool ?? false,
                    question: (saved["question"] as? CKRecord.Reference)?.recordID
                )))
            }
        }
    }
    
    func fetchAllAnswers(completion: @escaping (Result<[Answer], Error>) -> Void) {
        fetchAllRecords(recordType: "Answer") { result in
            switch result {
            case .success(let records):
                let mapped = records.map {
                    Answer(id: $0.recordID,
                           text: $0["text"] as? String ?? "",
                           isCorrect: $0["isCorrect"] as? Bool ?? false,
                           question: ($0["question"] as? CKRecord.Reference)?.recordID)
                }
                completion(.success(mapped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchAnswerById(id: CKRecord.ID,
                         completion: @escaping (Result<Answer, Error>) -> Void) {
        fetchRecordById(recordID: id) { result in
            switch result {
            case .success(let record):
                let a = Answer(id: record.recordID,
                               text: record["text"] as? String ?? "",
                               isCorrect: record["isCorrect"] as? Bool ?? false,
                               question: (record["question"] as? CKRecord.Reference)?.recordID)
                completion(.success(a))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
