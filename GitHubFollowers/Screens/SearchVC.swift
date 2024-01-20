//
//  SearchVC.swift
//  GitHubFollowers
//
//  Created by Nimrod Borochov on 18/01/2024.
//

import UIKit

final class SearchVC: UIViewController {

    let logoImageView: UIImageView = {
        let logoImageView = UIImageView(image: UIImage(named: "gh-logo"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        return logoImageView;
    }()

    let usernameTextField = GFTextField()
    let callForActionButton = GFButton(backgroundColor: .green, title: "Get Followers")

    var isUsernameEntered: Bool { !usernameTextField.text!.isEmpty }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSubviews()
        createDismissKeyboardTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true);
    }

    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @objc private func pushFollowerListVC() {

        guard isUsernameEntered else {
            presentGFAlertOnMainThread(
                title: "Empty Username",
                message: "Please enter a username. We need to know who to look for 😀.",
                buttonTitle: "Ok"
            )
            
            return
        }

        let followerListVC = FollowerListVC()
        followerListVC.username = usernameTextField.text
        followerListVC.title = usernameTextField.text
        navigationController?.pushViewController(followerListVC, animated: true)
    }

    private func configureSubviews() {
        view.addSubviews(logoImageView, usernameTextField, callForActionButton)
        setupConstraint()
        usernameTextField.delegate = self
        callForActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),

            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),

            callForActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callForActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callForActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callForActionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
