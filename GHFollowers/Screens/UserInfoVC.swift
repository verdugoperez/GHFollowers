//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 18/06/21.
//

import UIKit

class UserInfoVC: UIViewController {
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemRed
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        print(username)
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
}
