//
//  ItemTableViewCell.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import UIKit

final class ItemTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ItemTableViewCell"

    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 210/255, green: 231/255, blue: 225/255, alpha: 1)
        view.layer.cornerRadius = Layout.spaceL
        return view
    }()

    private let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Layout.spaceXS
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .label
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        let labelsStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.axis = .vertical
        labelsStackView.spacing = Layout.heightForHeaderInSection

        contentView.addSubview(cardView)
        cardView.addSubview(previewImageView)
        cardView.addSubview(labelsStackView)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.spaceXS/2),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.spaceXL),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.spaceXL),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.spaceXS/2),

            previewImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Layout.spaceL),
            previewImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            previewImageView.widthAnchor.constraint(equalToConstant: Layout.previewImageView),
            previewImageView.heightAnchor.constraint(equalToConstant: Layout.previewImageView),

            labelsStackView.leadingAnchor.constraint(equalTo: previewImageView.trailingAnchor, constant: Layout.spaceM),
            labelsStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            labelsStackView.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -Layout.spaceL)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        previewImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }

    func configure(item: ListItem) {
        previewImageView.image = UIImage(named: item.imageName) ?? UIImage(systemName: "img1")
        titleLabel.text = item.title
        subtitleLabel.text = item.description
    }
}
