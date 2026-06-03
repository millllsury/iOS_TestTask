//
//  MainViewRouter.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import SwiftUI
import Combine

enum MainViewRoute {
    case statisticSheet
}

protocol MainViewRouterProtocol {
    func navigate(to route: MainViewRoute)
}

final class MainViewRouter: MainViewRouterProtocol, ObservableObject {
    @Published var isStatisticsPresented = false

    func navigate(to route: MainViewRoute) {
        switch route {
        case .statisticSheet:
            isStatisticsPresented = true
        }
    }
}
