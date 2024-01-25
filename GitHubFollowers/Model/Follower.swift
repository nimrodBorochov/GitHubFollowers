//
//  Follower.swift
//  GitHubFollowers
//
//  Created by Nimrod Borochov on 20/01/2024.
//

import Foundation

struct Follower: Codable, Hashable { // Hashable for UICollectionViewDiffableDataSource
    var login: String
    var avatarUrl: String
}
