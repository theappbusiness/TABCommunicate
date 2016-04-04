//
//  TABCommunicateConfigurationTests.swift
//  TABCommunicate
//
//  Created by Neil Horton on 04/04/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import TABCommunicate

class TABCommunicateConfigurationTests: XCTestCase {
  
  var sut: TABCommunicateConfiguration!
  
  override func setUp() {
    super.setUp()
    sut = TABCommunicateConfiguration(serviceName: "test", password: "testPassword")
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  func test_createServiceContext_encodesDictionaryOfNameAndPassword() {
    let testData = sut.createServiceContext()
    let testDict = try! DataHelper.toDictFromData(testData)
    XCTAssert(testDict["serviceName"] as! String == "test")
    XCTAssert(testDict["password"] as! String == "testPassword")
  }
  
  func test_verifyContext_withValidData_returnsTrue() {
    let validDictionary = ["serviceName": "test", "password": "testPassword"]
    let validData = DataHelper.toDataFromDict(validDictionary)
    XCTAssert(sut.verifyContext(validData))
  }
  
  func test_verifyContext_whenServiceNameIsWrong_returnsFalse() {
    let validDictionary = ["serviceName": "wrong", "password": "testPassword"]
    let validData = DataHelper.toDataFromDict(validDictionary)
    XCTAssert(!sut.verifyContext(validData))
  }
  
  func test_verifyContext_whenPasswordIsWrong_returnsFalse() {
    let validDictionary = ["serviceName": "test", "password": "wrong"]
    let validData = DataHelper.toDataFromDict(validDictionary)
    XCTAssert(!sut.verifyContext(validData))
  }
  
  func test_verifyContext_withServiceNameMissing_returnsFalse() {
    let validDictionary = ["password": "testPassword"]
    let validData = DataHelper.toDataFromDict(validDictionary)
    XCTAssert(!sut.verifyContext(validData))
  }
  
  func test_verifyContext_withPasswordMissing_returnsFalse() {
    let validDictionary = ["serviceName": "test"]
    let validData = DataHelper.toDataFromDict(validDictionary)
    XCTAssert(!sut.verifyContext(validData))
  }
  
  func test_verifyContext_withInvalidData_returnsFalse() {
    let invalidData = NSData()
    XCTAssert(!sut.verifyContext(invalidData))
  }
  
}
