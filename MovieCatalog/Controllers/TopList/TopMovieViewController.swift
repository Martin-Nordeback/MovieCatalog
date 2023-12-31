import UIKit

enum Section {
    case topMovieVC
    case searchMovieVC
}

// MARK: - TO HERE

protocol AddToWatchListProtocol {
    func saveToWatchListAt(indexPath: IndexPath)
}

class TopMovieViewController: UIViewController {

    private var topMovieList = [TrendingEntertainmentDetails]()

    let cellHeightForRow: CGFloat = 48

    typealias DataSource = UITableViewDiffableDataSource<Section, TrendingEntertainmentDetails>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, TrendingEntertainmentDetails>

    var dataSource: DataSource!
    var router: MovieRouter?
    var apiCaller: APICallerProtocol?


    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        router = MovieRouter()
        router?.navigationController = navigationController

        configureLayout()
        tableView.delegate = self
        fetchData()
        configureDataSource()
    }

    private func fetchData() {
        Task {
            do {
                guard let results = try await apiCaller?.getTopMovieList(language: nil, page: nil) else { return }
                topMovieList = results
                var snapShot = SnapShot()
                snapShot.appendSections([.topMovieVC])
                snapShot.appendItems(topMovieList, toSection: .topMovieVC)
                await dataSource.apply(snapShot, animatingDifferences: true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }


    func saveToWatchListAt(indexPath: IndexPath) {
        DataPersistentManager.shared.saveMoveWith(model: topMovieList[indexPath.row]) { result in
            switch result {
            case let .success(success):
                print("download to database")
            case let .failure(failure):
                print(failure.localizedDescription)
            }
        }
    }
}

// MARK: - Data Source Configuration
extension TopMovieViewController {
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

// MARK: - TV-DELEGATES
extension TopMovieViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeightForRow
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = topMovieList[indexPath.row]
        router?.navigateToMovieDetail(with: selectedCell)
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let action = UIAction(title: "Watchlist", image: UIImage(systemName: "plus"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                print("Add to watch action here list here")
                self.saveToWatchListAt(indexPath: indexPath)
            }
            return UIMenu(title: "Menu", image: UIImage(systemName: "person"), identifier: nil, options: .displayInline, children: [action])
        }
        return config
    }
}

// MARK: - SETUP-UI
extension TopMovieViewController {
    private func configureLayout() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Top 20 Movies"

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 2),
            tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 1),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: tableView.bottomAnchor, multiplier: 0),
        ])
    }
}
