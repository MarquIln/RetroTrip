//
//  GameCenterManagerVM.swift
//  RetroTrip
//
//  Created by Marcos on 10/09/25.
//

import Foundation

@Observable
class GameCenterViewModel {
    var isAuthenticated = false
    var playerName: String = ""
    
    private let service: GameCenterManager
    
    init(service: GameCenterManager = .shared) {
        self.service = service
        authenticate()
    }
    
    func authenticate() {
        service.authenticateUser { [weak self] success, error in
            DispatchQueue.main.async { [self] in
                self?.isAuthenticated = success
                if success {
                    self?.playerName = self?.service.playerName ?? ""
                    print(self!.isAuthenticated)
                    print(self!.playerName)
                } else {
                    self?.playerName = "Convidado"
                }
            }
        }
    }
}
