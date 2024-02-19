//
//  GreetingViewController.swift
//  MyGreetingApp
//
//  Created by Денис Гиндулин on 16.02.2024.
//

import UIKit

// этот файл(класс) - это одновременно и View, и Controller в архитектурном паттерне MVC (Model - View - Controller). В MVC распределение модулей хромает: View и Controller очень неразрывно связаны друг с другом и роли между ними не разделены (явно отделена только Model - она в другом файле: в файле Person), тестируемость затруднительна, но код получился самым коротким
class GreetingViewController: UIViewController {
    
    // это связь между вью и контроллером. Здесь объявил свойство greetingLabel с типом UILabel (класс из объектной библиотеки UIKit). Неявно извлекаю опционал, поставив восклицательный знак, тем самым указываю, что свойство требует обязательной инициализации (подготовить, наполнив значением). Инициализация - присвоение стартового значения сделал в сториборде в файле Main (а именно: свойству text класса UILabel присвоил значение "Please tap to Screen")
    @IBOutlet var greetingLabel: UILabel!
    
    // объявляю свойство person с типом Person (то есть создал экземпляр модели во вью контроллере, тем самым создал связь между архитектурными модулями). Неявно извлекаю опционал, поставив восклицательный знак, тем самым указываю, что свойство надо обязательно инициализировать (подготовить, наполнив значением). Позже сделаю инициализацию в методе viewDidLoad. Использовал ключевое слово private, чтобы ограничить доступ к свойству person откуда-либо вне пределов класса GreetingViewController. Использовал ключевое слово var, так как свойство person имеет опциональный тип.
    private var person: Person!
    
    // переопределяю метод жизненного цикла вью контроллера viewDidLoad для того, чтобы инициализировать в нем свойство person в качестве экземпляра модели Person
    override func viewDidLoad() {
        // поскольку нахожусь в переопределяемом методе, то сначала обращаюсь к суперклассу
        super.viewDidLoad()
        // в рамках инициализации свойства person присваиваю значения свойствам модели Person
        person = Person(name: "Tim", surname: "Cook")
    }
    
    // переопределяю метод touchesBegan, который отвечает за реакцию на касание пользователем экрана в любой области, чтобы в связи с касанием изменить текст в лейбле greetingLabel
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // поскольку нахожусь в переопределяемом методе, то сначала обращаюсь к суперклассу
        super.touchesBegan(touches, with: event)
        // присваиваю тексту лейбла значение "Hello, Tim Cook!", которое будет появляться в ответ на касание пользователя по экрану. Для этого использую интерполяцию (символы \()), добавляя в строку значения свойств name и surname экземпляра person модели Person
        greetingLabel.text = "Hello, \(person.name) \(person.surname)"
    }
}
