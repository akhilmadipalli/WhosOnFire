//
//  StatCompareRow.swift
//  WhosOnFire
//
//  Created by lending on 4/19/26.
//
import SwiftUI
import SwiftData


/**
 StatCompareRow: View

 Compares between two values, the higher value is highlighted.
 */
struct StatCompareRow: View {
    let label: String
    let valueA: String
    let valueB: String
    let higherIsBetter: Bool
    let rawA: Double
    let rawB: Double


    var body: some View {
        HStack {
            Text(valueA)
                .frame(maxWidth: .infinity)
                .bold(higherIsBetter ? rawA >= rawB : rawA <= rawB)
                .foregroundStyle(higherIsBetter ? (rawA >= rawB ? .primary : .secondary) : (rawA <= rawB ? .primary : .secondary))
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(width: 80)
            Text(valueB)
                .frame(maxWidth: .infinity)
                .bold(higherIsBetter ? rawB >= rawA : rawB <= rawA)
                .foregroundStyle(higherIsBetter ? (rawB >= rawA ? .primary : .secondary) : (rawB <= rawA ? .primary : .secondary))
        }
        .padding(.vertical, 4)
    }
}

