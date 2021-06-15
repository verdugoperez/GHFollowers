//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 10/06/21.
//

import UIKit

class FollowerListVC: UIViewController {
    
    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Corregir bug de animación de navigation bar cuando hay transición en VC que está oculta
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .magenta
        
        NetworkManager.shared.getFollowers(for: userName.lowercased(), page: 1) { result in
            switch result {
                case .success(let followers):
                    print(followers)
                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Bad Stuff happend", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.isNavigationBarHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
