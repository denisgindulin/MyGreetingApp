//
//  GreetingPresenter.swift
//  MyGreetingApp
//
//  Created by Денис Гиндулин on 17.02.2024.
//

// создал протокол, который будет публичным интерфейсом для класса GreetingPresenter, то есть для архитектурного модуля Presenter из архитектурного паттерна MVP (Model - View - Presenter). В MVP данные между архитектурными модулями передаются посредством протоколов. Этот протокол обязывает класс GreetingPresenter реализовать обязательный инициализатор (со свойствами view и person) и метод showGreeting. Реализацию метода делаю ниже в самом классе GreetingPresenter. Суть реализации метода будет в том, чтобы создать объект приветствия (фразу "Hello, ...!") и передать его в модуль View. Также у модуля Presenter будет связь с модулем Model. Имя протокола сложил из трех компонентов: 1. имя сцены (Greeting); 2. имя архитектурного модуля (или класса, который будет подписываться под протокол) (Presenter); 3. слово Protocol. Делегирующим классом для класса GreetingPresenter станет класс GreetingViewController, представляющий собой архитектурный модуль View. Классы GreetingViewController и GreetingPresenter будут ссылаться друг на друга, поэтому между ними будет образовываться цикл сильных ссылок, который надо будет разорвать, сделав одну из ссылок unowned (см. файл GreetingPresenter). На появление unowned-ссылки вызовет в Xcode предупреждение об ошибке (красного ворнинга): 'unowned' must not be applied to non-class-bound 'any GreetingViewProtocol'; consider adding a protocol conformance that has a class bound. Поэтому подписываю сам протокол GreetingViewProtocol под протокол AnyObject, чтобы он стал протоколом ссылочного типа (reference type) и пропала ошибка в классе GreetingPresenter при объявлении свойства view с указателем unowned.
protocol GreetingPresenterProtocol {
    //
    init(view: GreetingViewProtocol, person: Person)
    func showGreeting()
}

class GreetingPresenter: GreetingPresenterProtocol {
    // объявляю в классе GreetingPresenter свойство view с типом GreetingPresenterProtocol (тем самым создал связь между архитектурными модулями View и Presenter). Использовал ключевое слово private, чтобы ограничить доступ к свойству view откуда-либо вне пределов класса GreetingPresenter. Использовал ключевое слово unowned, чтобы разорвать цикл сильных ссылок, который мог бы образоваться из-за взаимных ссылок друг н друга классов GreetingPresenter и GreetingViewController. Чтобы указать, что ссылка не является сильной, использовал ключевое слово unowned, а не weak, так как свойство view не имеет опциональный тип. Из двух классов (GreetingPresenter и GreetingViewController) родительским классом будет GreetingViewController, дочерним - GreetingPresenter, так как GreetingViewController порождается первым. Из-за этого ключевое слово unowned использовал в классе GreetingPresenter (такое правило для разрыва цикла сильных ссылок).
    private unowned let view: GreetingViewProtocol
    // объявляю в классе GreetingPresenter свойство person с типом Person, то есть создал экземпляр модели в презентере. Использовал ключевое слово private, чтобы ограничить доступ к свойству view откуда-либо вне пределов класса GreetingPresenter. Свойства view и person необходимы для реализации обязательного инициализатора строкой ниже, которую требовал протокол GreetingPresenterProtocol.
    private let person: Person
    
    // это обязательный инициализатор. С помощью него также создается связь модуля Presenter с модулями View и Model. В результате свойство view класса GreetingPresenter получит в качестве значения view из класса GreetingViewController, а свойство person класса GreetingPresenter получит в качестве значения person из структуры Person. Это необходимо, чтобы позже в этом классе реализовать метод showGreeting.
    required init(view: GreetingViewProtocol, person: Person) {
        self.view = view
        self.person = person
    }
    
    // это реализация метода showGreeting. Суть: создать объект приветствия (фразу "Hello, ...!") и передать его в модуль View. Реализовать его надо, исходя из требований протокола GreetingPresenterProtocol. Вызывать этот метод буду в классе GreetingViewController в рамках переопределения метода touchesBegan, который срабатывает при касании пользователем экрана устройства. То есть модуль View не готовит приветственную фразу, этим занимается Presenter.
    func showGreeting() {
        // создаю объект приветствия. Данные для него модуль Presenter берет из модуля Model, обращаясь к свойствам name и surname экземпляра структуры Person.
        let greeting = "Hello, \(person.name) \(person.surname)!"
        // обращаюсь к свойству view этого класса. У view тип протокола GreetingViewProtocol, который размещен в файле GreetingViewController и содержит метод setGreeting. Поэтому, если точнее, обращаюсь к методу setGreeting свойства view класса GreetingPresenter. У метода setGreeting есть параметр greeting. Передаю в него в качестве значения объект greeting (фразу приветствия), который создал в предыдущей строке.
        view.setGreeting(greeting)
    }
}
