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

        let topMovieViewController = createTopMoviesViewController()
        let searchViewController = createSearchViewController()
        let watchListViewController = createWatchListViewController()

        tabBar.tintColor = .label
        setViewControllers([topMovieViewController, searchViewController, watchListViewController], animated: true)
    }

    private func createTopMoviesViewController() -> UIViewController {
        let topMovieViewController = TopMovieViewController()
        topMovieViewController.apiCaller = APICaller.shared
        topMovieViewController.tabBarItem.image = UIImage(systemName: "list.star")
        topMovieViewController.title = "Top 20"
        return UINavigationController(rootViewController: topMovieViewController)
    }

    private func createSearchViewController() -> UIViewController {
        let searchViewController = SearchViewController()
        searchViewController.apiCaller = APICaller.shared
        searchViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        searchViewController.title = "Search"
        return UINavigationController(rootViewController: searchViewController)
    }

    private func createWatchListViewController() -> UIViewController {
        let watchListViewController = WatchListViewController()
        watchListViewController.tabBarItem.image = UIImage(systemName: "bookmark.fill")
        watchListViewController.title = "Watchlist"
        return UINavigationController(rootViewController: watchListViewController)
    }
}
