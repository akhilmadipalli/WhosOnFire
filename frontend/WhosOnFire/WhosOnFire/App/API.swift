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
    private let syncUrl = "http://127.0.0.1:5001/sync"  // URL to the backend flask server
    func fetch() async {
        guard let url = URL(string: syncUrl) else {
            print("Invalid URL")
            return
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("Server Error")
                return
            }
            print(data)
            
            
        } catch {
            print("Error during sync: \(error)")
        }
    }
}
