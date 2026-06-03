//
//  MainViewRouter.swift
//  iOS_TestTask
//
//  Created by Ekaterina Bastrikina on 21/05/2026.
//

import UIKit

enum MainViewRoute {
    case toStatisticSheet(PageStatistic?)
}

protocol MainViewRouterProtocol {
    func navigate(to route: MainViewRoute)
}

final class MainViewRouter: MainViewRouterProtocol {
    weak var view: UIViewController?
    
    func navigate(to route: MainViewRoute) {
        guard let view = self.view else { return }
        
        switch route {
        case .toStatisticSheet(let statistic):
            let vc = StatisticsBottomSheetViewController(statistic: statistic)
            
            vc.modalPresentationStyle = .pageSheet
            
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
            
            view.navigationController?.present(vc, animated: true)
        }
    }
    
}
