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


    private let uiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

    private let uiImageView: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.image = UIImage(systemName: "star.fill")
        uiImageView.tintColor = .systemYellow
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        return uiImageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellsLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureCell(with model: TrendingEntertainmentDetails) {
        uiLabel.text = model.title
    }

    private func configureCellsLayout() {
        contentView.addSubview(uiLabel)
        contentView.addSubview(uiImageView)
//        contentView.backgroundColor = .systemGray6
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true

        NSLayoutConstraint.activate([
            uiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            uiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            uiLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            uiImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            uiImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
}

