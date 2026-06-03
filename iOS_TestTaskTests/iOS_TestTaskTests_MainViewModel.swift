//
//  iOS_TestTaskTests_MainViewModel.swift
//  iOS_TestTaskTests
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
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

    func testInitClampsSelectedPageIndexIntoValidRange() {
        let viewModel = makeViewModel(pages: makePages(), selectedPageIndex: 99)

        XCTAssertEqual(viewModel.selectedPageIndex, 1)
        XCTAssertEqual(viewModel.currentPage?.id, "page-2")
    }

    func testInitClampsNegativeSelectedPageIndexToZero() {
        let viewModel = makeViewModel(pages: makePages(), selectedPageIndex: -5)

        XCTAssertEqual(viewModel.selectedPageIndex, 0)
        XCTAssertEqual(viewModel.currentPage?.id, "page-1")
    }

    func testInitWithEmptyPagesSetsSelectedPageIndexToZero() {
        let viewModel = makeViewModel(pages: [])

        XCTAssertEqual(viewModel.selectedPageIndex, 0)
    }

    func testInitDefaultValues() {
        let viewModel = makeViewModel(pages: makePages())

        XCTAssertEqual(viewModel.selectedPageIndex, 0)
        XCTAssertEqual(viewModel.searchText, "")
    }

    // MARK: - currentPage

    func testCurrentPageReturnsNilForEmptyPages() {
        let viewModel = makeViewModel(pages: [])

        XCTAssertNil(viewModel.currentPage)
    }

    func testCurrentPageReturnsCorrectPage() {
        let viewModel = makeViewModel(pages: makePages(), selectedPageIndex: 1)

        XCTAssertEqual(viewModel.currentPage?.id, "page-2")
    }

    // MARK: - selectPage

    func testSelectPageReturnsFalseForInvalidAndSameIndex() {
        let viewModel = makeViewModel(pages: makePages(), selectedPageIndex: 0)

        XCTAssertFalse(viewModel.selectPage(at: -1))
        XCTAssertFalse(viewModel.selectPage(at: 0))
        XCTAssertTrue(viewModel.selectPage(at: 1))
        XCTAssertEqual(viewModel.selectedPageIndex, 1)
    }

    func testSelectPageReturnsFalseForOutOfBoundsIndex() {
        let viewModel = makeViewModel(pages: makePages(), selectedPageIndex: 0)

        XCTAssertFalse(viewModel.selectPage(at: 99))
        XCTAssertEqual(viewModel.selectedPageIndex, 0)
    }

    func testSelectPageUpdatesCurrentPage() {
        let viewModel = makeViewModel(pages: makePages(), selectedPageIndex: 0)

        viewModel.selectPage(at: 1)

        XCTAssertEqual(viewModel.currentPage?.id, "page-2")
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

    func testFilteredItemsReturnsEmptyForEmptyPages() {
        let viewModel = makeViewModel(pages: [])

        XCTAssertTrue(viewModel.filteredItems.isEmpty)
    }

    func testFilteredItemsReturnsCurrentPageItemsForEmptySearch() {
        let viewModel = makeViewModel(pages: makePages(), selectedPageIndex: 1, searchText: "   ")

        XCTAssertEqual(viewModel.filteredItems.map(\.id), ["p2-snow", "p2-cloud"])
    }

    func testFilteredItemsUsesTrimmedCaseInsensitiveSearch() {
        let viewModel = makeViewModel(pages: makePages(), selectedPageIndex: 0, searchText: "  riVeR ")

        XCTAssertEqual(viewModel.filteredItems.map(\.id), ["p1-river"])
    }

    func testFilteredItemsReturnsEmptyWhenNoMatchFound() {
        let viewModel = makeViewModel(pages: makePages(), selectedPageIndex: 0, searchText: "xyz")

        XCTAssertTrue(viewModel.filteredItems.isEmpty)
    }

    func testFilteredItemsMatchesPartialTitle() {
        let viewModel = makeViewModel(pages: makePages(), selectedPageIndex: 0, searchText: "ree")

        XCTAssertEqual(viewModel.filteredItems.map(\.id), ["p1-trees"])
    }

    func testFilteredItemsUpdatesAfterPageSwitch() {
        let viewModel = makeViewModel(pages: makePages(), selectedPageIndex: 0, searchText: "snow")

        XCTAssertTrue(viewModel.filteredItems.isEmpty)

        viewModel.selectPage(at: 1)

        XCTAssertEqual(viewModel.filteredItems.map(\.id), ["p2-snow"])
    }

    // MARK: - currentPageStatistic

    func testCurrentPageStatisticMatchesSelectedPage() {
        let viewModel = makeViewModel(pages: makePages(), selectedPageIndex: 0)

        XCTAssertEqual(viewModel.currentPageStatistic?.id, "page-1")
        XCTAssertEqual(viewModel.currentPageStatistic?.itemCount, 2)
    }

    func testCurrentPageStatisticReturnsNilForEmptyPages() {
        let viewModel = makeViewModel(pages: [])

        XCTAssertNil(viewModel.currentPageStatistic)
    }

    func testCurrentPageStatisticUpdatesAfterPageSwitch() {
        let viewModel = makeViewModel(pages: makePages(), selectedPageIndex: 0)

        viewModel.selectPage(at: 1)

        XCTAssertEqual(viewModel.currentPageStatistic?.id, "page-2")
        XCTAssertEqual(viewModel.currentPageStatistic?.itemCount, 2)
    }

    // MARK: - navigateToStatisticSheet

    func testNavigateToStatisticSheetCallsRouterWithCurrentStatistic() {
        let viewModel = makeViewModel(pages: makePages(), selectedPageIndex: 0)

        viewModel.navigateToStatisticSheet()

        if case .toStatisticSheet(let statistic) = router.navigatedRoute {
            XCTAssertEqual(statistic?.id, "page-1")
        } else {
            XCTFail("Expected toStatisticSheet route")
        }
    }

    func testNavigateToStatisticSheetPassesNilStatisticForEmptyPages() {
        let viewModel = makeViewModel(pages: [])

        viewModel.navigateToStatisticSheet()

        if case .toStatisticSheet(let statistic) = router.navigatedRoute {
            XCTAssertNil(statistic)
        } else {
            XCTFail("Expected toStatisticSheet route")
        }
    }

    // MARK: - Helpers

    private func makeViewModel(pages: [Page], selectedPageIndex: Int = 0, searchText: String = "") -> MainViewModel {
        MainViewModel(
            router: router,
            pages: pages,
            selectedPageIndex: selectedPageIndex,
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
