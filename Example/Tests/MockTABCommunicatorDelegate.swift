//
//  MockTABCommunicatorDelegate.swift
//  TABCommunicate
//
//  Created by Neil Horton on 04/04/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import TABCommunicate

class MockTABCommunicatorDelegate: TABCommunicatorDelegate {
  var capturedCommunicable: MockTABCommunicable?
  var capturedConnected: Bool?
  var expectation: XCTestExpectation?
  
  
  func communicableObjectRecieved(object: MockTABCommunicable) {
    capturedCommunicable = object
    expectation?.fulfill()
  }
  
  func connectionDidUpdate(connected: Bool) {
    capturedConnected = connected
    expectation?.fulfill()
  }
}