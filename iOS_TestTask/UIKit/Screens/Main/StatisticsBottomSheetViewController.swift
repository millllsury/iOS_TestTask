//
//  StatisticsBottomSheetViewController.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import UIKit

final class StatisticsBottomSheetViewController: UIViewController {
    private let statistic: PageStatistic?
    
    init(statistic: PageStatistic?) {
        self.statistic = statistic
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = statistic?.pageTitle ?? NSLocalizedString(
            "statistics.title",
            comment: "Title of the statistics bottom sheet"
        )
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.textColor = .label
        
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = NSLocalizedString(
            "statistics.subtitle",
            comment: "Subtitle describing the statistics content"
        )
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = .zero
        
        let headerStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.axis = .vertical
        headerStackView.spacing = Layout.heightForHeaderInSection
        
        let contentView = makeContentView()
        
        view.addSubview(headerStackView)
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.spaceXXL),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.spaceXXL),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.spaceXXL),
            
            contentView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: Layout.spaceXXL),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.spaceXXL),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.spaceXXL)
        ])
    }
    
    private func makeContentView() -> UIView {
        guard let statistic else {
            let emptyLabel = UILabel()
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            emptyLabel.text = NSLocalizedString("statistics.empty", comment: "Empty state when no statistics are available")
            emptyLabel.font = .preferredFont(forTextStyle: .body)
            emptyLabel.textColor = .secondaryLabel
            emptyLabel.numberOfLines = .zero
            return emptyLabel
        }
        
        return StatisticsCardView(statistic: statistic)
    }
}
