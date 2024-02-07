//
//  GFFollowerItemVC.swift
//  GitHubFollowers
//
//  Created by Nimrod Borochov on 25/01/2024.
//

import Foundation

protocol GFFollowerItemVCDelegate: AnyObject {
    func didTapGetFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC {

    weak var delegate: GFFollowerItemVCDelegate?

    init(user: User, delegate: GFFollowerItemVCDelegate? = nil) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureItems()
    }

    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)

        actionButton.set(backgroundColor: .systemGreen, title: "Git Followers")
    }

    override func actionButtonTapped() {
        delegate?.didTapGetFollowers(for: user)
    }
}
