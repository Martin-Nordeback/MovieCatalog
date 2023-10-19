//
//  SearchResultsViewController.swift
//  MovieCatalog
//
//  Created by Martin Nordebäck on 2023-10-17.
//

import UIKit

class SearchResultsViewController: UIViewController {

    var selectedTitle: String?
    private lazy var movies = [TrendingEntertainmentDetails]()
    let cellSpacingHeight: CGFloat = 8
    let cellHeightForRow: CGFloat = 48
    
    typealias DataSource = UITableViewDiffableDataSource<Section, TrendingEntertainmentDetails>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, TrendingEntertainmentDetails>

    var dataSource: DataSource!
    var router: MovieRouter?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureLayout()
        tableView.delegate = self

        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, movie in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: movie)
            return cell
        })
    }
   
    func filteredResult(with filter: String? = nil, limit: Int? = nil) -> [TrendingEntertainmentDetails] {
        let filtered = movies.filter { $0.contains(filter)}
        if let limit = limit {
            return Array(filtered.prefix(through: limit))
        } else {
            return filtered
        }
    }
    
    private func configureLayout() {
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.title = "Top 20 Movies"

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeightForRow
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        cellSpacingHeight
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let action = UIAction(title: "Watchlist", image: UIImage(systemName: "plus"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                print("Add to watch action here list here")
            }
            return UIMenu(title: "Menu", image: UIImage(systemName: "person"), identifier: nil, options: .displayInline, children: [action])
        }
        return config
    }
}
/*
 
 
NETFLIX CLONE

 protocol SearchResultsViewControllerDelegate: AnyObject {
     func searchResultViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
 }

 class SearchResultsViewController: UIViewController {
     public var titles: [Title] = [Title]()

     public weak var delegate: SearchResultsViewControllerDelegate?

     public let searchResultCollectionView: UICollectionView = {
         let layout = UICollectionViewFlowLayout()
         layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
         layout.minimumInteritemSpacing = 0
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
         collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
         return collectionView

     }()

     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .systemBackground
         view.addSubview(searchResultCollectionView)

         searchResultCollectionView.delegate = self
         searchResultCollectionView.dataSource = self
     }

     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         searchResultCollectionView.frame = view.bounds
     }
 }

 extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return titles.count
     }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
             return UICollectionViewCell()
         }
         let title = titles[indexPath.row]
         cell.configure(with: title.poster_path ?? "")
         return cell
     }

     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         collectionView.deselectItem(at: indexPath, animated: true)
         let title = titles[indexPath.row]
         let titleName = title.original_title ?? ""
         APICaller.shared.getMovie(with: titleName) { [weak self] result in
             switch result {
             case let .success(videoElement):
                 self?.delegate?.searchResultViewControllerDidTapItem(TitlePreviewViewModel(title: title.original_title ?? "", youtubeView: videoElement, titleOverview: title.overview ?? ""))

             case let .failure(error):
                 print(error.localizedDescription)
             }
         }
     }
 }

 */
