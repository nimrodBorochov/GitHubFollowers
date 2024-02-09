//
//  FavoritesListVC.swift
//  GitHubFollowers
//
//  Created by Nimrod Borochov on 18/01/2024.
//

import UIKit

class FavoritesListVC: GFDataLoadingVC {

    let tableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
        getFavorites()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.frame = view.bounds
        getFavorites()
    }

    private func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @available(iOS 17.0, *)
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if favorites.isEmpty {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = .init(systemName: "star")
            config.text = "No Favorites"
            config.secondaryText = "Add favorite on follower list screen"
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
    }

    private func configureTableView() {
        view.addSubview(tableView)
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    private func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let favorites):
                self.updateUI(with: favorites)

            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "",
                                        message: error.rawValue,
                                        buttonTitle: "Ok")
                }
            }
        }
    }

    private func updateUI(with favorites: [Follower]) {
        self.favorites = favorites

        if #available(iOS 17.0, *) {
            setNeedsUpdateContentUnavailableConfiguration()
            reloadTableOnMailThread()
        } else {
            if favorites.isEmpty {
                self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.",
                                        in: self.view)
            } else { reloadTableOnMailThread() }
        }
    }

    private func reloadTableOnMailThread() {
        DispatchQueue.main.async  {
            self.tableView.reloadData()
            self.view.bringSubviewToFront(self.tableView)
        }
    }
}

extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destVC = FollowerListVC(username: favorite.login)

        navigationController?.pushViewController(destVC, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self else { return }

            guard let error else { // No err
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)

                if #available(iOS 17.0, *) {
                    setNeedsUpdateContentUnavailableConfiguration()
                }  else if self.favorites.isEmpty {
                    self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.",
                                            in: self.view)
                }
                return
            }

            DispatchQueue.main.async {
                self.presentGFAlert(title: "Unable to remove",
                                    message: error.rawValue,
                                    buttonTitle: "Ok")
            }
        }
    }
}
