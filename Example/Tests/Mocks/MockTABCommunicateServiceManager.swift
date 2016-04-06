//
//  MockTABCommunicateServiceManager.swift
//  TABCommunicate
//
//  Created by Neil Horton on 04/04/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
@testable import TABCommunicate

class MockTABCommunicateServiceManager: TABCommunicateServiceManager {
  
  let configuration = TABCommunicateConfiguration(serviceName: "name", identity: .None)
  var capturedCompletion: ((TABCommunicateResult) -> Void)?
  
  init() {
    super.init(configuration: configuration, delegate: MockTABCommunicateServiceManagerDelegate())
  }
  
  override func sendCommunicableObject(object: TABCommunicable, completion: (TABCommunicateResult) -> Void) {
    capturedCompletion = completion
  }
}