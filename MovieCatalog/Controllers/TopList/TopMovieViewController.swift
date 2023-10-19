import UIKit


// MARK: - EXTRACT FROM THIS VIEW
protocol MovieRouting {
    func navigateToMovieDetail(with model: TrendingEntertainmentDetails)
}

class MovieRouter: MovieRouting {
    weak var navigationController: UINavigationController?

    func navigateToMovieDetail(with model: TrendingEntertainmentDetails) {
        let selectedViewController = SelectedViewController()
        selectedViewController.topMovie = model
        navigationController?.pushViewController(selectedViewController, animated: true)
    }
}

enum Section {
    case topMovieVC
    case searchMovieVC
}
// MARK: - TO HERE

class TopMovieViewController: UIViewController {
    private var topMovieList = [TrendingEntertainmentDetails]()
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
        view.backgroundColor = .systemBackground
        router = MovieRouter()
        router?.navigationController = navigationController

        configureLayout()
        tableView.delegate = self
        fetchData()

        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, movie in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCell(with: movie)
            return cell
        })
    }

    private func fetchData() {
        Task {
            do {
                topMovieList = try await APICaller.shared.getTopMovieList()
                var snapShot = SnapShot()
                snapShot.appendSections([.topMovieVC])
                snapShot.appendItems(topMovieList, toSection: .topMovieVC)
                await dataSource.apply(snapShot, animatingDifferences: true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - TV-DELEGATES

extension TopMovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        cellHeightForRow
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        cellSpacingHeight
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
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
