//
//  CustomTableViewCell.swift
//  MovieCatalog
//
//  Created by Martin Nordebäck on 2023-10-15.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"
    private var topMovieList = [TrendingEntertainmentDetails]()

    private let movieLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

//    private let uiImageView: UIImageView = {
//        let uiImageView = UIImageView()
//        uiImageView.image = UIImage(systemName: "star.fill")
//        uiImageView.tintColor = .systemYellow
//        uiImageView.translatesAutoresizingMaskIntoConstraints = false
//        return uiImageView
//    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellsLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configureCell(with model: TrendingEntertainmentDetails) {
        movieLabel.text = model.title
    }
    
//    private func addToWatchList(with indexPath: IndexPath) {
//        DataPersistentManager.shared.saveMoveWith(model: topMovieList[indexPath.row]) { result in
//            switch result {
//                case .success(let success):
//                    print("download to database")
//                case .failure(let failure):
//                    print(failure.localizedDescription)
//            }
//        }
//    }

    private func configureCellsLayout() {
        contentView.addSubview(movieLabel)
//        contentView.addSubview(uiImageView)
//        contentView.layer.borderWidth = 2
//        contentView.layer.cornerRadius = 8
//        contentView.clipsToBounds = true

        NSLayoutConstraint.activate([
            movieLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            movieLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            movieLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
//            uiImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            uiImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20), removed the star image
        ])
    }
}
