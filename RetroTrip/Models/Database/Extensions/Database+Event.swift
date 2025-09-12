//
//  Events.swift
//  RetroTrip
//
//  Created by Marcos on 12/09/25.
//

import Foundation
import CloudKit

extension Database {
    func createEvent(name: String, details: String?, startedYear: Int, endedYear: Int,
                     longitude: Double, latitude: Double, difficulty: String?, place: String?,
                     quiz: CKRecord.ID, completion: @escaping (Result<Event, Error>) -> Void) {
        let record = CKRecord(recordType: "Event")
        record["name"] = name as CKRecordValue
        if let details = details { record["details"] = details as CKRecordValue }
        record["startedYear"] = startedYear as CKRecordValue
        record["endedYear"] = endedYear as CKRecordValue
        record["longitude"] = longitude as CKRecordValue
        record["latitude"] = latitude as CKRecordValue
        if let difficulty = difficulty { record["difficulty"] = difficulty as CKRecordValue }
        if let place = place { record["place"] = place as CKRecordValue }
        record["quiz"] = CKRecord.Reference(recordID: quiz, action: .deleteSelf)

        publicDatabase.save(record) { saved, error in
            if let error = error { completion(.failure(error)) }
            else if let saved = saved {
                completion(.success(Event(
                    id: saved.recordID,
                    name: saved["name"] as? String ?? "",
                    details: saved["details"] as? String,
                    startedYear: saved["startedYear"] as? Int ?? 0,
                    endedYear: saved["endedYear"] as? Int ?? 0,
                    longitude: saved["longitude"] as? Double ?? 0.0,
                    latitude: saved["latitude"] as? Double ?? 0.0,
                    difficulty: saved["difficulty"] as? String,
                    place: saved["place"] as? String,
                    quiz: (saved["quiz"] as? CKRecord.Reference)?.recordID
                )))
            }
        }
    }
    
    func fetchAllEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        fetchAllRecords(recordType: "Event") { result in
            switch result {
            case .success(let records):
                let mapped = records.map {
                    Event(
                        id: $0.recordID,
                        name: $0["name"] as? String ?? "",
                        details: $0["details"] as? String,
                        startedYear: $0["startedYear"] as? Int ?? 0,
                        endedYear: $0["endedYear"] as? Int ?? 0,
                        longitude: $0["longitude"] as? Double ?? 0.0,
                        latitude: $0["latitude"] as? Double ?? 0.0,
                        difficulty: $0["difficulty"] as? String,
                        place: $0["place"] as? String,
                        quiz: ($0["quiz"] as? CKRecord.Reference)?.recordID
                    )
                }
                completion(.success(mapped))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchEventById(id: CKRecord.ID,
                        completion: @escaping (Result<Event, Error>) -> Void) {
        fetchRecordById(recordID: id) { result in
            switch result {
            case .success(let record):
                let event = Event(
                    id: record.recordID,
                    name: record["name"] as? String ?? "",
                    details: record["details"] as? String,
                    startedYear: record["startedYear"] as? Int ?? 0,
                    endedYear: record["endedYear"] as? Int ?? 0,
                    longitude: record["longitude"] as? Double ?? 0.0,
                    latitude: record["latitude"] as? Double ?? 0.0,
                    difficulty: record["difficulty"] as? String,
                    place: record["place"] as? String,
                    quiz: (record["quiz"] as? CKRecord.Reference)?.recordID
                )
                completion(.success(event))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
