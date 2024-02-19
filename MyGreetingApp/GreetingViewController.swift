//
//  GreetingViewController.swift
//  MyGreetingApp
//
//  Created by Денис Гиндулин on 16.02.2024.
//

import UIKit

// этот файл(класс) - это одновременно и View, и Controller в архитектурном паттерне MVC (Model-View-Controller). В MVC распределение модулей хромает: View и Controller очень неразрывно связаны друг с другом и роли между ними не разделены (явно отделена только Model - она в другом файле), тестируемость затруднительна, но код получился самым коротким
class GreetingViewController: UIViewController {

    @IBOutlet var greetingLabel: UILabel!
    
    // объявляю свойство person с типом Person. Неявно извлекаю опционал, поставив восклицательный знак, тем самым указываю, что свойство надо обязательно инициализировать (подготовить, наполнив значением). Сделаю инициализацию в методе viewDidLoad.
    private var person: Person!
    
    // переопределяю метод жизненного цикла ViewController-а viewDidLoad для того, чтобы инициализировать в нем свойство person в качестве экземпляра модели Person
    override func viewDidLoad() {
        super.viewDidLoad()
        // в рамках инициализации свойства person присваиваю значения свойствам модели Person
        person = Person(name: "Tim", surname: "Cook")
    }
    
    // переопределяю метод touchesBegan, который отвечает за реакцию на касание пользоватедем экрана в любой области, чтобы в связи с касанием изменить текст в лейбле greetingLabel
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        // присваиваю тексту лейбла значение "Hello, Tim Cook!", которое будет появляться в ответ на касание пользователя по экрану
        greetingLabel.text = "Hello, \(person.name) \(person.surname)"
    }
}

