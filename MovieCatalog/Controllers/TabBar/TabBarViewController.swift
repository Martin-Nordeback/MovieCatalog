//
//  TabBarViewController.swift
//  MovieCatalog
//
//  Created by Martin Nordebäck on 2023-10-16.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = UINavigationController(rootViewController: TopMovieViewController())
        let vc2 = UINavigationController(rootViewController: SearchViewController())
        let vc3 = UINavigationController(rootViewController: WatchListViewController())

        vc1.tabBarItem.image = UIImage(systemName: "list.star")
        vc2.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc3.tabBarItem.image = UIImage(systemName: "bookmark.fill")

        vc1.title = "Top 20"
        vc2.title = "Search"
        vc3.title = "Watchlist"

        tabBar.tintColor = .label
        setViewControllers([vc1, vc2, vc3], animated: true)
    }
}
