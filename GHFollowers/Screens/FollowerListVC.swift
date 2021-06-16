//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 10/06/21.
//

import UIKit

class FollowerListVC: UIViewController {
    
    var userName: String!
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureViewController()
        configureCollectionView()
        getFollowers()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.isNavigationBarHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureCollectionView(){
        // UICollectionViewFlowLayout es el valor por default
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        
        // inicializar primero el collection view antes de agregarlo a la subview
        view.addSubview(collectionView)
        collectionView.backgroundColor = .red
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureViewController(){
        // Corregir bug de animación de navigation bar cuando hay transición en VC que está oculta
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .magenta
    }
    
    func createThreeColumnFlowLayout() -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        // Espacio de los lados
        let padding: CGFloat = 12
        // Espacio entre celdas
        let minimunItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimunItemSpacing * 2)
        let itemWidth = availableWidth / 3
        // Se agregar 40 para el espacio del label
        let itemHeight = itemWidth + 40
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        return flowLayout
    }
    
    func getFollowers(){
        NetworkManager.shared.getFollowers(for: userName.lowercased(), page: 1) { result in
            switch result {
                case .success(let followers):
                    print(followers)
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Bad Stuff happend", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}
