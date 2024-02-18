//
//  ViewController.swift
//  MyGreetingApp
//
//  Created by Денис Гиндулин on 16.02.2024.
//

import UIKit

// это модуль View архитектурного паттерна MVVM (Model - View - View-Model)
class ViewController: UIViewController {

    @IBOutlet var greetingLabel: UILabel!
    
    private var viewModel: GreetingViewModelProtocol! {
        didSet {
            viewModel.greetingDidChange = { [unowned self] viewModel in
                greetingLabel.text = viewModel.greeting
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let person = Person(name: "Tim", surname: "Cook")
        viewModel = GreetingViewModel(person: person)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        viewModel.showGreeting()
    }


}

