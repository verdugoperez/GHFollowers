//
//  FavouritesListVC.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 06/06/21.
//

import UIKit

class FavouritesListVC: UIViewController  {
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
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.removeExcessCells()
        
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
        let userInfoVC = UserInfoVC()
        userInfoVC.username = favorite.login
        userInfoVC.delegate = self
        
        let navController = UINavigationController(rootViewController: userInfoVC)
        
        present(navController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let favorite = favorites[indexPath.row]
     
        PersistenceManager.shared.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            
            self.presentGFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}


extension FavouritesListVC: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        let followerListVC = FollowerListVC(userName: username)
        
        navigationController?.pushViewController(followerListVC, animated: true)
    }
}
