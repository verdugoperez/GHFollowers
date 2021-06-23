//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 22/06/21.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        
        actionButton.backgroundColor = .systemPurple
        actionButton.setTitle("GitHub Profile", for: .normal)
    }
    
    override func actionButtonTapped() {
        delegate?.didTapGitHubProfile()
    }
}
