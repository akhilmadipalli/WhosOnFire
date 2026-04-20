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
 
import Accelerate
extension PlayerSeasonStatDTO {
    func toVector(baseline: PlayerSeasonStatDTO?, position: String?) -> [Double] {
        guard let base = baseline else { return [] }
        let baselines: [Double]
        let values: [Double]
        if position == "QB" {
            values = [passing_yards, Double(passing_tds), Double(passing_interceptions), rushing_yards, passing_epa]
            baselines = [base.passing_yards, Double(base.passing_tds), Double(base.passing_interceptions), base.rushing_yards, base.passing_epa]
        } else if ["WR", "RB", "TE", "FB"].contains(position) {
            values = [rushing_yards, receiving_yards, Double(rushing_tds + receiving_tds), receiving_epa, fantasy_points_ppr]
            baselines = [base.rushing_yards, base.receiving_yards, Double(base.rushing_tds + base.receiving_tds), base.receiving_epa, base.fantasy_points_ppr]
            
        } else {
            values = [def_sacks, Double(def_interceptions), Double(def_fumbles_forced), fantasy_points_ppr]
            baselines = [base.def_sacks, Double(base.def_interceptions), Double(base.def_fumbles_forced), base.fantasy_points_ppr]
        }
        let safeBaselines = baselines.map { $0 == 0 ? 1.0 : $0 }
        return vDSP.divide(values, safeBaselines)
    }
}
