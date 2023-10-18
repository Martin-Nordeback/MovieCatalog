

import UIKit

// MARK: - VIEWCONTROLLER

class TopMovieViewController: UIViewController {
    private var topMovieList = [TrendingEntertainmentDetails]()
    let cellSpacingHeight: CGFloat = 8
    let cellHeightForRow: CGFloat = 48

    typealias DataSource = UITableViewDiffableDataSource<Int, TrendingEntertainmentDetails>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, TrendingEntertainmentDetails>

    var dataSource: DataSource!

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                snapShot.appendSections([0])
                snapShot.appendItems(topMovieList)
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
        <#code#>
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

/*
#Preview {
    TopMovieViewController()
}
*/
