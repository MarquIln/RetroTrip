//
//  RetroTripApp.swift
//  RetroTrip
//
//  Created by Marcos on 04/09/25.
//

import SwiftUI
import SwiftData

@main
struct RetroTripApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(gameCenter: GameCenterViewModel())
        }
    }
}
