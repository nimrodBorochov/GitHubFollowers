//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Nimrod Borochov on 20/01/2024.
//

import UIKit


final class NetworkManager {

    static let shared = NetworkManager()
    
    private let baseURL = "https://api.github.com/users/"
    let cache = NSCache<NSString, UIImage>()
    let decoder = JSONDecoder()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }

    func getFollowers(for username: String, page: Int) async throws -> [Follower] {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else { throw GFError.invalidUsername }

        return try await fetch(from: url)
    }

    func getUserInfo(for username: String) async throws -> User {
        let endpoint = baseURL + "\(username)"

        guard let url = URL(string: endpoint) else { throw GFError.invalidUsername }

        return try await fetch(from: url)
    }

    func downloadImage(from urlString: String) async -> UIImage? {

        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) { return image }

        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let image = UIImage(data: data) else { return nil }
            self.cache.setObject(image, forKey: cacheKey)
            return image
        } catch { return nil }
    }

    private func fetch<T>(from url: URL) async throws -> T where T : Decodable, T : Encodable {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw GFError.invalidResponse }

        do {
            return try decoder.decode(T.self, from: data)
        } catch { throw GFError.invalidData }
    }
}
