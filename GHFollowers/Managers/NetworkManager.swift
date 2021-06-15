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
    
    func getFollowers(for username: String, page: Int, completed: @escaping(Result<[Follower], GFError>) -> Void) {
        let endpoint = "\(baseURL)/users/\(username)/followers?per_page=\(perPage)&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
    
        let task = URLSession.shared.dataTask(with: url) { data, resopnse, error in
           
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = resopnse as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                // convertir la respuesta snake case a camel case
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        // resume hace la petición
        task.resume()
    }
}
