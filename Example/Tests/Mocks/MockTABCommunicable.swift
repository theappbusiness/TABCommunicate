//
//  MockTABCommunicable.swift
//  TABCommunicate
//
//  Created by Neil Horton on 04/04/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
@testable import TABCommunicate

final class MockTABCommunicable : TABCommunicable {
  
  var caprturedCreationDict: [String: AnyObject]?
  var errorToThrow: ErrorType?
  
  func dataRepresentation() throws -> NSData {
    if let error = errorToThrow {
      throw error
    }
    return DataHelper.toDataFromDict(["test": "test"])
  }
  
  static func create(data: NSData) -> MockTABCommunicable {
    let mock = MockTABCommunicable()
    mock.caprturedCreationDict = try! DataHelper.toDictFromData(data)
    return mock
  }
}
