//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by Nimrod Borochov on 26/01/2024.
//

import Foundation

extension Date {

    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
