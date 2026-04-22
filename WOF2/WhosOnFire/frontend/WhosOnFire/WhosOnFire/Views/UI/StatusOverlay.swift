//
//  StatusOverlay.swift
//  WhosOnFire
//
//  Created by lending on 4/21/26.
//
import SwiftUI
/**
 Used for displaying the Loading State of fetching players, stats, and calculating analytics
 */
struct StatusOverlay: View {
    let status: String
    
    var body: some View {
        HStack(spacing: 8) {
            if status != "Loaded Players" {
                ProgressView().controlSize(.small)
            } else {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
            }
            Text(status)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.1), radius: 4)
        .padding(.trailing, 20)
        .padding(.top, 60)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}
