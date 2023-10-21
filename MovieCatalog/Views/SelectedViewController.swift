import SDWebImage
import UIKit

class SelectedViewController: UIViewController {
    var topMovie: TrendingEntertainmentDetails?

    private let posterImageView: UIImageView = {
        let posterImageView = UIImageView()
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
        posterImageView.tintColor = .white
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        return posterImageView
    }()

    private let movieVoteAverage: UILabel = {
        let movieVoteAverage = UILabel()
        movieVoteAverage.text = "8,0"
        movieVoteAverage.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        movieVoteAverage.translatesAutoresizingMaskIntoConstraints = false
        return movieVoteAverage
    }()

    private let movieOverview: UILabel = {
        let movieOverview = UILabel()
        movieOverview.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        movieOverview.translatesAutoresizingMaskIntoConstraints = false
        movieOverview.numberOfLines = 0
        return movieOverview
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configurePosterImage(with: topMovie?.posterPath)
    }

    private func configurePosterImage(with posterPath: String?) {
        guard let posterPath = posterPath,
              let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else {
            posterImageView.image = UIImage(named: "placeHolderImage")
            return
        }
        posterImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeHolderImage"), options: []) { image, error, cacheType, imageURL in
            if error != nil {
                print("Error loading image: \(String(describing: error?.localizedDescription))")
                self.posterImageView.image = UIImage(named: "errorImage")
            }
        }
    }

    @objc func addToWatchListActionButton() {
        print("Action here")
    }

    private func configureLayout() {
        // TOOLBAR & TITLE
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        navigationItem.title = topMovie?.title ?? topMovie?.originalTitle

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain, target: self,
            action: #selector(addToWatchListActionButton))

        // POSTER
        view.addSubview(posterImageView)

        // VOTEAVERAGE
        view.addSubview(movieVoteAverage)
        movieVoteAverage.text = topMovie?.voteAverage?.formatted()

        // OVERVIEW
        view.addSubview(scrollView)
        scrollView.addSubview(movieOverview)
        movieOverview.text = topMovie?.overview

        // Poster ImageView Constraints
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            posterImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            posterImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 300), // Limiting height
        ])

        // Vote Average Label Constraints
        NSLayoutConstraint.activate([
            movieVoteAverage.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 10),
            movieVoteAverage.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -60), // Adjust constant as needed
        ])

        // ScrollView Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: movieVoteAverage.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        // Movie Overview Constraints
        NSLayoutConstraint.activate([
            movieOverview.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            movieOverview.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            movieOverview.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            movieOverview.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            movieOverview.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
}

// extension UIBarButtonItem {
//    static func createCustomButton(withImage image: UIImage?, title: String?, target: Any, action: Selector) -> UIBarButtonItem {
//        let customButton = UIButton(type: .system)
//
//        customButton.configuration?.titlePadding = 30
//        customButton.configuration?.imagePadding = 30
//
//        customButton.addTarget(target, action: action, for: .touchUpInside)
//
//        return UIBarButtonItem(customView: customButton)
//    }
// }
