//
//  MockPages.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import Foundation

struct Page: Identifiable {
    let id: String
    let imageName: String
    let title: String
    let items: [ListItem]
}
