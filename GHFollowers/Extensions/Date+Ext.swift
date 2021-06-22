//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Manuel Alejandro Verdugo Pérez on 22/06/21.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        return dateFormatter.string(from: self)
    }
}
