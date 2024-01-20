//
//  GFError.swift
//  GitHubFollowers
//
//  Created by Nimrod Borochov on 20/01/2024.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. please try again."
    case invalidData = "Date received from the server was invalid. Please try again."
}
