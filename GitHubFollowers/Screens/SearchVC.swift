//
//  SearchVC.swift
//  GitHubFollowers
//
//  Created by Nimrod Borochov on 18/01/2024.
//

import UIKit

final class SearchVC: UIViewController {

    let logoImageView: UIImageView = {
        let logoImageView = UIImageView(image: Images.ghLogo)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        return logoImageView
    }()

    let usernameTextField = GFTextField()
    let callForActionButton = GFButton(color: .green, title: "Get Followers", systemImageName: "person.3") 

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
        usernameTextField.text = ""
    }

    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @objc private func pushFollowerListVC() {

        guard isUsernameEntered else {
            presentGFAlert(title: "Empty Username",
                           message: "Please enter a username. We need to know who to look for 😀.",
                           buttonTitle: "Ok")
            return
        }
        
        usernameTextField.resignFirstResponder()

        let followerListVC = FollowerListVC(username: usernameTextField.text!)
        navigationController?.pushViewController(followerListVC, animated: true)
    }

    private func configureSubviews() {
        view.addSubviews(logoImageView, usernameTextField, callForActionButton)
        setupConstraint()
        usernameTextField.delegate = self
        callForActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
    }

    private func setupConstraint() {

        let topConstraintConstant: CGFloat = DeviceType.isiPhoneSE || DeviceType.isiPhone8Zoomed ? 20 : 80

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
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
