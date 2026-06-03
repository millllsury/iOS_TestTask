//
//  StatisticsCardView.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import UIKit

final class StatisticsCardView: UIView {

    init(statistic: PageStatistic) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = Layout.statisticCardRadius

        let countLabel = UILabel()
        countLabel.font = .preferredFont(forTextStyle: .subheadline)
        countLabel.textColor = .secondaryLabel
        countLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("statistics.items_count", comment: "Format for item count in statistics card"),
            statistic.itemCount
        )

        let characterLabels: [UILabel] = if statistic.topCharacters.isEmpty {
            [makeEmptyStateLabel()]
        } else {
            statistic.topCharacters.map { makeCharacterLabel(for: $0) }
        }

        let charactersStackView = UIStackView(arrangedSubviews: characterLabels)
        charactersStackView.axis = .vertical
        charactersStackView.spacing = Layout.spaceS

        let rootStackView = UIStackView(arrangedSubviews: [countLabel, charactersStackView])
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        rootStackView.axis = .vertical
        rootStackView.spacing = Layout.spaceM

        addSubview(rootStackView)

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: topAnchor, constant: Layout.spaceXL),
            rootStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.spaceXL),
            rootStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Layout.spaceXL),
            rootStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Layout.spaceXL)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeCharacterLabel(for statistic: CharacterStatistic) -> UILabel {
        let label = UILabel()
        label.font = .monospacedSystemFont(ofSize: Layout.spaceXL, weight: .medium)
        label.textColor = .label
        label.text = "\(statistic.character) = \(statistic.count)"
        return label
    }

    private func makeEmptyStateLabel() -> UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .secondaryLabel
        label.text = NSLocalizedString("statistics.no_characters", comment: "Empty state for missing character statistics")
        return label
    }
}
