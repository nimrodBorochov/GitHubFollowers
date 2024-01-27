//
//  UserInfoVC.swift
//  GitHubFollowers
//
//  Created by Nimrod Borochov on 25/01/2024.
//

import UIKit

// TODO:: move to writ place
protocol UserInfoVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoVC: UIViewController {
    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let itemViewOne: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let itemViewTwo: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let dateLabel = GFBodyLabel(textAlignment: .center)

    var username: String!
    weak var delegate: FollowerListVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        setupConstraints()
        getUserInfo()

    }

    private func configureVC() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        self.view.addSubviews(headerView, itemViewOne, itemViewTwo, dateLabel)
    }

    private func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }

            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong",
                                                message: error.rawValue,
                                                buttonTitle: "Ok")
            }
        }
    }

    private func configureUIElements(with user: User) {
        let repoItemVC = GFRepoItemVC(user: user)
        repoItemVC.delegate = self

        let followerItemVC = GFFollowerItemVC(user: user)
        followerItemVC.delegate = self

        add(childVC: GFUserInfoHeaderVC(user: user), to: headerView)
        add(childVC: repoItemVC, to: itemViewOne)
        add(childVC: followerItemVC, to: itemViewTwo)
        dateLabel.text = "GitHub since \(user.createdAt.convertToDisplayFormat())"
    }

    private func setupConstraints() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        let itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]

        for itemView in itemViews {
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),

            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }
}


extension UserInfoVC: UserInfoVCDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL",
                                       message: "The url attached to this user is invalid.",
                                       buttonTitle: "Ok")
            return
        }

        presentSafariVC(with: url)
    }
    
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No followers",
                                       message: "This user has no followers. what a shame 😞.",
                                       buttonTitle: "So sad")
            return
        }

        delegate?.didRequestFollowers(for: user.login)
        dismissVC()
    }

}
