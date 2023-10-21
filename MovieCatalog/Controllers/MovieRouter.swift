
import UIKit

class MovieRouter: MovieRouterProtocol {
    weak var navigationController: UINavigationController?

    func navigateToMovieDetail(with model: TrendingEntertainmentDetails) {
        let selectedViewController = SelectedViewController()
        selectedViewController.topMovie = model
        navigationController?.pushViewController(selectedViewController, animated: true)
    }
}
