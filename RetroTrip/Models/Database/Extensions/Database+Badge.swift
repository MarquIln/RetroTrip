//
//  Badge.swift
//  RetroTrip
//
//  Created by Marcos on 12/09/25.
//

import Foundation
import CloudKit

extension Database {
    func createBadge(name: String, details: String?, completion: @escaping (Result<Badge, Error>) -> Void) {
        let record = CKRecord(recordType: "Badge")
        record["name"] = name as CKRecordValue
        if let details = details { record["details"] = details as CKRecordValue }

        publicDatabase.save(record) { saved, error in
            if let error = error { completion(.failure(error)) }
            else if let saved = saved {
                completion(.success(Badge(
                    id: saved.recordID,
                    name: saved["name"] as? String ?? "",
                    details: saved["details"] as? String
                )))
            }
        }
    }
    
    func fetchAllBadges(completion: @escaping (Result<[Badge], Error>) -> Void) {
        fetchAllRecords(recordType: "Badge") { result in
            switch result {
            case .success(let records):
                let mapped = records.map {
                    Badge(id: $0.recordID,
                          name: $0["name"] as? String ?? "",
                          details: $0["details"] as? String)
                }
                completion(.success(mapped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchBadgeById(id: CKRecord.ID,
                        completion: @escaping (Result<Badge, Error>) -> Void) {
        fetchRecordById(recordID: id) { result in
            switch result {
            case .success(let record):
                let badge = Badge(id: record.recordID,
                                  name: record["name"] as? String ?? "",
                                  details: record["details"] as? String)
                completion(.success(badge))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
