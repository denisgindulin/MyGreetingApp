//
//  GreetingPresenter.swift
//  MyGreetingApp
//
//  Created by Денис Гиндулин on 14.03.2024.
//

import Foundation

struct GreetingData {
    let name: String
    let surname: String
}

class GreetingPresenter: GreetingViewOutputProtocol {
    unowned private let view: GreetingViewInputProtocol
    var interactor: GreetingInteractorInputProtocol!
    
    required init(view: GreetingViewInputProtocol) {
        self.view = view
    }
    
    func didTapShowGreetingButton() {
        interactor.provideGreetingData()
    }
}

// MARK: - GreetingInteractorOutputProtocol
extension GreetingPresenter: GreetingInteractorOutputProtocol {
    func receiveGreetingData(greetingData: GreetingData) {
        let greeting = "Hello, \(greetingData.name) \(greetingData.surname)!"
        view.setGreeting(greeting)
    }
}
