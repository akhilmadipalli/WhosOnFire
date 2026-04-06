//
//  Player.swift
//  WhosOnFire
//
//  Created by lending on 4/05/26.
//

import Foundation
import SwiftData

@Model
final class Player: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()

    // Basic info
    var playerId: String
    var name: String
    var team: String
    var position: String

    // Rough stats
    var passingYards: Int
    var touchdowns: Int
    var completionPct: Double
    var epa: Double
    var qbr: Double?
    
    // EPAs
    // context

    init(playerId: String, name: String, team: String, position: String,
         passingYards: Int, touchdowns: Int, completionPct: Double, epa: Double, qbr: Double?) {
        self.id = UUID()
        self.playerId = playerId
        self.name = name
        self.team = team
        self.position = position
        self.passingYards = passingYards
        self.touchdowns = touchdowns
        self.completionPct = completionPct
        self.epa = epa
        self.qbr = qbr
    }
}
