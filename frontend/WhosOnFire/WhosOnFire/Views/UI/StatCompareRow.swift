import SwiftUI

struct StatCompareRow: View {
    let label: String
    let valueA: String
    let valueB: String
    let higherIsBetter: Bool
    let rawA: Double
    let rawB: Double

    private var aWins: Bool { higherIsBetter ? rawA > rawB : rawA < rawB }
    private var bWins: Bool { higherIsBetter ? rawB > rawA : rawB < rawA }

    var body: some View {
        HStack {
            // LEFT SIDE: Player A
            HStack(spacing: 4) {
                if aWins { Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                        .font(.caption) }
                Spacer()
                Text(valueA)
                    .bold(aWins)
                    .foregroundStyle(aWins ? .primary : .secondary)
            }
            .frame(maxWidth: .infinity)
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(width: 85)
            HStack(spacing: 4) {
                Text(valueB)
                    .bold(bWins)
                    .foregroundStyle(bWins ? .primary : .secondary)
                Spacer()
                if bWins { Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                        .font(.caption) }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
    }
}
