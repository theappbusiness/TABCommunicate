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
  
  let communicate = TABCommunicator<Test>(serviceName: "TABCommunicate")
  
  @IBOutlet weak var resultLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    communicate.setDelegate(self)
    view.backgroundColor = UIColor.redColor()
  }
  @IBAction func testTapped(sender: AnyObject) {
    communicate.sendCommunicatableObject(Test(string: textField.text ?? ""))
    textField.resignFirstResponder()
    textField.text = ""
    resultLabel.text = ""
  }
}

extension ViewController: TABCommunicatorDelegate {
  func communicatableObjectRecieved(object: Test) {
    dispatch_async(dispatch_get_main_queue()) {
      self.resultLabel.text = object.string
    }
  }
  
  func connectionDidUpdate(connected: Bool) {
    dispatch_async(dispatch_get_main_queue()) {
      self.view.backgroundColor = connected ? UIColor.greenColor() : UIColor.redColor()
    }
  }
}
