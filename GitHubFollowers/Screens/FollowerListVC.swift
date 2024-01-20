//
//  FollowerListVC.swift
//  GitHubFollowers
//
//  Created by Nimrod Borochov on 18/01/2024.
//

import UIKit

class FollowerListVC: UIViewController {

    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        NetworkManager.shared.getFollowers(for: username, page: 1) { result in

            switch result {

            case .success(let followers):
                print(followers)

            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bas Stuff Happened",
                                                message: error.rawValue,
                                                buttonTitle: "Ok")
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
