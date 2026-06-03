//
//  MainViewBuilder.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import SwiftUI

enum MainViewBuilder {
    static func build() -> some View {
        let router = MainViewRouter()
        let viewModel = MainViewModel(router: router,pages: MockPages.data)
        return MainView(viewModel: viewModel, router: router)
    }
}
