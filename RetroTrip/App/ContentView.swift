//
//  ContentView.swift
//  RetroTrip
//
//  Created by Marcos on 04/09/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isReady = false
    
    var body: some View {
        Group {
            if isReady {
                NavigationStack {
                    Text("📚 App rodando normalmente")
                }
            } else {
                ProgressView("Carregando dados iniciais...")
            }
        }
        .onAppear {
            Seed.shared.runSeedIfNeeded {
                DispatchQueue.main.async {
                    self.isReady = true
                }
            }
        }
    }
}
