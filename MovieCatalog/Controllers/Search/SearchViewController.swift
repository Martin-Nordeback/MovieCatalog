
import UIKit

class SearchViewController: UIViewController {

    // MARK: - Properties
    typealias DataSource = UITableViewDiffableDataSource<Section, TrendingEntertainmentDetails>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, TrendingEntertainmentDetails>

    var dataSource: DataSource!

    private var movies = [TrendingEntertainmentDetails]()

    // MARK: - Views
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here.."
        return searchController
    }()


    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureDataSource()
        performQueryApi(with: nil)
    }
}


// MARK: - UITableViewDataSource & Delegate
extension SearchViewController: UITableViewDelegate {

//    DELEGATE
    private func configureLayout() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        tableView.delegate = self
        searchController.searchResultsUpdater = self

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 1),
            tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 1),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: tableView.bottomAnchor, multiplier: 1),
        ])
    }

//    DATASOURCE
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


// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3 else { return }
        performQueryApi(with: query)
    }
}


// MARK: - Search Functions
extension SearchViewController {

    private func performQueryApi(with query: String?) {
        guard let query = query, !query.isEmpty else { return }
        Task {
            do {
                movies = try await APICaller.shared.searchMovie(with: query) // the check is made from UISearchResultsUpdating
                var snapShot = SnapShot()
                snapShot.appendSections([.searchMovieVC])
                snapShot.appendItems(movies, toSection: .searchMovieVC)
                await dataSource.apply(snapShot, animatingDifferences: true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
