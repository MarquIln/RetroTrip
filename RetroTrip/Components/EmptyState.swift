//
//  RetroTripApp.swift
//  RetroTrip
//
//  Created by Marcos on 04/09/25.
//

import SwiftUI

struct EmptyState: View {
    var image: String
    var title: String
    var description: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 65, height: 69)
                .foregroundStyle(Color(.systemGray2))
                .accessibilityHidden(true)
            
            VStack(spacing: 16) {
                Text(title)
                    .fontWeight(.bold)
                
                Text(description)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(description)")
    }
}

