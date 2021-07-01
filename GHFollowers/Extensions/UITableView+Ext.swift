//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 30/06/21.
//

import UIKit

extension UITableView {
    // Quitar las celdas sobrantes
    func removeExcessCells(){
        tableFooterView = UIView(frame: .zero)
    }
}
