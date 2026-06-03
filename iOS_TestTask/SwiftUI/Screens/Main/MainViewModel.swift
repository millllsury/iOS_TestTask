//
//  MainViewModel.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {

    private let router: MainViewRouterProtocol

    @Published var pages: [Page]
    let pageStatistics: [PageStatistic]

    @Published var selectedPageIndex: Int
    @Published var searchText: String

    init(
        router: MainViewRouterProtocol,
        pages: [Page],
        searchText: String = ""
    ) {
        self.router = router
        self.pages = pages
        self.selectedPageIndex = pages.isEmpty
            ? 0
            : CarouselLoop.middleIndex(pageCount: pages.count)
        self.searchText = searchText
        self.pageStatistics = PageStatisticsBuilder.make(from: pages)
    }

    var currentRealPageIndex: Int {
        CarouselLoop.realIndex(for: selectedPageIndex, pageCount: pages.count)
    }

    var currentPage: Page {
        guard !pages.isEmpty else { fatalError("Pages must not be empty") }
        return pages[currentRealPageIndex]
    }

    var currentPageStatistic: PageStatistic {
        pageStatistics.first { $0.id == currentPage.id }
            ?? PageStatisticsBuilder.make(from: [currentPage])[0]
    }

    var filteredItems: [ListItem] {
        let trimmed = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard !trimmed.isEmpty else {
            return currentPage.items
        }

        return currentPage.items.filter {
            $0.title.lowercased().contains(trimmed)
        }
    }

    @discardableResult
    func selectPage(at realIndex: Int) -> Bool {
        guard pages.indices.contains(realIndex) else { return false }

        let currentReal = currentRealPageIndex
        guard currentReal != realIndex else { return false }

        let offset = realIndex - currentReal
        selectedPageIndex = selectedPageIndex + offset
        return true
    }

    func updateSearchText(_ text: String) {
        searchText = text
    }

    func showStatisticSheet() {
        router.navigate(to: .statisticSheet)
    }
}
