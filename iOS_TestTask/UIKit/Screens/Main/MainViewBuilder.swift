//
//  MainViewBuilder.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import UIKit

final class MainViewBuilder {
    
    func build() -> UIViewController {
        let router = MainViewRouter()
        
        let viewModel = MainViewModel(router: router,pages: MockPages.data)
        
        let viewController = MainViewController(viewModel: viewModel)
        
        router.view = viewController
        
        return viewController
    }
}
