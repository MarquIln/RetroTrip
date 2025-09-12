//
//  User.swift
//  RetroTrip
//
//  Created by Marcos on 12/09/25.
//

import Foundation
import CloudKit

struct User {
    let id: CKRecord.ID
    let name: String
    let badges: [CKRecord.ID]
}
