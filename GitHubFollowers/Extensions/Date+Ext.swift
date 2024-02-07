//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by Nimrod Borochov on 26/01/2024.
//

import Foundation

extension Date {

    func convertToMonthYearFormat() -> String {
        return formatted(.dateTime.month().year())
    }
}
