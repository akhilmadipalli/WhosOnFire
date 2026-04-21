import Foundation
import SwiftData

struct PlayerDTO: Codable {
    var player_id: String
    var player_display_name: String
    var position: String
    var headshot_url: String
    var team: String
}


@Model
final class Player: Identifiable {
    @Attribute(.unique) var id: String
    // Basic Info
    var player_display_name: String
    var position: String
    var headshot_url: String
    var team: String
    var isFavorite: Bool = false
    
    // Standard Init
    init(playerId: String, player_display_name: String, position: String, headshot_url: String, team: String, isFavorite: Bool = false) {
        self.id = "\(playerId)"
        self.player_display_name = player_display_name
        self.position = position
        self.headshot_url = headshot_url
        self.team = team
        self.isFavorite = isFavorite
        
    }
    
}
