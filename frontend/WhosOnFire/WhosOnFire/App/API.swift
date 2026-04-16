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
    private let player_url_str = "http://10.79.103.179:5001/players"
    private let player_stat_url_str = "http://10.79.103.179:5001/player_stats"
    
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
                let newPlayer = Player(
                        playerId: dto.player_id,
                        player_display_name: dto.player_display_name,
                        position: dto.position,
                        headshot_url: dto.headshot_url,
                        team: dto.team
                    )
               modelContext.insert(newPlayer)
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
            print("Loaded \(playerStatDTOs.count) statistics")
            
            print(data)
            
        }
        catch {
            print("error during player stat sync: \(error)")
        }
    }
}
