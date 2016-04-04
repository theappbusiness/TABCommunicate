//
//  DataHelperTests.swift
//  TABCommunicate
//
//  Created by Neil Horton on 04/04/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import TABCommunicate

class DataHelperTests: XCTestCase {
  
  let dict = ["one": "one", "two": 2]
  
  func test_successEncodingAndDecoding() {
    let data = DataHelper.toDataFromDict(dict)
    let decodedDict = try! DataHelper.toDictFromData(data)
    XCTAssert(decodedDict["one"] as! String == dict["one"])
    XCTAssert(decodedDict["two"] as! Int == dict["two"])
  }
  
  func test_toDictFromData_whenUnableToDecodeObject_throwsError() {
    do {
      _ = try DataHelper.toDictFromData(NSData())
    } catch TABCommunicateError.CouldNotDecodeObject {
      return
    } catch {
      XCTFail()
    }
  }
}
