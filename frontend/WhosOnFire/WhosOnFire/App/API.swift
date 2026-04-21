//
//  NFL_API.swift
//  WhosOnFireProject
//
//  Created by lending on 4/5/26.
//
import Foundation
import SwiftData
@MainActor
class API {
    private let IP = "10.79.103.179"
    private let player_url_str = "http://10.79.103.179/players"
    private let player_stat_url_str = "http://10.79.103.179/player_stats"
    private let allowedPositions =  ["QB", "RB", "WR", "TE", "FB", "DE", "DT", "CB", "S", "LB", "DB", "DL"]
    
    struct PlayerStatsRequest: Encodable {
        let seasons: [Int]
        let player_id: Int
    }
    
    
    func fetchPlayers(modelContext: ModelContext) async  {
        let player_url = URL(string: player_url_str)!
        print("Called fetchPlayers")
        do {
            let (data, response) = try await URLSession.shared.data(from: player_url)
            if(response as? HTTPURLResponse)?.statusCode != 200 {
                print("Server Error")
                return
            }
            print("Success")
            
            let playerDTOs = try JSONDecoder().decode([PlayerDTO].self, from: data)
            
            
            for dto in playerDTOs {
                if allowedPositions.contains(dto.position) {
                    print("Adding \(dto.player_display_name) - Pos: \(dto.position) to SwiftData")
                    let newPlayer = Player(
                        playerId: dto.player_id,
                        player_display_name: dto.player_display_name,
                        position: dto.position,
                        headshot_url: dto.headshot_url,
                        team: dto.team
                    )
                    modelContext.insert(newPlayer)
                }
            }
            print("Added all \(playerDTOs.count) players to SwiftData")
            
        } catch {
            print("Error during player sync: \(error)")
        }
    }
    
    /**
    Fetches Player Stats in a PlayerSeasonStat view
     
     */
    func fetchPlayerStats(seasons: [Int], modelContext: ModelContext) async  {
        let player_stat_url = URL(string: player_stat_url_str)!
        
        var request = URLRequest(url: URL(string: player_stat_url_str)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            var bodyData = PlayerStatsRequest(seasons: seasons, player_id: 0)
            let bodyRequest = try JSONEncoder().encode(bodyData)
            
            let (data, response) = try await URLSession.shared.upload(for: request, from: bodyRequest)
            if(response as? HTTPURLResponse)?.statusCode != 200 {
                print("Server Error")
                return
            }
            print("Success loading stats")
            let playerStatDTOs = try JSONDecoder().decode([PlayerSeasonStatDTO].self, from: data)
            let playerDescriptor = FetchDescriptor<Player>()
            let existingPlayers: [Player] = try modelContext.fetch(playerDescriptor)
            let playerIds = Set(existingPlayers.map{$0.id}) // Get the player ids we just fetched, ignore all player_ids not in here.
            
            for dto in playerStatDTOs {
                if(playerIds.contains(dto.player_id)) {
                    let newPlayerStat = PlayerSeasonStat(
                        player_id: dto.player_id,
                        season: dto.season,
                        passing_yards: dto.passing_yards,
                        passing_tds: dto.passing_tds,
                        passing_interceptions: dto.passing_interceptions,
                        rushing_yards: dto.rushing_yards,
                        rushing_tds: dto.rushing_tds,
                        receiving_yards: dto.receiving_yards,
                        receiving_tds: dto.receiving_tds,
                        def_sacks: dto.def_sacks,
                        def_interceptions: dto.def_interceptions,
                        def_fumbles_forced: dto.def_fumbles_forced,
                        fantasy_points_ppr: dto.fantasy_points_ppr,
                        passing_epa: dto.passing_epa,
                        rushing_epa: dto.rushing_epa,
                        receiving_epa: dto.receiving_epa
                    )
                    modelContext.insert(newPlayerStat)
                }
            }
            print("Added all \(playerStatDTOs.count) players to SwiftData")
            
            
            
        }
        catch {
            print("error during player stat sync: \(error)")
        }
    }
}
