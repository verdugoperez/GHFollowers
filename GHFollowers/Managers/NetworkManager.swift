//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 14/06/21.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com"
    private var perPage = 100
    
    private init(){}
    
    func getFollowers(for username: String, page: Int, completed: @escaping([Follower]?, String?) -> Void) {
        let endpoint = "\(baseURL)/users/\(username)/followers?per_page=\(perPage)&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, "This username created an invalid request. Please try again.")
            return
        }
    
        let task = URLSession.shared.dataTask(with: url) { data, resopnse, error in
           
            if let _ = error {
                completed(nil, "Unable to complete your request. Please check your internet connection")
                return
            }
            
            guard let response = resopnse as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "Invalid response from the server. Please try again.")
                return
            }
            
            guard let data = data else {
                completed(nil, "The data received from the server is invalid. Please try again")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // convertir la respuesta snake case a camel case
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(followers, nil)
            } catch {
                completed(nil, "The data received from the server is invalid. Please try again" )
            }
        }
        
        // resume hace la petición
        task.resume()
    }
}
