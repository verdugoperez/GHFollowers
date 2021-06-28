//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 28/06/21.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let searchVC = createNC(rootViewController: SearchVC(), title: "Search", icon: .search, tag: 0)
        let favouritesVC = createNC(rootViewController: FavouritesListVC(), title: "Favorites", icon: .favorites, tag: 1)
      
        UITabBar.appearance().tintColor = .systemGreen
        self.viewControllers =  [searchVC, favouritesVC]
    }
    

    private func createNC(rootViewController: UIViewController, title: String, icon: UITabBarItem.SystemItem, tag: Int) -> UINavigationController {
        rootViewController.title = title
        rootViewController.tabBarItem = UITabBarItem(tabBarSystemItem: icon, tag: tag)
        
        return UINavigationController(rootViewController: rootViewController)
    }
    
   

}
