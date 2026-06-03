//
//  MockPages.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import Foundation

enum MockPages {
    private static func localized(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }

    static let data: [Page] = [
        Page(id: "page-nature",
             imageName: "img1",
             title: localized("page.nature.title"),
             items: [
                ListItem(id: "nature-waterfall", title: localized("item.nature.waterfall.title"), description: localized("item.nature.waterfall.description"), imageName: "img3"),
                ListItem(id: "nature-trees", title: localized("item.nature.trees.title"), description: localized("item.nature.trees.description"), imageName: "img4"),
                ListItem(id: "nature-forest", title: localized("item.nature.forest.title"), description: localized("item.nature.forest.description"), imageName: "img5")
             ]),
        Page(id: "page-waterfall",
             imageName: "img2",
             title: localized("page.waterfall.title"),
             items: [
                ListItem(id: "waterfall-water", title: localized("item.waterfall.water.title"), description: localized("item.waterfall.water.description"), imageName: "img7"),
                ListItem(id: "waterfall-air", title: localized("item.waterfall.air.title"), description: localized("item.waterfall.air.description"), imageName: "img8"),
                ListItem(id: "waterfall-fresh", title: localized("item.waterfall.fresh.title"), description: localized("item.waterfall.fresh.description"), imageName: "img9")
             ]),
        Page(id: "page-forest",
             imageName: "img6",
             title: localized("page.forest.title"),
             items: [
                ListItem(id: "forest-wind", title: localized("item.forest.wind.title"), description: localized("item.forest.wind.description"), imageName: "img10"),
                ListItem(id: "forest-valley", title: localized("item.forest.valley.title"), description: localized("item.forest.valley.description"), imageName: "img11"),
                ListItem(id: "forest-horse", title: localized("item.forest.horse.title"), description: localized("item.forest.horse.description"), imageName: "img12"),
                ListItem(id: "waterfall-water", title: localized("item.waterfall.water.title"), description: localized("item.waterfall.water.description"), imageName: "img7"),
                ListItem(id: "waterfall-air", title: localized("item.waterfall.air.title"), description: localized("item.waterfall.air.description"), imageName: "img8"),
                ListItem(id: "waterfall-fresh", title: localized("item.waterfall.fresh.title"), description: localized("item.waterfall.fresh.description"), imageName: "img9"),
                ListItem(id: "forest-wind", title: localized("item.forest.wind.title"), description: localized("item.forest.wind.description"), imageName: "img10"),
                ListItem(id: "forest-valley", title: localized("item.forest.valley.title"), description: localized("item.forest.valley.description"), imageName: "img11"),
                ListItem(id: "forest-horse", title: localized("item.forest.horse.title"), description: localized("item.forest.horse.description"), imageName: "img12"),
                ListItem(id: "waterfall-water", title: localized("item.waterfall.water.title"), description: localized("item.waterfall.water.description"), imageName: "img7"),
                ListItem(id: "waterfall-air", title: localized("item.waterfall.air.title"), description: localized("item.waterfall.air.description"), imageName: "img8"),
                ListItem(id: "waterfall-fresh", title: localized("item.waterfall.fresh.title"), description: localized("item.waterfall.fresh.description"), imageName: "img9")
             ])
    ]
}
