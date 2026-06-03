//
//  iOS_TestTaskTests_MainViewModel.swift
//  iOS_TestTaskTests
//
//  Created by Ekaterina Bastrikina on 01/06/2026.
//

import XCTest
@testable import iOS_TestTask

final class MockMainViewRouter: MainViewRouterProtocol {
    var navigatedRoute: MainViewRoute?

    func navigate(to route: MainViewRoute) {
        navigatedRoute = route
    }
}

final class iOS_TestTaskTests_MainViewModel: XCTestCase {

    private var router: MockMainViewRouter!

    override func setUp() {
        super.setUp()
        router = MockMainViewRouter()
    }

    override func tearDown() {
        router = nil
        super.tearDown()
    }

    // MARK: - init

    func testInitSetsSelectedPageIndexToMiddle() {
        let viewModel = makeViewModel(pages: makePages())

        let expected = CarouselLoop.middleIndex(pageCount: 2)
        XCTAssertEqual(viewModel.selectedPageIndex, expected)
    }

    func testInitWithEmptyPagesSetsSelectedPageIndexToZero() {
        let viewModel = makeViewModel(pages: [])

        XCTAssertEqual(viewModel.selectedPageIndex, 0)
    }

    func testInitDefaultSearchText() {
        let viewModel = makeViewModel(pages: makePages())

        XCTAssertEqual(viewModel.searchText, "")
    }

    // MARK: - currentRealPageIndex

    func testCurrentRealPageIndexAtMiddle() {
        let pages = makePages()
        let viewModel = makeViewModel(pages: pages)

        let expected = CarouselLoop.realIndex(
            for: CarouselLoop.middleIndex(pageCount: pages.count),
            pageCount: pages.count
        )
        XCTAssertEqual(viewModel.currentRealPageIndex, expected)
    }

    // MARK: - currentPage

    func testCurrentPageMatchesRealIndex() {
        let pages = makePages()
        let viewModel = makeViewModel(pages: pages)

        XCTAssertEqual(viewModel.currentPage.id, pages[viewModel.currentRealPageIndex].id)
    }

    func testCurrentPageChangesAfterSelectPage() {
        let viewModel = makeViewModel(pages: makePages())

        viewModel.selectPage(at: 1)

        XCTAssertEqual(viewModel.currentPage.id, "page-2")
    }

    // MARK: - selectPage

    func testSelectPageReturnsTrueForDifferentRealIndex() {
        let viewModel = makeViewModel(pages: makePages())

        let otherIndex = viewModel.currentRealPageIndex == 0 ? 1 : 0
        XCTAssertTrue(viewModel.selectPage(at: otherIndex))
    }

    func testSelectPageReturnsFalseForSameRealIndex() {
        let viewModel = makeViewModel(pages: makePages())

        XCTAssertFalse(viewModel.selectPage(at: viewModel.currentRealPageIndex))
    }

    func testSelectPageReturnsFalseForOutOfBoundsIndex() {
        let viewModel = makeViewModel(pages: makePages())

        XCTAssertFalse(viewModel.selectPage(at: 99))
        XCTAssertFalse(viewModel.selectPage(at: -1))
    }

    func testSelectPageUpdatesVirtualIndexByOffset() {
        let pages = makePages()
        let viewModel = makeViewModel(pages: pages)

        let initialVirtual = viewModel.selectedPageIndex
        let currentReal = viewModel.currentRealPageIndex
        let targetReal = currentReal == 0 ? 1 : 0
        let expectedOffset = targetReal - currentReal

        viewModel.selectPage(at: targetReal)

        XCTAssertEqual(viewModel.selectedPageIndex, initialVirtual + expectedOffset)
    }

    // MARK: - updateSearchText

    func testUpdateSearchTextUpdatesSearchText() {
        let viewModel = makeViewModel(pages: makePages())

        viewModel.updateSearchText("river")

        XCTAssertEqual(viewModel.searchText, "river")
    }

    func testUpdateSearchTextToEmptyString() {
        let viewModel = makeViewModel(pages: makePages(), searchText: "river")

        viewModel.updateSearchText("")

        XCTAssertEqual(viewModel.searchText, "")
    }

    // MARK: - filteredItems

    func testFilteredItemsReturnsCurrentPageItemsForEmptySearch() {
        let viewModel = makeViewModel(pages: makePages(), searchText: "   ")

        viewModel.selectPage(at: 1)

        XCTAssertEqual(viewModel.filteredItems.map(\.id), ["p2-snow", "p2-cloud"])
    }

    func testFilteredItemsUsesTrimmedCaseInsensitiveSearch() {
        let viewModel = makeViewModel(pages: makePages(), searchText: "  riVeR ")

        viewModel.selectPage(at: 0)

        XCTAssertEqual(viewModel.filteredItems.map(\.id), ["p1-river"])
    }

    func testFilteredItemsReturnsEmptyWhenNoMatchFound() {
        let viewModel = makeViewModel(pages: makePages(), searchText: "xyz")

        XCTAssertTrue(viewModel.filteredItems.isEmpty)
    }

    func testFilteredItemsMatchesPartialTitle() {
        let viewModel = makeViewModel(pages: makePages(), searchText: "ree")

        viewModel.selectPage(at: 0)

        XCTAssertEqual(viewModel.filteredItems.map(\.id), ["p1-trees"])
    }

    func testFilteredItemsUpdatesAfterPageSwitch() {
        let viewModel = makeViewModel(pages: makePages(), searchText: "snow")

        viewModel.selectPage(at: 0)
        XCTAssertTrue(viewModel.filteredItems.isEmpty)

        viewModel.selectPage(at: 1)
        XCTAssertEqual(viewModel.filteredItems.map(\.id), ["p2-snow"])
    }

    // MARK: - currentPageStatistic

    func testCurrentPageStatisticMatchesCurrentPage() {
        let viewModel = makeViewModel(pages: makePages())

        viewModel.selectPage(at: 0)

        XCTAssertEqual(viewModel.currentPageStatistic.id, "page-1")
        XCTAssertEqual(viewModel.currentPageStatistic.itemCount, 2)
    }

    func testCurrentPageStatisticUpdatesAfterPageSwitch() {
        let viewModel = makeViewModel(pages: makePages())

        viewModel.selectPage(at: 1)

        XCTAssertEqual(viewModel.currentPageStatistic.id, "page-2")
        XCTAssertEqual(viewModel.currentPageStatistic.itemCount, 2)
    }

    // MARK: - showStatisticSheet

    func testShowStatisticSheetCallsRouterWithCorrectRoute() {
        let viewModel = makeViewModel(pages: makePages())

        viewModel.showStatisticSheet()

        if case .statisticSheet = router.navigatedRoute {
            // success
        } else {
            XCTFail("Expected statisticSheet route")
        }
    }

    // MARK: - Helpers

    private func makeViewModel(pages: [Page], searchText: String = "") -> MainViewModel {
        MainViewModel(
            router: router,
            pages: pages,
            searchText: searchText
        )
    }

    private func makePages() -> [Page] {
        [
            Page(
                id: "page-1",
                imageName: "img1",
                title: "Nature",
                items: [
                    ListItem(id: "p1-river", title: "River", description: "Water stream", imageName: "img2"),
                    ListItem(id: "p1-trees", title: "Trees", description: "Green forest", imageName: "img3")
                ]
            ),
            Page(
                id: "page-2",
                imageName: "img4",
                title: "Sky",
                items: [
                    ListItem(id: "p2-snow", title: "Snow", description: "White mountain", imageName: "img5"),
                    ListItem(id: "p2-cloud", title: "Cloud", description: "Soft cloud", imageName: "img6")
                ]
            )
        ]
    }
}
