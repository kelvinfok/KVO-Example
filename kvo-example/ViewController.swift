//
//  ViewController.swift
//  kvo-example
//
//  Created by Kelvin Fok on 2/7/19.
//  Copyright © 2019 Kelvin Fok. All rights reserved.
//

import UIKit

class Person: NSObject {
    @objc dynamic var name = String()
}

class Animal {
    
    var name: String? {
        didSet {
            nameObserver?(name)
        }
    }
    
    var nameObserver: ((_ name: String?) -> Void)?
}

class ViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @objc let taylor = Person()
    @objc dynamic var inputText: String?
    
    let animal = Animal()
    
    var nameObservation: NSKeyValueObservation?
    var inputTextObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObserver()
    }
    
    private func setupObserver() {
        
        nameObservation = observe(\ViewController.taylor.name, options: [.new, .old, .initial, .prior]) { (vc, change) in
            guard let updatedName = change.newValue else { return }
            self.nameLabel.text = updatedName
            print("old value: \(String(describing: change.oldValue)), new value: \(String(describing: change.newValue))")
        }
        
        inputTextObservation = observe(\ViewController.inputText, options: .new) { (vc, change) in
            guard let updatedInputText = change.newValue as? String else { return }
            vc.textLabel.text = updatedInputText
        }
        
        // Another simple method of observation
        
        animal.nameObserver = { [weak self] name in
            self?.nameLabel.text = name
        }
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        // taylor.name = "Peter"
        animal.name = "Kelvin"
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        // inputText = textField.text
        animal.name = textField.text
    }
    
}

