//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 10/06/21.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class FollowerListVC: UIViewController {
    
    enum Section {
        case main
    }
    // MARK: Properties
    var userName: String!
    var followers = [Follower]()
    var filteredFollowers = [Follower]()
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    private var page = 1
    private var hasMoreFollowers = true
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureViewController()
        configureCollectionView()
        getFollowers()
        configureDataSource()
        configureSearchController()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.isNavigationBarHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureCollectionView(){
        // UICollectionViewFlowLayout es el valor por default
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        
        // inicializar primero el collection view antes de agregarlo a la subview
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureViewController(){
        // Corregir bug de animación de navigation bar cuando hay transición en VC que está oculta
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureSearchController(){
        let searchController = UISearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
    
    func getFollowers(){
        showLoadingView()
        NetworkManager.shared.getFollowers(for: userName, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
                case .success(let followers):
                    // check para ver si el usuario tiene más seguidores
                    if followers.count < NetworkManager.shared.perPage {
                        self.hasMoreFollowers = false
                    }
                    
                    self.followers.append(contentsOf: followers)
                    
                    if followers.isEmpty {
                        let message = "This user doesen't have any followers, go follow them 😀."
                        DispatchQueue.main.async {
                            self.navigationItem.searchController = nil
                            self.showEmptyStateView(with: message, view: self.view)
                        }
                        
                        return
                    }
                    
                    self.updateData(on: self.followers)
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Bad Stuff happend", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            
            return cell
        })
    }
    
    func updateData(on followers: [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
    }
    
    @objc func addButtonTapped(){
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: userName) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
                case .success(let user):
                    let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                    
                    PersistenceManager.shared.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                        guard let self = self else { return }
                        guard let error = error  else {
                            self.presentGFAlertOnMainThread(title: "Success!", message: "You have successfully favorited this user 😎", buttonTitle: "Hooray!")
                            return
                        }
                        
                        self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                    }
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

//MARK: - UICollectionViewDelegate
extension FollowerListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height  = scrollView.frame.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            getFollowers()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower = activeArray[indexPath.item]
        
        let userInfoVC = UserInfoVC()
        userInfoVC.username = follower.login
        userInfoVC.delegate = self
        
        let navController = UINavigationController(rootViewController: userInfoVC)
        
        present(navController, animated: true, completion: nil)
    }
}

//MARK: - UISearchResultsUpdating
extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        filteredFollowers = followers.filter({$0.login.lowercased().contains(filter.lowercased())})
        updateData(on: filteredFollowers)
    }
}

//MARK: - UISearchBarDelegate
extension FollowerListVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: self.followers)
    }
}

//MARK: - FollowerListVCDelegate
extension FollowerListVC: FollowerListVCDelegate {
    func didRequestFollowers(for username: String) {
        self.userName = username
        title = username
        
        followers.removeAll()
        filteredFollowers.removeAll()
        page = 1
        collectionView.setContentOffset(.zero, animated: true)
       // updateData(on: followers)
        getFollowers()
    }
    
    
}
