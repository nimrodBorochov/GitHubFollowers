//
//  GFEmptyStateView.swift
//  GitHubFollowers
//
//  Created by Nimrod Borochov on 24/01/2024.
//

import UIKit

class GFEmptyStateView: UIView {

    let messageLabel: GFTitleLabel = {
        let label = GFTitleLabel(textAlignment: .center, fontSize: 28)
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        return label
    }()

    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.emptyStateLogo
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(messageLabel, logoImageView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }

    private func setupConstraints() {

        var messageLabelCenterYAnchorConstraintConstant: CGFloat = -150
        var logoImageViewBottomAnchorConstraintConstant: CGFloat = 40

        if DeviceType.isiPhoneSE || DeviceType.isiPhone8Zoomed {
            messageLabelCenterYAnchorConstraintConstant = -80
            logoImageViewBottomAnchorConstraintConstant = 80
        }

        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: messageLabelCenterYAnchorConstraintConstant),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),

            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: logoImageViewBottomAnchorConstraintConstant),

        ])
    }
}
