//
//  MockTABCommunicateServiceManagerDelegate.swift
//  TABCommunicate
//
//  Created by Neil Horton on 04/04/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
@testable import TABCommunicate

class MockTABCommunicateServiceManagerDelegate: TABCommunicateServiceManagerDelegate {
  
  var capturedData: NSData?
  var capturedNumberOfPeers: Int?
  
  func communicableDataRecieved(data: NSData) {
    capturedData = data
  }
  
  func newNumberOfPeers(number: Int) {
    capturedNumberOfPeers = number
  }
}