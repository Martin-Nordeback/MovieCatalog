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
