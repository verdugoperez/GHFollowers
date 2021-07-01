//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 29/06/21.
//

import UIKit

extension UIView {
    // Variadic Parameters
    func addSubViews(_ views: UIView...){
        for view in views {
            addSubview(view)
        }
    }
    
    func pinToEdges(of superview: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
}
