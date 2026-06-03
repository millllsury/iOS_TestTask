//
//  CarouselCompositionalLayout.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import UIKit

protocol CarouselLayoutDelegate: AnyObject {
    var pageCount: Int { get }
    var isAdjustingCarouselPosition: Bool { get }
    func carouselDidScroll(toVirtualIndex index: Int)
}

enum CarouselCompositionalLayout {
    static func make(delegate: CarouselLayoutDelegate) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .absolute(Layout.carouselHeight)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Layout.spaceXXL
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        section.visibleItemsInvalidationHandler = { [weak delegate] items, offset, environment in
            
            guard
                let delegate,
                !delegate.isAdjustingCarouselPosition,
                delegate.pageCount > 0
            else {
                return
            }

            let containerCenterX =
                offset.x + environment.container.contentSize.width / 2

            let closestItem = items.min {
                abs($0.frame.midX - containerCenterX) <
                abs($1.frame.midX - containerCenterX)
            }

            guard let closestItem else {
                return
            }

            delegate.carouselDidScroll(
                toVirtualIndex: closestItem.indexPath.item
            )
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
