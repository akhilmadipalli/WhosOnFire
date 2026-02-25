//
//  Player.swift
//  WhosOnFire
//
//  Created by Akhil Madipalli on 2/25/26.
//


import Foundation

struct Player: Identifiable, Codable {
    let id: String
    let name: String
    let team: String
    let position: String
}