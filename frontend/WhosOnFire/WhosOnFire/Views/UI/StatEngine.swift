//
//  StatEngine.swift
//  WhosOnFire
//
//  Created by lending on 4/19/26.
//

import SwiftUI
import SwiftData
import Accelerate
/**
 After we have the raw unfiltered data from SwiftData
 Season: "Year" or "All"
 PlayerID
 
 Returns a PlayerSeasonStatDMO object
 */

class StatEngine {
    // Uses all stats
    static func aggregate(playerID: String, stats: [PlayerSeasonStat], season: String) -> PlayerSeasonStatDTO? {
        let filteredStats = stats.filter { stat in
                let matchesPlayer = stat.player_id == playerID
                let matchesSeason = (season == "All") || (String(stat.season) == season)
                return matchesPlayer && matchesSeason
            }
            guard !filteredStats.isEmpty else { return nil }
            let count = Double(filteredStats.count)
        
            return PlayerSeasonStatDTO(
                        player_id: playerID,
                        season: 0,
                        passing_yards: filteredStats.reduce(0.0) { $0 + $1.passing_yards },
                        passing_tds: filteredStats.reduce(0) { $0 + $1.passing_tds },
                        passing_interceptions: filteredStats.reduce(0) { $0 + $1.passing_interceptions },
                        rushing_yards: filteredStats.reduce(0.0) { $0 + $1.rushing_yards },
                        rushing_tds: filteredStats.reduce(0) { $0 + $1.rushing_tds },
                        receiving_yards: filteredStats.reduce(0.0) { $0 + $1.receiving_yards },
                        receiving_tds: filteredStats.reduce(0) { $0 + $1.receiving_tds },
                        def_sacks: filteredStats.reduce(0.0) { $0 + $1.def_sacks },
                        def_interceptions: filteredStats.reduce(0) { $0 + $1.def_interceptions },
                        def_fumbles_forced: filteredStats.reduce(0) { $0 + $1.def_fumbles_forced },
                        fantasy_points_ppr: filteredStats.reduce(0.0) { $0 + $1.fantasy_points_ppr },
                        passing_epa: filteredStats.reduce(0.0) { $0 + $1.passing_epa } / count,
                        rushing_epa: filteredStats.reduce(0.0) { $0 + $1.rushing_epa } / count,
                        receiving_epa: filteredStats.reduce(0.0) { $0 + $1.receiving_epa } / count
                    )
    }
    
    static func getAverageByPosition(position: String, allPlayers: [Player], allStats: [PlayerSeasonStat]) -> PlayerSeasonStatDTO? {
        let playerIDsInPosition = Set(allPlayers.filter { $0.position == position }.map { $0.id })
        let positionStats = allStats.filter { playerIDsInPosition.contains($0.player_id) }
        
        guard !positionStats.isEmpty else { return nil }
        
        let count = Double(positionStats.count)
        // calculate the aggregations of the positons
            let totalPassYds = positionStats.reduce(0.0) { $0 + $1.passing_yards }
            let totalPassTDs = positionStats.reduce(0) { $0 + $1.passing_tds }
            let totalPassInts = positionStats.reduce(0) { $0 + $1.passing_interceptions }
            let totalRushYds = positionStats.reduce(0.0) { $0 + $1.rushing_yards }
            let totalRushTDs = positionStats.reduce(0) { $0 + $1.rushing_tds }
            let totalRecYds = positionStats.reduce(0.0) { $0 + $1.receiving_yards }
            let totalRecTDs = positionStats.reduce(0) { $0 + $1.receiving_tds }
            let totalSacks = positionStats.reduce(0.0) { $0 + $1.def_sacks }
            let totalDefInts = positionStats.reduce(0) { $0 + $1.def_interceptions }
            let totalFumbles = positionStats.reduce(0) { $0 + $1.def_fumbles_forced }
            let totalPPR = positionStats.reduce(0.0) { $0 + $1.fantasy_points_ppr }
            let totalPassEPA = positionStats.reduce(0.0) { $0 + $1.passing_epa }
            let totalRushEPA = positionStats.reduce(0.0) { $0 + $1.rushing_epa }
            let totalRecEPA = positionStats.reduce(0.0) { $0 + $1.receiving_epa }

            // 2. Now return the DTO with simple math
            return PlayerSeasonStatDTO(
                player_id: "AVG_\(position)",
                season: 0,
                passing_yards: totalPassYds / count,
                passing_tds: Int(Double(totalPassTDs) / count),
                passing_interceptions: Int(Double(totalPassInts) / count),
                rushing_yards: totalRushYds / count,
                rushing_tds: Int(Double(totalRushTDs) / count),
                receiving_yards: totalRecYds / count,
                receiving_tds: Int(Double(totalRecTDs) / count),
                def_sacks: totalSacks / count,
                def_interceptions: Int(Double(totalDefInts) / count),
                def_fumbles_forced: Int(Double(totalFumbles) / count),
                fantasy_points_ppr: totalPPR / count,
                passing_epa: totalPassEPA / count,
                rushing_epa: totalRushEPA / count,
                receiving_epa: totalRecEPA / count
            )
    }
    
    static func getStdByPosition(position:String, allPlayers: [Player], allStats: [PlayerSeasonStat]) ->
    PlayerSeasonStatDTO? {
        let playerIDsInPosition = Set(allPlayers.filter { $0.position == position }.map { $0.id })
        let positionStats = allStats.filter { playerIDsInPosition.contains($0.player_id) }
        guard !positionStats.isEmpty else { return nil }
        let count = Double(positionStats.count)
        
        func calculateStd(_ values: [Double]) -> Double {
                return vDSP.standardDeviation(values)
            }

            return PlayerSeasonStatDTO(
                player_id: "STD_\(position)",
                season: 0,
                passing_yards: calculateStd(positionStats.map { $0.passing_yards }),
                passing_tds: Int(calculateStd(positionStats.map { Double($0.passing_tds) })),
                passing_interceptions: Int(calculateStd(positionStats.map { Double($0.passing_interceptions) })),
                rushing_yards: calculateStd(positionStats.map { $0.rushing_yards }),
                rushing_tds: Int(calculateStd(positionStats.map { Double($0.rushing_tds) })),
                receiving_yards: calculateStd(positionStats.map { $0.receiving_yards }),
                receiving_tds: Int(calculateStd(positionStats.map { Double($0.receiving_tds) })),
                def_sacks: calculateStd(positionStats.map { $0.def_sacks }),
                def_interceptions: Int(calculateStd(positionStats.map { Double($0.def_interceptions) })),
                def_fumbles_forced: Int(calculateStd(positionStats.map { Double($0.def_fumbles_forced) })),
                fantasy_points_ppr: calculateStd(positionStats.map { $0.fantasy_points_ppr }),
                passing_epa: calculateStd(positionStats.map { $0.passing_epa }),
                rushing_epa: calculateStd(positionStats.map { $0.rushing_epa }),
                receiving_epa: calculateStd(positionStats.map { $0.receiving_epa })
            )
        
    }
    
}
