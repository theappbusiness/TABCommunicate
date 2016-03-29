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
  
  let communicate = TABCommunicate<Test>(serviceName: "TABCommunicate")
  
  @IBOutlet weak var resultLabel: UILabel!
  @IBOutlet weak var textField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    communicate.delegate = self
    view.backgroundColor = UIColor.redColor()
  }
  @IBAction func testTapped(sender: AnyObject) {
    communicate.sendCommunicatableObject(Test(string: textField.text ?? ""))
    textField.resignFirstResponder()
    textField.text = ""
    resultLabel.text = ""
  }
}

extension ViewController: TABCommunicateDelegate {
  func communicatableObjectRecieved(object: TABCommunicatable) {
    guard let test = object as? Test else {
      fatalError("It didnt work")
    }
    dispatch_async(dispatch_get_main_queue()) {
      self.resultLabel.text = test.string
    }
  }
  
  func connectionDidUpdate(connected: Bool) {
    dispatch_async(dispatch_get_main_queue()) {
      self.view.backgroundColor = connected ? UIColor.greenColor() : UIColor.redColor()
    }
  }
}
