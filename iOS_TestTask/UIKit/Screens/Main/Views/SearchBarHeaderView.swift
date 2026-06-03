//
//  SearchBarHeaderView.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//


import UIKit

final class SearchBarHeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier = "SearchBarHeaderView"
    
    let searchBar: UISearchBar = {
        
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .systemBackground
        searchBar.searchTextField.backgroundColor = .systemGray5
        searchBar.searchTextField.textColor = .label
        searchBar.searchTextField.leftView?.tintColor = .systemGray
        searchBar.searchTextField.layer.cornerRadius = Layout.spaceL
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.attributedPlaceholder =
        
        NSAttributedString(
            string: NSLocalizedString(
                "main.search.placeholder",
                comment: ""
            ),
            attributes: [
                .foregroundColor: UIColor.systemGray
            ]
        )
        
        return searchBar
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(searchBar)
        
        let trailingConstraint = searchBar.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -Layout.spaceXL
        )

        let bottomConstraint = searchBar.trailingAnchor.constraint(
            equalTo: contentView.trailingAnchor,
            constant: -Layout.spaceS
        )

        trailingConstraint.priority = .defaultHigh
        bottomConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            trailingConstraint,
            bottomConstraint,
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.spaceS),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.spaceXL),
            searchBar.heightAnchor.constraint(equalToConstant: Layout.searchBarHeight)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
