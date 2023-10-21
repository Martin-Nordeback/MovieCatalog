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

        let topMovieViewController = UINavigationController(rootViewController: TopMovieViewController())
        let searchViewController = UINavigationController(rootViewController: SearchViewController())
        let watchListViewController = UINavigationController(rootViewController: WatchListViewController())

        topMovieViewController.tabBarItem.image = UIImage(systemName: "list.star")
        searchViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        watchListViewController.tabBarItem.image = UIImage(systemName: "bookmark.fill")

        topMovieViewController.title = "Top 20"
        searchViewController.title = "Search"
        watchListViewController.title = "Watchlist"

        // Injecting the dependency into ViewControllers
        if let topMovieVC = topMovieViewController.viewControllers.first as? TopMovieViewController {
            topMovieVC.apiCaller = APICaller.shared
        }
        if let searchVC = searchViewController.viewControllers.first as? SearchViewController {
            searchVC.apiCaller = APICaller.shared
        }

        tabBar.tintColor = .label
        setViewControllers([topMovieViewController, searchViewController, watchListViewController], animated: true)
    }
}
