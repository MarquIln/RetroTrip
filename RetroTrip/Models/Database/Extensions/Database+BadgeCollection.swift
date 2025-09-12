//
//  BadgeCollection.swift
//  RetroTrip
//
//  Created by Marcos on 12/09/25.
//

import Foundation
import CloudKit

extension Database {
    func createBadgeCollection(name: String, badgeIds: [CKRecord.ID], completion: @escaping (Result<BadgeCollection, Error>) -> Void) {
        let record = CKRecord(recordType: "BadgeCollection")
        record["name"] = name as CKRecordValue
        record["badges"] = badgeIds.map { CKRecord.Reference(recordID: $0, action: .none) } as CKRecordValue

        publicDatabase.save(record) { saved, error in
            if let error = error { completion(.failure(error)) }
            else if let saved = saved {
                completion(.success(BadgeCollection(
                    id: saved.recordID,
                    name: saved["name"] as? String ?? "",
                    badges: (saved["badges"] as? [CKRecord.Reference])?.map { $0.recordID } ?? []
                )))
            }
        }
    }
    
    func fetchAllBadgeCollections(completion: @escaping (Result<[BadgeCollection], Error>) -> Void) {
        fetchAllRecords(recordType: "BadgeCollection") { result in
            switch result {
            case .success(let records):
                let mapped = records.map {
                    BadgeCollection(
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
    
    func fetchBadgeCollectionById(id: CKRecord.ID,
                                  completion: @escaping (Result<BadgeCollection, Error>) -> Void) {
        fetchRecordById(recordID: id) { result in
            switch result {
            case .success(let record):
                let collection = BadgeCollection(
                    id: record.recordID,
                    name: record["name"] as? String ?? "",
                    badges: (record["badges"] as? [CKRecord.Reference])?.map { $0.recordID } ?? []
                )
                completion(.success(collection))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
