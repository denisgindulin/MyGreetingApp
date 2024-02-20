//
//  GreetingViewController.swift
//  MyGreetingApp
//
//  Created by Денис Гиндулин on 16.02.2024.
//

// импортировал нативный фреймворк UIKit, чтобы в этом файле использовать классы из объектной библиотеки UIKit - UIViewController, UILabel
import UIKit

// это архитектурный модуль View архитектурного паттерна MVVM (Model - View - View-Model), представляющий собой класс GreetingViewController, унаследованный от суперкласса UIViewController, который является классом из объектной библиотеки UIKit. В MVVM для класса GreetingViewController не требуется подписываться под протокол и не требуется создание такого протокола, потому что в отличие от MVP взаимодействие с архитектурным модулем View-Model (с классом GreetingViewModel) будет происходить с помощью байндинга (Data binding). В MVVM модуль View соединяет в себе View и Сontroller, поэтому имя класса (и соответствующего ему файла) сложил из двух компонентов: 1. имя сцены (Greeting); 2. слово ViewController.
class GreetingViewController: UIViewController {
    
    // это связь между вью и контроллером. Здесь объявил свойство greetingLabel с типом UILabel (класс из объектной библиотеки UIKit). Неявно извлекаю опционал, поставив восклицательный знак, тем самым указываю, что свойство требует обязательной инициализации (подготовить, наполнив значением). Инициализацию - присвоение стартового значения - сделал в сториборде в файле Main (а именно: свойству text класса UILabel присвоил значение "Please tap to Screen")
    @IBOutlet var greetingLabel: UILabel!
    
    // объявляю свойство viewModel, которое является ссылкой на модель представления, потому что у свойства устанавливаю тип - тип протокола GreetingViewModelProtocol (то есть свойство получает тип публичного интерфейса) и внутри свойства (в фигурных скобках) создаю байндинг (Data binding). То есть здесь устанавливается двухстороння связь между архитектурными модулями View и View-Model. Внутри свойства есть didSet (обзёрвер), который позволяет следить за изменением состояния свойства viewModel. Как только состояние меняется происходит вызов greetingDidChange с раскрытием его блока замыкания (колбэка). Этот коллбэк возвращает экземпляр viewModel модели представления View-Model. Когда свойство greeting в модели представления View-Model будет обновлено (об этом см. комментарий к методу showGreeting в классе GreetingViewModel), произойдет вызов коллбэка greetingDidChange и туда поместится экземпляр класса GreetingViewModel целиком, включая новое значение свойства greeting. В связи с этим после ключевого слова in пишу, что обращаюсь к свойству greeting свойства viewModel и это новое значение свойства greeting присваиваю в качестве значения свойству text элемента интерфейса greetingLabel. Но, внимание, здесь только объявление свойства viewModel и подготовка байндинга внутри него, - полноценная инициализация будет ниже в методе viewDidLoad, а также в методе touchesBegan будет обращение методу showGreeting свойства viewModel
    private var viewModel: GreetingViewModelProtocol! {
        didSet {
            viewModel.greetingDidChange = { [unowned self] viewModel in
                greetingLabel.text = viewModel.greeting
            }
        }
    }
    
    // переопределяю метод жизненного цикла вью контроллера viewDidLoad для того, чтобы инициализировать (подготовить, наполнив значениями) в нем свойство person в качестве экземпляра модели Person, а также инициализировать в нем свойство viewModel
    override func viewDidLoad() {
        // поскольку нахожусь в переопределяемом методе, то сначала обращаюсь к суперклассу
        super.viewDidLoad()
        // в рамках инициализации свойства person присваиваю значения свойствам модели Person. В этой строке происходит нарушение паттерна MVVM, так как модуль View ничего не должен знать про модуль Model и не должен с ним общаться напрямую. Исправить ошибку можно путем выделения слоя Router. Про это см. следующие уроки SwifBook.
        let person = Person(name: "Tim", surname: "Cook")
        // в рамках инициализации свойства viewModel объявляю, что оно станет экземпляром класса GreetingViewModel (это требует задать значение параметру, который перечислены в обязательном инициализаторе этого класса в файле GreetingViewModel, точнее в протоколе GreetingViewModelProtocol) и присваиваю значение параметру person (так свойству person присваиваю в качестве значения экземпляр person модели Person, который указан в предыдущей строке).
        viewModel = GreetingViewModel(person: person)
    }
    
    // переопределяю метод touchesBegan, который отвечает за реакцию на касание пользователем экрана в любой области, чтобы в связи с касанием изменить текст в лейбле greetingLabel
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // поскольку нахожусь в переопределяемом методе, то сначала обращаюсь к суперклассу
        super.touchesBegan(touches, with: event)
        // вызываю у свойства viewModel метод showGreeting, который реализован в классе GreetingViewModel
        viewModel.showGreeting()
    }
}
