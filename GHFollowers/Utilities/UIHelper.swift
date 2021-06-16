//
//  UIHelper.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 15/06/21.
//

import UIKit

struct UIHelper {
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
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
}
