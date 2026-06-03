//
//  MainViewModel.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import Foundation

final class MainViewModel {

    private let router: MainViewRouterProtocol
    
    let pages: [Page]
    let pageStatistics: [PageStatistic]

    var selectedPageIndex: Int
    var searchText: String

    init(
        router: MainViewRouterProtocol,
        pages: [Page],
        selectedPageIndex: Int = 0,
        searchText: String = ""
    ) {
        self.router = router
        
        self.pages = pages

        if pages.isEmpty {
            self.selectedPageIndex = 0
        } else {
            self.selectedPageIndex = min(
                max(selectedPageIndex, 0),
                pages.count - 1
            )
        }

        self.searchText = searchText
        self.pageStatistics = PageStatisticsBuilder.make(from: pages)
    }

    var currentPage: Page? {
        guard !pages.isEmpty else { return nil }
        return pages[selectedPageIndex]
    }

    var currentPageStatistic: PageStatistic? {
        pageStatistics.first { $0.id == currentPage?.id }
    }

    var filteredItems: [ListItem] {
        guard let page = currentPage else { return [] }

        let trimmed = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard !trimmed.isEmpty else {
            return page.items
        }

        return page.items.filter {
            $0.title.lowercased().contains(trimmed)
        }
    }

    @discardableResult
    func selectPage(at index: Int) -> Bool {
        guard pages.indices.contains(index) else {
            return false
        }

        guard selectedPageIndex != index else {
            return false
        }

        selectedPageIndex = index
        return true
    }

    func updateSearchText(_ text: String) {
        searchText = text
    }
    
    func navigateToStatisticSheet() {
        router.navigate(to: .toStatisticSheet(currentPageStatistic))
    }
}
