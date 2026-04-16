////
////  CompareView.swift
////  WhosOnFire
////
////  Created by Akhil Madipalli on 2/25/26.
////
//import SwiftUI
//
//
///**
// StatCompareRow: View
// 
// Compares between two values, the higher value is highlighted.
// 
// 
// */
//struct StatCompareRow: View {
//    let label: String
//    let valueA: String
//    let valueB: String
//    let higherIsBetter: Bool
//    let rawA: Double
//    let rawB: Double
//
//    var body: some View {
//        HStack {
//            Text(valueA)
//                .frame(maxWidth: .infinity)
//                .bold(higherIsBetter ? rawA >= rawB : rawA <= rawB)
//                .foregroundStyle(higherIsBetter ? (rawA >= rawB ? .primary : .secondary) : (rawA <= rawB ? .primary : .secondary))
//            Text(label)
//                .font(.caption)
//                .foregroundStyle(.secondary)
//                .frame(width: 80)
//            Text(valueB)
//                .frame(maxWidth: .infinity)
//                .bold(higherIsBetter ? rawB >= rawA : rawB <= rawA)
//                .foregroundStyle(higherIsBetter ? (rawB >= rawA ? .primary : .secondary) : (rawB <= rawA ? .primary : .secondary))
//        }
//        .padding(.vertical, 4)
//    }
//}
//
//struct CompareView: View {
//    @State private var playerA: Player? = nil
//    @State private var playerB: Player? = nil
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 24) {
//                // Player selectors
//                HStack(spacing: 16) {
//                    PlayerPicker(label: "Player 1", selected: $playerA)
//                    PlayerPicker(label: "Player 2", selected: $playerB)
//                }
//                .padding(.horizontal)
//
//                // Comparison rows
//                if let a = playerA, let b = playerB {
//                    VStack(spacing: 0) {
//                        // Column headers
//                        HStack {
//                            Text(a.name.components(separatedBy: " ").last ?? a.name)
//                                .font(.caption).bold()
//                                .frame(maxWidth: .infinity)
//                            Text("STAT")
//                                .font(.caption2)
//                                .foregroundStyle(.secondary)
//                                .frame(width: 80)
//                            Text(b.name.components(separatedBy: " ").last ?? b.name)
//                                .font(.caption).bold()
//                                .frame(maxWidth: .infinity)
//                        }
//                        .padding(.horizontal)
//                        .padding(.bottom, 8)
//
//                        Divider()
//
//                        Group {
//                            StatCompareRow(label: "Pass Yds",
//                                          valueA: "\(Int(a.passingYards))", valueB: "\(Int(b.passingYards))",
//                                          higherIsBetter: true, rawA: a.passingYards, rawB: b.passingYards)
//                            Divider()
//                            
//                            StatCompareRow(label: "Pass TDs",
//                                          valueA: "\(a.passingTds)", valueB: "\(b.passingTds)",
//                                          higherIsBetter: true, rawA: Double(a.passingTds), rawB: Double(b.passingTds))
//                            Divider()
//                            
//                            StatCompareRow(label: "Fantasy Pts",
//                                          valueA: String(format: "%.1f", a.fantasyPointsPpr),
//                                          valueB: String(format: "%.1f", b.fantasyPointsPpr),
//                                          higherIsBetter: true, rawA: a.fantasyPointsPpr, rawB: b.fantasyPointsPpr)
//                            Divider()
//                            
//                            StatCompareRow(label: "Pass EPA",
//                                          valueA: String(format: "+%.2f", a.passingEpa),
//                                          valueB: String(format: "+%.2f", b.passingEpa),
//                                          higherIsBetter: true, rawA: a.passingEpa, rawB: b.passingEpa)
//                            Divider()
//                            
//                            StatCompareRow(label: "Rush Yds",
//                                          valueA: "\(Int(a.rushingYards))", valueB: "\(Int(b.rushingYards))",
//                                          higherIsBetter: true, rawA: a.rushingYards, rawB: b.rushingYards)
//                        }
//                        .padding(.horizontal)
//                    }
//                    .background(Color.gray.opacity(0.05))
//                    .cornerRadius(12)
//                    .padding(.horizontal)
//                } else {
//                    Text("Select two players to compare")
//                        .foregroundStyle(.secondary)
//                        .padding(.top, 40)
//                }
//            }
//            .padding(.top)
//        }
//        .navigationTitle("Compare")
//    }
//}
//
//
///**
// Let's you select from a list of all current players.
// 
// */
//struct PlayerPicker: View {
//    let label: String
//    @Binding var selected: Player?
//
//    var body: some View {
//        Menu {
//            ForEach(MockData.samplePlayers) { player in
//                Button(player.name) {
//                    selected = player
//                }
//            }
//            if selected != nil {
//                Divider()
//                Button("Clear", role: .destructive) { selected = nil }
//            }
//        } label: {
//            VStack(spacing: 6) {
//                if let player = selected {
//                    Text("🔥")
//                        .font(.title2)
//                    Text(player.name)
//                        .font(.caption).bold()
//                        .multilineTextAlignment(.center)
//                    Text(player.team)
//                        .font(.caption2)
//                        .foregroundStyle(.secondary)
//                } else {
//                    Image(systemName: "plus.circle")
//                        .font(.title2)
//                        .foregroundStyle(.blue)
//                    Text(label)
//                        .font(.caption)
//                        .foregroundStyle(.blue)
//                }
//            }
//            .frame(maxWidth: .infinity)
//            .padding()
//            .background(Color.gray.opacity(0.1))
//            .cornerRadius(12)
//        }
//    }
//}
//
//#Preview {
//    NavigationStack {
//        CompareView()
//    }
//}
