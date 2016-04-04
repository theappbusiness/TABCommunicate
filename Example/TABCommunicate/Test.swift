//
//  Test.swift
//  NHCommunicate
//
//  Created by Neil Horton on 29/03/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import TABCommunicate

struct Test: TABCommunicable {

  let string: String

  func dataRepresentation() throws -> NSData {
    let dict = ["string": string]
    let data = NSKeyedArchiver.archivedDataWithRootObject(dict)
    return data
  }

  static func create(data: NSData) -> Test {
    guard let dict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String: String],
              testString = dict["string"]
    else {
      fatalError("Bad Data recieved")
    }

    return Test(string: testString)
  }
}
