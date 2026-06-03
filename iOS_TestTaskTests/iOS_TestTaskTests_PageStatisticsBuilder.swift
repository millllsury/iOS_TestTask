//
//  iOS_TestTaskTests.swift
//  iOS_TestTaskTests
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import XCTest
@testable import iOS_TestTask

final class iOS_TestTaskTests_PageStatisticsBuilder: XCTestCase {

    func testPageStatisticsBuilderReturnsItemCountAndTopCharacters() {
        let pages = [
            Page(
                id: "page-list-1",
                imageName: "img1",
                title: "List 1",
                items: [
                    ListItem(id: "item-apple", title: "apple", description: "red fruit", imageName: "img3"),
                    ListItem(id: "item-banana", title: "banana", description: "yellow fruit", imageName: "img4"),
                    ListItem(id: "item-orange", title: "orange", description: "citrus fruit", imageName: "img5"),
                    ListItem(id: "item-blueberry", title: "blueberry", description: "small berry", imageName: "img6")
                ]
            )
        ]
        
        let statistics = PageStatisticsBuilder.make(from: pages)

        XCTAssertEqual(statistics.count, 1)
        XCTAssertEqual(statistics[0].pageTitle, "List 1")
        XCTAssertEqual(statistics[0].itemCount, 4)
        XCTAssertEqual(
            statistics[0].topCharacters,
            [
                CharacterStatistic(character: "a", count: 5),
                CharacterStatistic(character: "e", count: 4),
                CharacterStatistic(character: "b", count: 3)
            ]
        )
    }
    
    func testPageStatisticsBuilderReturnsEmptyTopCharactersForEmptyItems() {
        let pages = [
            Page(
                id: "page-empty-list",
                imageName: "img1",
                title: "Empty List",
                items: []
            )
        ]

        let statistics = PageStatisticsBuilder.make(from: pages)

        XCTAssertEqual(statistics.count, 1)
        XCTAssertEqual(statistics[0].itemCount, 0)
        XCTAssertTrue(statistics[0].topCharacters.isEmpty)
    }

    func testPageStatisticsBuilderSortsAlphabeticallyWhenCountsAreEqual() {
        let pages = [
            Page(
                id: "page-tie-breaker",
                imageName: "img1",
                title: "Tie Breaker",
                items: [
                    ListItem(id: "item-abc", title: "abc", description: "first item", imageName: "img3"),
                    ListItem(id: "item-cba", title: "cba", description: "second item", imageName: "img4")
                ]
            )
        ]

        let statistics = PageStatisticsBuilder.make(from: pages)

        XCTAssertEqual(
            statistics[0].topCharacters,
            [
                CharacterStatistic(character: "a", count: 2),
                CharacterStatistic(character: "b", count: 2),
                CharacterStatistic(character: "c", count: 2)
            ]
        )
    }

    func testPageStatisticsBuilderIgnoresNonLettersAndIsCaseInsensitive() {
        let pages = [
            Page(
                id: "page-mixed-input",
                imageName: "img1",
                title: "Mixed Input",
                items: [
                    ListItem(id: "item-a1", title: "A1!", description: "alpha one", imageName: "img3"),
                    ListItem(id: "item-a2", title: "a?", description: "alpha two", imageName: "img4"),
                    ListItem(id: "item-bb", title: "Bb", description: "beta beta", imageName: "img5")
                ]
            )
        ]

        let statistics = PageStatisticsBuilder.make(from: pages)

        XCTAssertEqual(
            statistics[0].topCharacters,
            [
                CharacterStatistic(character: "a", count: 2),
                CharacterStatistic(character: "b", count: 2)
            ]
        )
    }

    func testPageStatisticsBuilderUsesOnlyTitlesForCharacterStatistics() {
        let pages = [
            Page(
                id: "page-title-only",
                imageName: "img1",
                title: "Title Only",
                items: [
                    ListItem(id: "item-aa", title: "aa", description: "zzzz", imageName: "img3"),
                    ListItem(id: "item-b", title: "b", description: "yyyy", imageName: "img4")
                ]
            )
        ]

        let statistics = PageStatisticsBuilder.make(from: pages)

        XCTAssertEqual(
            statistics[0].topCharacters,
            [
                CharacterStatistic(character: "a", count: 2),
                CharacterStatistic(character: "b", count: 1)
            ]
        )
    }

}
