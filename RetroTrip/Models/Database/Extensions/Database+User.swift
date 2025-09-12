//
//  User.swift
//  RetroTrip
//
//  Created by Marcos on 12/09/25.
//

import Foundation
import CloudKit

extension Database {
    func createUser(name: String,
                    badges: [CKRecord],
                    completion: @escaping (Result<User, Error>) -> Void) {
        let record = CKRecord(recordType: "User")
        record["name"] = name as CKRecordValue
        record["badges"] = badges.map {
            CKRecord.Reference(recordID: $0.recordID, action: .none)
        } as CKRecordValue
        
        publicDatabase.save(record) { saved, error in
            if let error = error { completion(.failure(error)) }
            else if let saved = saved {
                let user = User(
                    id: saved.recordID,
                    name: saved["name"] as? String ?? "",
                    badges: (saved["badges"] as? [CKRecord.Reference])?.map { $0.recordID } ?? []
                )
                completion(.success(user))
            }
        }
    }
    
    func fetchAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        fetchAllRecords(recordType: "User") { result in
            switch result {
            case .success(let records):
                let mapped = records.map {
                    User(
                        id: $0.recordID,
                        name: $0["name"] as? String ?? "",
                        badges: ($0["badges"] as? [CKRecord.Reference])?.map { $0.recordID } ?? []
                    )
                }
                completion(.success(mapped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchUserById(id: CKRecord.ID,
                       completion: @escaping (Result<User, Error>) -> Void) {
        fetchRecordById(recordID: id) { result in
            switch result {
            case .success(let record):
                let user = User(
                    id: record.recordID,
                    name: record["name"] as? String ?? "",
                    badges: (record["badges"] as? [CKRecord.Reference])?.map { $0.recordID } ?? []
                )
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
