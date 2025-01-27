//
//  OfflineNotice.swift
//  OpenWeather
//
//  Created by Nikolai Alekseev on 27.01.25.
//

import SwiftUI

struct OfflineNotice: View {
    var body: some View {
        HStack {
            Image(systemName: "wifi.slash")
            Text(Message.offlineNotice)
                .font(.caption)
        }
        .foregroundColor(.white)
        .padding(8)
        .background(Color.red.opacity(0.9))
        .cornerRadius(8)
    }
}
