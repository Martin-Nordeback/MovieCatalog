import UIKit

class WatchListViewController: UIViewController {

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, TrendingEntertainmentDetailsEntity>?

    private var savedMoviesFromDatabase = [TrendingEntertainmentDetailsEntity]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Watchlist"

        createCollectionView()
        createDataSource()
        fetchFromLocalStorage()
    }

    private func createCollectionView() {
        print("here 1")
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    private func createDataSource() {
        print("here 2")
        dataSource = UICollectionViewDiffableDataSource<Section, TrendingEntertainmentDetailsEntity>(
            collectionView: collectionView) { collectionView, indexPath, movie in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

                var content = UIListContentConfiguration.cell()
                content.text = "\(String(describing: movie.title))"
                cell.contentConfiguration = content
                print("Cell configuration called for indexPath: \(indexPath)")

                return cell
            }
    }

    private func fetchFromLocalStorage() {
        print("Fetching movies from Core Data...")
        DataPersistentManager.shared.fetchingMoviesFromDataBase { result in
            switch result {
            case let .success(success):
                self.savedMoviesFromDatabase = success
                print("Fetched \(self.savedMoviesFromDatabase.count) movies from Core Data.")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }

            case let .failure(failure):
                print("Error fetching data: \(failure.localizedDescription)")
            }
        }
    }
}
