//
//  GFAlertVC.swift
//  GitHubFollowers
//
//  Created by Nimrod Borochov on 19/01/2024.
//

import UIKit

class GFAlertVC: UIViewController {

    let containerView: UIView = { // TODO: speared to file
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let titleLabel: GFTitleLabel = {
        let label = GFTitleLabel(textAlignment: .center, fontSize: 20)
        label.text = "Something went wrong"
        return label
    }()

    let messageLabel:GFBodyLabel = {
        let label = GFBodyLabel(textAlignment: .center)
        label.text = "Unable to complete request"
        label.numberOfLines = 4
        return label
    }()

    let actionButton: GFButton = {
        let button = GFButton(backgroundColor: .systemPink, title: "OK")
        button.setTitle("OK", for: .normal)
        return button
    }()

    let padding: CGFloat = 20

    init(alertTitle: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)

        self.messageLabel.text = message
        self.actionButton.setTitle(buttonTitle, for: .normal)
        self.titleLabel.text = alertTitle

        self.actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        containerView.addSubviews(titleLabel, actionButton, messageLabel)
        view.addSubview(containerView)
        setupConstraint()
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220),

            // inside containerView
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),

            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }

    @objc private func dismissVC() {
        dismiss(animated: true)
    }
}
