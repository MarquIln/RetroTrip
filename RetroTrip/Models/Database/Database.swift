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
    
    let container: CKContainer
    let publicDatabase: CKDatabase
    
    private init() {
        container = CKContainer(identifier: "iCloud.com.retrotrip")
        publicDatabase = container.publicCloudDatabase
    }
    
    func fetchAllRecords(recordType: String,
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
    
    func fetchRecordById(recordID: CKRecord.ID,
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
