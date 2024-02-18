//
//  ViewController.swift
//  MyGreetingApp
//
//  Created by Денис Гиндулин on 16.02.2024.
//

import UIKit

// подписываю сам протокол GreetingViewProtocol под протокол AnyObject, чтобы он стал протоколом ссылочного типа и пропала ошибка в классе GreetingPresenter при объявлении свойства view с указателем unowned
protocol GreetingViewProtocol: AnyObject {
    func setGreeting(_ greeting: String)
}

class GreetingViewController: UIViewController {

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
