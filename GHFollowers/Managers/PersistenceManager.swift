//
//  PersistenceManager.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 24/06/21.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

class PersistenceManager {
    static let shared = PersistenceManager()
    private let defaults = UserDefaults.standard
    
    private init(){}
    
    func updateWith(favorite: Follower, actionType: PersistenceActionType, completion: @escaping(GFError?) -> Void){
        retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                var retrievedFavorites = favorites
                
                switch actionType {
                case .add:
                    guard !retrievedFavorites.contains(favorite) else {
                        completion(.alreadyFavorited)
                        return
                    }
                    
                    retrievedFavorites.append(favorite)
                case .remove:
                    retrievedFavorites.removeAll { $0.login == favorite.login }
                }
                
                completion(self.save(favorites: retrievedFavorites))
                
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func retrieveFavorites(completion: @escaping(Result<[Follower], GFError>) -> Void){
        guard let favouritesData = defaults.object(forKey: UserDefaultsKeys.favourites) as? Data else {
            // Retornar arreglo vacio si no hay favoritos
            completion(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
        
            let favorites = try decoder.decode([Follower].self, from: favouritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }
    
    func save(favorites: [Follower]) -> GFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.setValue(encodedFavorites, forKey: UserDefaultsKeys.favourites)
            return nil
        } catch {
            return GFError.unableToFavorite
        }
    }
}
