//
//  GFAvatarImageView.swift
//  GitHubFollowers
//
//  Created by Nimrod Borochov on 21/01/2024.
//

import UIKit

class GFAvatarImageView: UIImageView {

    let placeholderImage = Images.placeholder

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }

    func downloadImage(fromURL url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }
}
