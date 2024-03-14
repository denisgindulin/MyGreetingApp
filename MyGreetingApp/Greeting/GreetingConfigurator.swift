//
//  GreetingConfigurator.swift
//  MyGreetingApp
//
//  Created by Денис Гиндулин on 14.03.2024.
//

import Foundation

protocol GreetingConfiguratorInputProtocol {
    func configure(withView view: GreetingViewController)
}

class GreetingConfigurator: GreetingConfiguratorInputProtocol {
    func configure(withView view: GreetingViewController) {
        let presenter = GreetingPresenter(view: view)
        let interactor = GreetingInteractor(presenter: presenter)
        view.presenter = presenter
        presenter.interactor = interactor
        
    }
}
