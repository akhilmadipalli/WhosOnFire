//
//  PlayerSeasonStat'.swift
//  WhosOnFire
//
//  Created by lending on 4/15/26.
//

import Foundation
import SwiftData


struct PlayerSeasonStatDTO: Codable {
    let player_id: String
    let season: Int
    let passing_yards: Double
    let passing_tds: Int
    let passing_interceptions: Int
    let rushing_yards: Double
    let rushing_tds: Int
    let receiving_yards: Double
    let receiving_tds: Int
    let def_sacks: Double
    let def_interceptions: Int
    let def_fumbles_forced: Int
    let fantasy_points_ppr: Double
    let passing_epa: Double
    let rushing_epa: Double
    let receiving_epa: Double
}

@Model
class PlayerSeasonStat: Identifiable {
    @Attribute(.unique) var id: String
    
    // Basic Info
    var player_id: String
    var season: Int
    // Core Offensive Stats
    var passing_yards: Double
    var passing_tds: Int
    var passing_interceptions: Int
    var rushing_yards: Double
    var rushing_tds: Int
    var receiving_yards: Double
    var receiving_tds: Int
    // Core Defensive Stats (The "Big Three")
    var def_sacks: Double
    var def_interceptions: Int
    var def_fumbles_forced: Int
    // Advanced Metrics
    var fantasy_points_ppr: Double
    var passing_epa: Double
    var rushing_epa: Double
    var receiving_epa: Double
    
    // Standard Init
    init(player_id: String, season: Int, passing_yards: Double, passing_tds: Int, passing_interceptions: Int, rushing_yards: Double, rushing_tds: Int, receiving_yards: Double, receiving_tds: Int, def_sacks: Double, def_interceptions: Int, def_fumbles_forced: Int, fantasy_points_ppr: Double, passing_epa: Double, rushing_epa: Double, receiving_epa: Double) {
        
        self.id = "\(player_id)_\(season)"
                self.player_id = player_id
                self.season = season
                self.passing_yards = passing_yards
                self.passing_tds = passing_tds
                self.passing_interceptions = passing_interceptions
                self.rushing_yards = rushing_yards
                self.rushing_tds = rushing_tds
                self.receiving_yards = receiving_yards
                self.receiving_tds = receiving_tds
                self.def_sacks = def_sacks
                self.def_interceptions = def_interceptions
                self.def_fumbles_forced = def_fumbles_forced
                self.fantasy_points_ppr = fantasy_points_ppr
                self.passing_epa = passing_epa
                self.rushing_epa = rushing_epa
                self.receiving_epa = receiving_epa
    }
}
    
