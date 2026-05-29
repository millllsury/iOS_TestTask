//
//  PageStatisticsBuilder.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import Foundation

enum PageStatisticsBuilder {

    static func make(from pages: [Page]) -> [PageStatistic] {
        pages.map { makeStatistic(for: $0) }
    }

    private static func makeStatistic(for page: Page) -> PageStatistic {

        var counts: [String: Int] = [:]

        for item in page.items {
            for character in item.title.lowercased() {

                guard character.isLetter else {
                    continue
                }

                counts[String(character), default: 0] += 1
            }
        }

        let topCharacters = counts
            .sorted {
                if $0.value == $1.value {
                    return $0.key < $1.key
                }

                return $0.value > $1.value
            }
            .prefix(3)
            .map {
                CharacterStatistic(
                    character: $0.key,
                    count: $0.value
                )
            }

        return PageStatistic(
            id: page.id,
            pageTitle: page.title,
            itemCount: page.items.count,
            topCharacters: topCharacters
        )
    }
}
