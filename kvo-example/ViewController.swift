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

class ViewController: UIViewController {
    
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var textField2: UITextField!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @objc let taylor = Person()
    @objc dynamic var inputText: String?
    @objc dynamic var inputText2: String?

    var nameObservation: NSKeyValueObservation?
    var inputTextObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObserver()
    }
    
    private func setupObserver() {
        
        nameObservation = observe(\ViewController.taylor.name, options: [.new, .old]) { (vc, change) in
            guard let updatedName = change.newValue else { return }
            self.nameLabel.text = updatedName
            print("old value: \(String(describing: change.oldValue)), new value: \(String(describing: change.newValue))")
        }
        
        inputTextObservation = observe(\ViewController.inputText, options: .new) { (vc, change) in
            guard let updatedInputText = change.newValue as? String else { return }
            vc.textLabel.text = updatedInputText
        }
        
        addObserver(self, forKeyPath: #keyPath(inputText2), options: [.new], context: nil)
        
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        taylor.name = "Peter"
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        inputText = textField.text
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(inputText2) {
            if let updatedText = change?[.newKey] as? String {
                label2.text = updatedText
            }
        }
    }
    
    @IBAction func textField2DidChange(_ sender: UITextField) {
        self.inputText2 = sender.text
    }
    
}

