//
//  MockData.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//


import Foundation

struct MockData {
    static let samplePlayers = [
        Player(playerId: "1", name: "Josh Allen", team: "BUF", position: "QB",
               passingYards: 3731, touchdowns: 28, completionPct: 63.6, epa: 0.31, qbr: 74.2),
        Player(playerId: "2", name: "Jalen Hurts", team: "PHI", position: "QB",
               passingYards: 2903, touchdowns: 22, completionPct: 65.4, epa: 0.24, qbr: 68.9),
        Player(playerId: "3", name: "Lamar Jackson", team: "BAL", position: "QB",
               passingYards: 3955, touchdowns: 41, completionPct: 67.2, epa: 0.44, qbr: 82.1),
        Player(playerId: "4", name: "Joe Burrow", team: "CIN", position: "QB",
               passingYards: 4918, touchdowns: 43, completionPct: 68.3, epa: 0.29, qbr: 71.5),
        Player(playerId: "5", name: "Patrick Mahomes", team: "KC", position: "QB",
               passingYards: 4183, touchdowns: 26, completionPct: 63.7, epa: 0.22, qbr: 66.4)
    ]
}