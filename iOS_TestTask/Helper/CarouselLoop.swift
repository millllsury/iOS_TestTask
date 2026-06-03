//
//  CarouselLoop.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//


import Foundation

enum CarouselLoop {
    
    static let multiplier = 1000
    
    static func virtualItemCount(pageCount: Int) -> Int {
        guard pageCount > 0 else { return 0 }
        return pageCount * multiplier
    }
    
    static func realIndex( for virtualIndex: Int, pageCount: Int) -> Int {
        guard pageCount > 0 else { return 0 }
        return virtualIndex % pageCount
    }
    
    static func middleIndex(pageCount: Int) -> Int {
        guard pageCount > 0 else { return 0 }
        return virtualItemCount(pageCount: pageCount) / 2
    }
}
