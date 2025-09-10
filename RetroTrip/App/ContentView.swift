//
//  ContentView.swift
//  RetroTrip
//
//  Created by Marcos on 04/09/25.
//

import SwiftUI

struct ContentView: View {
    var gameCenter: GameCenterViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if gameCenter.isAuthenticated {
                    Text("Bem-vindo, \(gameCenter.playerName)!")
                } else {
                    Text("Conectando ao Game Center...")
                }
                NavigationLink("Button") {
                    Home(name: gameCenter.playerName)
                }
                Button("Logout") {
                    print(gameCenter.playerName)
                }
            }
            .onAppear {
                print("Teste" + gameCenter.playerName)
                gameCenter.authenticate()
                print("Teste" + gameCenter.playerName)
            }
        }
        
    }
}
