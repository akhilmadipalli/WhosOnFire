//
//  ComparisonModule.swift
//  WhosOnFire
//
//  Created by lending on 4/20/26.
//
import SwiftData
import SwiftUI
import Charts
import DDSpiderChart
import Accelerate

struct ComparisonModule: View {
    var statA: PlayerSeasonStatDTO?
    var statB: PlayerSeasonStatDTO?
    var playerA: Player
    var playerB: Player?
    var baseline: PlayerSeasonStatDTO? = nil
    var similarityScore: Double {
        print("Calculating similarity score")
        guard let sA = statA,
                  let sB = statB,
                  let base = baseline else {
                return 0.0
        }
        let v1 = sA.toVector(baseline: base, position: playerA.position)
        let v2 = sB.toVector(baseline: base, position: playerA.position)
        // Check same vec size
        guard v1.count == v2.count else { return 0.0 }
        
        let dotProduct = vDSP.dot(v1, v2)
        let magnitude1 = sqrt(vDSP.sumOfSquares(v1))
        let magnitude2 = sqrt(vDSP.sumOfSquares(v2))
        guard magnitude2 > 0 && magnitude2 > 0 else { return 0.0 }
        let score = max(0, min(dotProduct / (magnitude1 * magnitude2), 1.0))
        print(score)
        return score
    }


    let offensePositions = ["RB","TE","WR","FB"]
    let defensePositions = ["DE", "DT", "LB", "CB", "S", "DL", "DB"]
    
    var body: some View {
        
        SimilarityDonutChart(score: similarityScore)
        if playerA.position == "QB" {
            StatCompareRow(
                label: "Passing Yards",
                valueA: (statA?.passing_yards ?? 0).to2dp(),
                valueB: (statB?.passing_yards ?? 0).to2dp(),
                higherIsBetter: true,
                rawA: statA?.passing_yards ?? 0,
                rawB: statB?.passing_yards ?? 0
            )

            StatCompareRow(
                label: "Passing Touchdowns",
                valueA: Double(statA?.passing_tds ?? 0).to2dp(),
                valueB: Double(statB?.passing_tds ?? 0).to2dp(),
                higherIsBetter: true,
                rawA: Double(statA?.passing_tds ?? 0),
                rawB: Double(statB?.passing_tds ?? 0)
            )

            StatCompareRow(
                label: "Passing Interceptions",
                valueA: Double(statA?.passing_interceptions ?? 0).to2dp(),
                valueB: Double(statB?.passing_interceptions ?? 0).to2dp(),
                higherIsBetter: true,
                rawA: Double(statA?.passing_interceptions ?? 0),
                rawB: Double(statB?.passing_interceptions ?? 0)
            )

            StatCompareRow(
                label: "Rushing Yards",
                valueA: Double(statA?.rushing_yards ?? 0).to2dp(),
                valueB: Double(statB?.rushing_yards ?? 0).to2dp(),
                higherIsBetter: true,
                rawA: Double(statA?.rushing_yards ?? 0),
                rawB: Double(statB?.rushing_yards ?? 0)
            )

            StatCompareRow(
                label: "Passing EPA",
                valueA: Double(statA?.passing_epa ?? 0).to2dp(),
                valueB: Double(statB?.passing_epa ?? 0).to2dp(),
                higherIsBetter: true,
                rawA: Double(statA?.passing_epa ?? 0),
                rawB: Double(statB?.passing_epa ?? 0)
            )
        }

        else if offensePositions.contains(playerA.position) {

            StatCompareRow(
                label: "Rushing Yards",
                valueA: (statA?.rushing_yards ?? 0).to2dp(),
                valueB: (statB?.rushing_yards ?? 0).to2dp(),
                higherIsBetter: true,
                rawA: statA?.rushing_yards ?? 0,
                rawB: statB?.rushing_yards ?? 0
            )

            StatCompareRow(
                label: "Receiving Yards",
                valueA: (statA?.receiving_yards ?? 0).to2dp(),
                valueB: (statB?.receiving_yards ?? 0).to2dp(),
                higherIsBetter: true,
                rawA: statA?.receiving_yards ?? 0,
                rawB: statB?.receiving_yards ?? 0
            )

            StatCompareRow(
                label: "Receiving Touchdowns",
                valueA: Double(statA?.receiving_tds ?? 0).to2dp(),
                valueB: Double(statB?.receiving_tds ?? 0).to2dp(),
                higherIsBetter: true,
                rawA: Double(statA?.receiving_tds ?? 0),
                rawB: Double(statB?.receiving_tds ?? 0)
            )

            StatCompareRow(
                label: "Rushing Touchdowns",
                valueA: Double(statA?.rushing_tds ?? 0).to2dp(),
                valueB: Double(statB?.rushing_tds ?? 0).to2dp(),
                higherIsBetter: true,
                rawA: Double(statA?.rushing_tds ?? 0),
                rawB: Double(statB?.rushing_tds ?? 0)
            )

            StatCompareRow(
                label: "Receiving EPA",
                valueA: (statA?.receiving_epa ?? 0).to2dp(),
                valueB: (statB?.receiving_epa ?? 0).to2dp(),
                higherIsBetter: true,
                rawA: statA?.receiving_epa ?? 0,
                rawB: statB?.receiving_epa ?? 0
            )
        }

        else if defensePositions.contains(playerA.position) {

            StatCompareRow(
                label: "Sacks",
                valueA: Double(statA?.def_sacks ?? 0).to2dp(),
                valueB: Double(statB?.def_sacks ?? 0).to2dp(),
                higherIsBetter: true,
                rawA: Double(statA?.def_sacks ?? 0),
                rawB: Double(statB?.def_sacks ?? 0)
            )

            StatCompareRow(
                label: "Interceptions",
                valueA: Double(statA?.def_interceptions ?? 0).to2dp(),
                valueB: Double(statB?.def_interceptions ?? 0).to2dp(),
                higherIsBetter: true,
                rawA: Double(statA?.def_interceptions ?? 0),
                rawB: Double(statB?.def_interceptions ?? 0)
            )

            StatCompareRow(
                label: "Fumbles Forced",
                valueA: Double(statA?.def_fumbles_forced ?? 0).to2dp(),
                valueB: Double(statB?.def_fumbles_forced ?? 0).to2dp(),
                higherIsBetter: true,
                rawA: Double(statA?.def_fumbles_forced ?? 0),
                rawB: Double(statB?.def_fumbles_forced ?? 0)
            )
        }
        RadarModule(statA: statA, statB: statB, position: playerA.position, baseline: baseline)
    }
}

struct RadarModule: View {
    var statA: PlayerSeasonStatDTO?
    var statB: PlayerSeasonStatDTO?
    var position: String
    var baseline: PlayerSeasonStatDTO?
    let offensePositions = ["RB","TE","WR","FB"]
    let defensePositions = ["DE", "DT", "LB", "CB", "S", "DL", "DB"]
    var radarAxes: [String] {
        if position == "QB" {
            return ["Pass Yds", "Pass TD", "INT", "Rush Yds", "EPA"]
        } else if offensePositions.contains(position) {
            return ["Rush Yds", "Rec Yds", "Rush TD", "Rec TD", "Rec EPA"]
        } else {
            return ["Sacks", "INT", "FF", "Other","Fantasy"]
        }
    }
    var radarValues: [Double] {
        guard let p = statA,
              let avg = statB
        else { return [0,0,0,0,0] }
        let playerStats: [Double]
        if (position == "QB") {
           playerStats = [
            normalize(value: p.passing_yards, avg: avg.passing_yards),
            normalize(value: Double(p.passing_tds), avg: Double(avg.passing_tds)),
            1-normalize(value:Double(p.passing_interceptions), avg:Double(avg.passing_interceptions)),
            normalize(value: p.rushing_yards, avg: avg.rushing_yards),
            normalize(value: p.passing_epa, avg: avg.passing_epa)
           ]
        } else if offensePositions.contains(position) {
            playerStats = [
                normalize(value: p.rushing_yards, avg: avg.rushing_yards),
                normalize(value: p.receiving_yards, avg: avg.receiving_yards),
                normalize(value: Double(p.rushing_tds), avg: Double(avg.rushing_tds)),
                normalize(value: Double(p.receiving_tds), avg: Double(avg.receiving_tds)),
                normalize(value: p.receiving_epa, avg: avg.receiving_epa)
            ]
        } else {
            playerStats = [
                normalize(value: p.def_sacks, avg: avg.def_sacks),
                normalize(value: Double(p.def_interceptions), avg: Double(avg.def_interceptions)),
                normalize(value: Double(p.def_fumbles_forced), avg: Double(avg.def_fumbles_forced)),
                0,
                normalize(value: p.fantasy_points_ppr, avg: avg.fantasy_points_ppr)
            ]
        }
        print(playerStats)
        
        return playerStats
    }
    var body: some View {
        DDSpiderChart(
            axes: radarAxes,
            values: [
                DDSpiderChartEntries(
                    values: Array(repeating: 0.5, count: radarAxes.count).map(Float.init),
                    color: .orange.opacity(0.3)
                ),
                DDSpiderChartEntries(
                    values: radarValues.map(Float.init),
                    color: .red.opacity(0.7)
                )
            ],
            fontTitle: .boldSystemFont(ofSize: 16),
            textColor: .black
        )
        .frame(width: 300, height: 300)
        
    }
    /**
     Normalizes relative to an average, where 1 is the average
     
     */
    func normalize(value: Double, avg: Double) -> Double {
        guard avg != 0 else { return 0 }
        // This gives a 0.5 for average, and scales more aggressively
        let ratio = value / (avg * 2.0)
        return max(0, min(ratio, 1.0))
    }
}

struct SimilarityDonutChart: View {
    var score: Double?
    var body: some View {
        Chart {
            SectorMark(
                angle: .value("Similarity", score!),
                innerRadius: .ratio(0.8),
                angularInset: 1.5
            )
            .cornerRadius(5)
            .foregroundStyle(Color.orange)
        }
    }
    
}
