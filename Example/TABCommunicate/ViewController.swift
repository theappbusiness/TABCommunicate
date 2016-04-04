//
//  ViewController.swift
//  NHCommunicate
//
//  Created by Neil on 03/29/2016.
//  Copyright (c) 2016 Neil. All rights reserved.
//

import UIKit
import TABCommunicate

class ViewController: UIViewController {
  
  var communicate: TABCommunicator<Test>?
  let communicateConfiguration = TABCommunicateConfiguration(serviceName: "test", numberOfRetryAttempts: 3, retryDelay: 1, password: "password")
  @IBOutlet weak var resultLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    communicate = TABCommunicator<Test>(configuration: communicateConfiguration, delegate: self)
    view.backgroundColor = UIColor.redColor()
  }
  @IBAction func testTapped(sender: AnyObject) {
    do {
      try communicate?.sendCommunicatableObject(Test(string: textField.text ?? ""))
    } catch {
      print(error)
    }
    
    textField.resignFirstResponder()
    textField.text = ""
    resultLabel.text = ""
  }
}

extension ViewController: TABCommunicatorDelegate {
  func communicatableObjectRecieved(object: Test) {
    self.resultLabel.text = object.string
  }
  
  func connectionDidUpdate(connected: Bool) {
    self.view.backgroundColor = connected ? UIColor.greenColor() : UIColor.redColor()
  }
}
