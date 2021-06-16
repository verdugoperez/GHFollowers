//
//  SearchVC.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 06/06/21.
//

import UIKit

class SearchVC: UIViewController {
    
    // MARK: - Properties
    let logoImageView = UIImageView()
    let userNameTextField = GFTextField()
    let actionButton = GFButton(backgroundColor: .systemGreen, title: "Get Followers")
    var isUserNameEntered: Bool {
        return !userNameTextField.text!.isEmpty
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // navigationController?.isNavigationBarHidden = true
        
        // Corregir bug de animación de navigation bar cuando hay transición en VC que está oculta
        navigationController?.setNavigationBarHidden(true, animated: true)
        userNameTextField.becomeFirstResponder()
    }
    
    @objc func pushFollowerListVC(){
        guard isUserNameEntered else {
            presentGFAlertOnMainThread(title: "Empty Username", message: "Please enter a username. We need to know who to look for 👀", buttonTitle: "Ok")
            return
        }
        
        let followerListVC = FollowerListVC()
        
        followerListVC.title = userNameTextField.text!
        followerListVC.userName = userNameTextField.text!
        
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    // MARK: - UI
    func configureLogoImageView(){
        // addSubView es equivalente a drag y drop del storyboard
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        logoImageView.image = UIImage(named: "gh-logo")
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func configureTextField(){
        view.addSubview(userNameTextField)
        userNameTextField.delegate = self
        
        NSLayoutConstraint.activate([
            userNameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            userNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionButton(){
        view.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func createDismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(tap)
    }
}

// MARK: - UITextFieldDelegate
extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
