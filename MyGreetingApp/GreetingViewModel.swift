//
//  GreetingViewModel.swift
//  MyGreetingApp
//
//  Created by Денис Гиндулин on 18.02.2024.
//

// протокол (публичный интерфейс взаимодействия) для модуля View-Model архитектурного паттерна MVVM (Model - View - View-Model)
protocol GreetingViewModelProtocol {
    var greeting: String? { get }
    var greetingDidChange: ((GreetingViewModelProtocol) -> Void)? { get set }
    init(person: Person)
    func showGreeting()
}

// модуль View-Model архитектурного паттерна MVVM (Model - View - View-Model)
class GreetingViewModel: GreetingViewModelProtocol {
    var greeting: String? {
        didSet {
            greetingDidChange?(self)
        }
    }
    var greetingDidChange: ((GreetingViewModelProtocol) -> Void)?
    
    private let person: Person
    
    required init(person: Person) {
        self.person = person
    }
    
    func showGreeting() {
        greeting = "Hello, \(person.name) \(person.surname)!"
    }
    
    
    
}
