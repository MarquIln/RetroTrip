//
//  GameCenterManager.swift
//  RetroTrip
//
//  Created by Marcos on 10/09/25.
//

import Foundation
import GameKit

class GameCenterManager: NSObject {
    static let shared = GameCenterManager()

    var isAuthenticated: Bool {
        GKLocalPlayer.local.isAuthenticated
    }
    
    var playerName: String {
        GKLocalPlayer.local.displayName
    }
    
    func authenticateUser(completion: @escaping (Bool, Error?) -> Void) {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let vc = viewController {
                if let rootVC = UIApplication.shared.connectedScenes
                    .compactMap({ ($0 as? UIWindowScene)?.windows.first?.rootViewController })
                    .first {
                    rootVC.present(vc, animated: true)
                }
            } else if GKLocalPlayer.local.isAuthenticated {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
}
