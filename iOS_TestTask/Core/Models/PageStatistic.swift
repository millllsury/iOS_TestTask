//
//  MockPages.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import Foundation

struct CharacterStatistic: Equatable {
    let character: String
    let count: Int
}

struct PageStatistic {
    let id: String
    let pageTitle: String
    let itemCount: Int
    let topCharacters: [CharacterStatistic]
}
