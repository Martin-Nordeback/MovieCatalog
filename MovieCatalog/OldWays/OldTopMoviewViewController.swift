//
//  OldTopMoviewViewController.swift
//  MovieCatalog
//
//  Created by Martin Nordebäck on 2023-10-16.
//

import Foundation
import UIKit

class OldTopMovieViewController: UIViewController {
    private var topMovieList = [TrendingEntertainmentDetails]()
    let cellSpacingHeight: CGFloat = 8
    let cellHeightForRow: CGFloat = 48

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        tableView.dataSource = self
        tableView.delegate = self
        fetchData()
    }

    private func configureLayout() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Top 20 Movies"

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func fetchData() {
        Task {
            do {
                topMovieList = try await APICaller.shared.getTopMovieList()
                tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - EXTENSION

extension OldTopMovieViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Delegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeightForRow
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        cellSpacingHeight
    }

    // MARK: - Datasource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topMovieList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }

        // prevent index out of range
        if indexPath.row < topMovieList.count {
            let movie = topMovieList[indexPath.row]
            cell.configureCell(with: movie)
        } else {
            print("Index out of range")
        }
        return cell
    }
}


// FROM SEARCH VIEWS, JONATHAN EXAMPLE INCOPARTE LATER?
//    private func performQuery(with query: String?) {
//        guard query?.isEmpty != nil else { return }
//        let moviesResult = searchResultViewController.filteredResult(with: query).sorted { $0.title ?? "empty 0" < $1.title ?? "empty 1" }
//        var snapShot = SnapShot()
//        snapShot.appendSections([.searchMovieVC])
//        snapShot.appendItems(moviesResult, toSection: .searchMovieVC)
//        dataSource.apply(snapShot, animatingDifferences: true)
//    }
//
//    func filteredResult(with filter: String? = nil, limit: Int? = nil) -> [TrendingEntertainmentDetails] {
//        let filtered = movies.filter { $0.contains(filter) }
//        if let limit = limit {
//            return Array(filtered.prefix(through: limit))
//        } else {
//            return filtered
//        }
//    }
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor), tabbar issue with this

/*
 
 NSLayoutConstraint.activate([
     searchController.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 0),
     searchController.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
     view.trailingAnchor.constraint(equalToSystemSpacingAfter: searchController.trailingAnchor, multiplier: 1),
     tableView.topAnchor.constraint(equalToSystemSpacingBelow: searchController.bottomAnchor, multiplier: 1),
     tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
     view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 1),
     tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
 ])
 
 */
