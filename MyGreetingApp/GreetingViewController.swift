//
//  ViewController.swift
//  MyGreetingApp
//
//  Created by Денис Гиндулин on 16.02.2024.
//

import UIKit

// создал протокол, который будет публичным интерфейсом для класса GreetingViewController, то есть для архитектурного модуля View из архитектурного паттерна MVP (Model - View - Presenter). В MVP данные между архитектурными модулями передаются посредством протоколов. Этот протокол обязывает класс GreetingViewController реализовать метод setGreeting. Реализацию метода делаю ниже в расширении в этом файле (см. extension GreetingViewController). Суть реализации метода будет в том, чтобы в свойство text элемента интерфейса greetingLabel класса UILabel установить значение, которое будет передано в параметр greeting этого метода. Имя протокола сложил с трех компонентов: 1. имя сцены (Greeting); 2. имя архитектурного модуля (или класса, который будет подписываться под протокол) (View); 3. слово Protocol. Делегирующим классом для класса GreetingViewController, то есть классом, где будет подготовлено значение для параметра greeting метода setGreeting этого протокола, станет класс GreetingPresenter, представляющий собой архитектурный модуль Presenter. Классы GreetingViewController и GreetingPresenter будут ссылаться друг на друга, поэтому между ними будет образовываться цикл сильных ссылок, который надо будет разорвать, сделав одну из ссылок unowned (см. файл GreetingPresenter). На появление unowned-ссылки вызовет в Xcode предупреждение об ошибке (красного ворнинга): 'unowned' must not be applied to non-class-bound 'any GreetingViewProtocol'; consider adding a protocol conformance that has a class bound. Поэтому подписываю сам протокол GreetingViewProtocol под протокол AnyObject, чтобы он стал протоколом ссылочного типа (reference type) и пропала ошибка в классе GreetingPresenter при объявлении свойства view с указателем unowned.
protocol GreetingViewProtocol: AnyObject {
    // это метод протокола, поэтому здесь только имя метода и параметр с указанием типа в круглых скобках, а реализации метода нет (нет фигурных скобок). Реализация будет в классе, который подпишется под этот протокол.
    func setGreeting(_ greeting: String)
}

// это класс, представляющий собой архитектурный модуль View в архитектурном паттерне MVP (Model - View - Presenter). В MVP модуль View соединяет в себе View и Сontroller, поэтому имя класса (и соответствующего ему файла) сложил из двух компонентов: 1. имя сцены (Greeting); 2. слово ViewController. Класс GreetingViewController унаследовал от суперкласса UIViewController, который является классом из объектной библиотеки UIKit.
class GreetingViewController: UIViewController {
    // это связь между вью и контроллером. Здесь объявил свойство greetingLabel с типом UILabel (класс из объектной библиотеки UIKit). Неявно извлекаю опционал, поставив восклицательный знак, тем самым указываю, что свойство требует обязательной инициализации (подготовить, наполнив значением). Инициализацию - присвоение стартового значения - сделал в сториборде в файле Main (а именно: свойству text класса UILabel присвоил значение "Please tap to Screen")
    @IBOutlet var greetingLabel: UILabel!
    
    private var presenter: GreetingPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let person = Person(name: "Tim", surname: "Cook")
        presenter = GreetingPresenter(view: self, person: person)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        presenter.showGreeting()
    }
}

extension GreetingViewController: GreetingViewProtocol {
    func setGreeting(_ greeting: String) {
        greetingLabel.text = greeting
    }
}
