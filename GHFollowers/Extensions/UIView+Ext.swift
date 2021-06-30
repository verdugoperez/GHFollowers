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
}
