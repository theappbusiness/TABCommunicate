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
  
  var communicator: TABCommunicator<Test>?
  let communicateConfiguration = TABCommunicateConfiguration(serviceName: "test", numberOfRetryAttempts: 3, retryDelay: 1, password: "password")
  @IBOutlet weak var resultLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    communicator = TABCommunicator<Test>(configuration: communicateConfiguration, delegate: self)
    view.backgroundColor = UIColor.redColor()
  }
  @IBAction func testTapped(sender: AnyObject) {
    communicator?.sendCommunicableObject(Test(string: textField.text ?? "")) { [weak self] result in
      switch result {
      case .Success:
        self?.textField.resignFirstResponder()
        self?.textField.text = ""
        self?.resultLabel.text = ""
      case .Failure(let error):
        self?.showAlert("Could not send message", message: error.localizedDescription)
      }
    }
  }
  
  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: .None))
    presentViewController(alertController, animated: true, completion: .None)
  }
}

extension ViewController: TABCommunicatorDelegate {
  func CommunicableObjectRecieved(test: Test) {
    self.resultLabel.text = test.string
  }
  
  func connectionDidUpdate(connected: Bool) {
    self.view.backgroundColor = connected ? UIColor.greenColor() : UIColor.redColor()
  }
}
