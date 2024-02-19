//
//  ViewController.swift
//  MyGreetingApp
//
//  Created by Денис Гиндулин on 16.02.2024.
//

// импортировал нативный фреймворк UIKit, чтобы в этом файле использовать классы из объектной библиотеки UIKit - UIViewController, UILabel
import UIKit

// создал протокол, который будет публичным интерфейсом для класса GreetingViewController, то есть для архитектурного модуля View из архитектурного паттерна MVP (Model - View - Presenter). В MVP данные между архитектурными модулями передаются посредством протоколов. Этот протокол обязывает класс GreetingViewController реализовать метод setGreeting. Реализацию метода делаю ниже в расширении в этом файле (см. extension GreetingViewController). Суть реализации метода будет в том, чтобы в свойство text элемента интерфейса greetingLabel класса UILabel установить значение, которое будет передано в параметр greeting этого метода. Имя протокола сложил из трех компонентов: 1. имя сцены (Greeting); 2. имя архитектурного модуля (или класса, который будет подписываться под протокол) (View); 3. слово Protocol. Делегирующим классом для класса GreetingViewController, то есть классом, где будет подготовлено значение для параметра greeting метода setGreeting этого протокола, станет класс GreetingPresenter, представляющий собой архитектурный модуль Presenter. Классы GreetingViewController и GreetingPresenter будут ссылаться друг на друга, поэтому между ними будет образовываться цикл сильных ссылок, который надо будет разорвать, сделав одну из ссылок unowned (см. файл GreetingPresenter). На появление unowned-ссылки вызовет в Xcode предупреждение об ошибке (красного ворнинга): 'unowned' must not be applied to non-class-bound 'any GreetingViewProtocol'; consider adding a protocol conformance that has a class bound. Поэтому подписываю сам протокол GreetingViewProtocol под протокол AnyObject, чтобы он стал протоколом ссылочного типа (reference type) и пропала ошибка в классе GreetingPresenter при объявлении свойства view с указателем unowned.
protocol GreetingViewProtocol: AnyObject {
    // это метод протокола, поэтому здесь только имя метода и параметр с указанием типа в круглых скобках, а реализации метода нет (нет фигурных скобок). Реализация будет в классе, который подпишется под этот протокол.
    func setGreeting(_ greeting: String)
}

// это класс, представляющий собой архитектурный модуль View в архитектурном паттерне MVP (Model - View - Presenter). В MVP модуль View соединяет в себе View и Сontroller, поэтому имя класса (и соответствующего ему файла) сложил из двух компонентов: 1. имя сцены (Greeting); 2. слово ViewController. Класс GreetingViewController унаследовал от суперкласса UIViewController, который является классом из объектной библиотеки UIKit.
class GreetingViewController: UIViewController {
    // это связь между вью и контроллером. Здесь объявил свойство greetingLabel с типом UILabel (класс из объектной библиотеки UIKit). Неявно извлекаю опционал, поставив восклицательный знак, тем самым указываю, что свойство требует обязательной инициализации (подготовить, наполнив значением). Инициализацию - присвоение стартового значения - сделал в сториборде в файле Main (а именно: свойству text класса UILabel присвоил значение "Please tap to Screen")
    @IBOutlet var greetingLabel: UILabel!
    
    //объявляю в классе GreetingViewController свойство presenter с типом GreetingPresenterProtocol. Неявно извлекаю опционал, поставив восклицательный знак, тем самым указываю, что свойство надо обязательно инициализировать (подготовить, наполнив значением). Позже сделаю инициализацию в методе viewDidLoad. Использовал ключевое слово private, чтобы ограничить доступ к свойству person откуда-либо вне пределов класса GreetingViewController. Использовал ключевое слово var, так как свойство presenter имеет опциональный тип.
    private var presenter: GreetingPresenterProtocol!
    
    // переопределяю метод жизненного цикла вью контроллера viewDidLoad для того, чтобы инициализировать (подготовить, наполнив значениями) в нем свойство person в качестве экземпляра модели Person, а также инициализировать в нем свойство presenter
    override func viewDidLoad() {
        // поскольку нахожусь в переопределяемом методе, то сначала обращаюсь к суперклассу
        super.viewDidLoad()
        // в рамках инициализации свойства person присваиваю значения свойствам модели Person. В этой строке происходит нарушение паттерна MVP, так как модуль View ничего не должен знать про модуль Model и не должен с ним общаться напрямую. Исправить ошибку можно путем выделения слоя Router. Про это см. следующие уроки SwifBook.
        let person = Person(name: "Tim", surname: "Cook")
        // в рамках инициализации свойства presenter объявляю, что оно станет экземпляром класса GreetingPresenter (это требует задать значения, которые перечислены в обязательном инициализаторе этого класса в файле GreetingPresenter, точнее в протоколе GreetingPresenterProtocol) и присваиваю значения свойствам view и person (свойство view согласно протоколу GreetingPresenterProtocol имеет тип GreetingViewProtocol, поэтому записываю значение с помощью ключевое слова self; свойству person присваиваю в качестве значения экземпляр person модели Person, который указан в предыдущей строке.
        presenter = GreetingPresenter(view: self, person: person)
    }
    // переопределяю метод touchesBegan, который отвечает за реакцию на касание пользователем экрана в любой области, чтобы в связи с касанием изменить текст в лейбле greetingLabel
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // поскольку нахожусь в переопределяемом методе, то сначала обращаюсь к суперклассу
        super.touchesBegan(touches, with: event)
        // вызываю у свойства presenter метод showGreeting
        presenter.showGreeting()
    }
}

// это расширение класса GreetingViewController. В нем буду реализовывать метод setGreeting, потому что этого требует протокол GreetingViewProtocol, под который подписан данный класс. У метода есть параметр greeting.
extension GreetingViewController: GreetingViewProtocol {
    func setGreeting(_ greeting: String) {
        // передаю значение параметра greeting метода setGreeting в свойство text элемента интерфейса greetingLabel. В этом проявляется шаблон "Скромный объект", характерный для архитектурного паттерна MVP, суть которого в том, что архитектурный модуль View - пассивный (он не готовит данные для отображения - он помещает в элемент интерфейса лейбл то, что передаст ему Presenter) 
        greetingLabel.text = greeting
    }
}
