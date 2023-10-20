//
//  SearchViewController.swift
//  MovieCatalog
//
//  Created by Martin Nordebäck on 2023-10-16.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Properties
    typealias DataSource = UITableViewDiffableDataSource<Section, TrendingEntertainmentDetails>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, TrendingEntertainmentDetails>

    var dataSource: DataSource!

//    let searchResultViewController = SearchResultsViewController()

    private var movies = [TrendingEntertainmentDetails]()

    // MARK: - Views
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search here.."
        return searchBar
    }()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureDataSource()
    }
}


// MARK: - Data Source Configuration
extension SearchViewController {

    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, movie in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: movie)
            return cell
        })
    }
}


// MARK: - Search Functions
extension SearchViewController {

    private func performQueryApi(with query: String?) {
        guard let query = query, !query.isEmpty else { return }

        Task {
            do {
                movies = try await APICaller.shared.searchMovie(with: query)
                var snapShot = SnapShot()
                snapShot.appendSections([.searchMovieVC])
                snapShot.appendItems(movies, toSection: .searchMovieVC)
                await dataSource.apply(snapShot, animatingDifferences: true)
                print(movies)
                print(snapShot)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func performQuery(with query: String?) {
        guard query?.isEmpty != nil else { return }
        let moviesResult = filteredResult(with: query).sorted { $0.title ?? "empty 0" < $1.title ?? "empty 1" }
//        let moviesResult = searchResultViewController.filteredResult(with: query).sorted { $0.title ?? "empty 0" < $1.title ?? "empty 1" }
        var snapShot = SnapShot()
        snapShot.appendSections([.searchMovieVC])
        snapShot.appendItems(moviesResult, toSection: .searchMovieVC)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    
    func filteredResult(with filter: String? = nil, limit: Int? = nil) -> [TrendingEntertainmentDetails] {
        let filtered = movies.filter { $0.contains(filter) }
        if let limit = limit {
            return Array(filtered.prefix(through: limit))
        } else {
            return filtered
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQueryApi(with: searchText)
    }
}


// MARK: - UI Setup
extension SearchViewController {
    private func configureLayout() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search"

        for viewable in [searchBar, tableView] {
            view.addSubview(viewable)
            viewable.translatesAutoresizingMaskIntoConstraints = false
        }

        searchBar.delegate = self

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 3),
            searchBar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: searchBar.trailingAnchor, multiplier: 1),

            tableView.topAnchor.constraint(equalToSystemSpacingBelow: searchBar.bottomAnchor, multiplier: 0),
            tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 0),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: tableView.bottomAnchor, multiplier: 0),
        ])
    }
}





//        Task {
//            do {
//                let movies = try await APICaller.shared.searchMovie(with: "harry")
//                print("Movies: \(movies)")
//            } catch {
//                print("Error: \(error)")
//            }
//        }
//        performQuery(with: nil)
//        performQueryApi(with: nil)
//        performQuery(with: searchText) // from searchBar function
