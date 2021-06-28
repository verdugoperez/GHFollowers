//
//  GFTextField.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 07/06/21.
//

import UIKit

class GFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        
        textColor = .label
        // tintColor es cuando presionas el botón
        tintColor = .label
        textAlignment = .center
        font = UIFont.preferredFont(forTextStyle: .title2)
        // si el texto es muy largo, se va a cambiar el fontsize para caber en el espacio
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        returnKeyType = .go
        // Agregar una x en el textfield para borrar
        clearButtonMode = .whileEditing
        placeholder = "Enter a username"
    }
}
