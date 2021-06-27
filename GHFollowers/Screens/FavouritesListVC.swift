//
//  FavouritesListVC.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 06/06/21.
//

import UIKit

class FavouritesListVC: UIViewController {

    let tableView = UITableView()
    var favorites = [Follower]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // los colores "system" cambian automáticamente en light y dark mode
        configureViewController()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getFavorites()
    }
    
    func getFavorites(){
        PersistenceManager.shared.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let favorites):
                    if favorites.isEmpty {
                        self.showEmptyStateView(with: "No favorites?\nAdd one on the follower screen", view: self.view)
                    } else {
                        self.favorites = favorites
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            // por si acaso el empty se pone primero
                            self.view.bringSubviewToFront(self.tableView)
                        }
                    }
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureViewController(){
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
}


extension FavouritesListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        
        cell.set(favorite: favorite)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let followerListVC = FollowerListVC()
        
        followerListVC.title = favorite.login
        followerListVC.userName = favorite.login
        
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .left)
        
        PersistenceManager.shared.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else { return }
            
            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}
