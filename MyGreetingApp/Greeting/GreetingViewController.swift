//
//  GreetingViewController.swift
//  MyGreetingApp
//
//  Created by Денис Гиндулин on 16.02.2024.
//

import UIKit

protocol GreetingViewInputProtocol: AnyObject {
    func setGreeting(_ greeting: String)
}

protocol GreetingViewOutputProtocol {
    init(view: GreetingViewInputProtocol)
    func didTapShowGreetingButton()
}

class GreetingViewController: UIViewController {
    
    @IBOutlet var greetingLabel: UILabel!
    
    var presenter: GreetingViewOutputProtocol!
    
    private let configurator: GreetingConfiguratorInputProtocol = GreetingConfigurator()
    private var person: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(withView: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        presenter.didTapShowGreetingButton()
    }
}

// MARK: - GreetingViewInputProtocol
extension GreetingViewController: GreetingViewInputProtocol {
    func setGreeting(_ greeting: String) {
        greetingLabel.text = greeting
    }
}
