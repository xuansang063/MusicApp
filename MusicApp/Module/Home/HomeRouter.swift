//
//  HomeRouter.swift
//  MusicApp
//
//  Created admin on 22/03/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class HomeRouter: HomeWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = HomeViewController(nibName: nil, bundle: nil)
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
