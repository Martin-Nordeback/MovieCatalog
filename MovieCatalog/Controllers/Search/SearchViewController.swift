
import UIKit

class SearchViewController: UIViewController {

    // MARK: - Properties
    typealias DataSource = UITableViewDiffableDataSource<Section, TrendingEntertainmentDetails>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, TrendingEntertainmentDetails>

    var dataSource: DataSource!

    let searchResultViewController = SearchResultsViewController()

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
        performQueryApi(with: nil)
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


// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQueryApi(with: searchText)
    }
}


// MARK: - Search Functions
extension SearchViewController {

    private func performQueryApi(with query: String?) {
        guard let query = query, !query.isEmpty else { return }
        guard query.count >= 3 else { return }

        Task {
            do {
                movies = try await APICaller.shared.searchMovie(with: query)
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
            searchBar.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 0),
            searchBar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: searchBar.trailingAnchor, multiplier: 1),
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: searchBar.bottomAnchor, multiplier: 1),
            tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 1),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}



