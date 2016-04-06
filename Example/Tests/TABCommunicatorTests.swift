//
//  TABCommunicatorTests.swift
//  TABCommunicate
//
//  Created by Neil Horton on 04/04/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
@testable import TABCommunicate

class TABCommunicatorTests: XCTestCase {
  
  var sut: TABCommunicator<MockTABCommunicable>!
  var delegate: MockTABCommunicatorDelegate!
  let testConfiguration = TABCommunicateConfiguration(serviceName: "test", numberOfRetryAttempts: 3, retryDelay: 0.1, identity: .None)
  
  override func setUp() {
    super.setUp()
    delegate = MockTABCommunicatorDelegate()
    sut = TABCommunicator(configuration: testConfiguration, delegate: delegate)
  }
  
  override func tearDown() {
    sut = nil
    delegate = nil
    super.tearDown()
  }
  
  func test_communicableDataRecieved_createsObjectForDelegate() {
    let validData = DataHelper.toDataFromDict(["test": "test"])
    let expectation = expectationWithDescription("delegate informed")
    delegate.expectation = expectation
    
    sut.communicableDataRecieved(validData)
    
    waitForExpectationsWithTimeout(2.0) { error in
      XCTAssertNotNil(self.delegate.capturedCommunicable)
    }
  }
  
  func test_newNumberOfPeers_whenNoPeersConnected_returnsFalse() {
    let expectation = expectationWithDescription("delegate informed")
    delegate.expectation = expectation
    sut.newNumberOfPeers(0)
    
    waitForExpectationsWithTimeout(2.0) { error in
      XCTAssert(self.delegate.capturedConnected! == false)
    }
  }
  
  func test_newNumberOfPeers_whenSomePeersConnected_returnsTrue() {
    let expectation = expectationWithDescription("delegate informed")
    delegate.expectation = expectation
    
    sut.newNumberOfPeers(1)
    
    waitForExpectationsWithTimeout(2.0) { error in
      XCTAssert(self.delegate.capturedConnected! == true)
    }
  }
  
  func test_sendCommunicableObject_callsServiceAndSetsCompletion() {
    let mockService = MockTABCommunicateServiceManager()
    sut.communicateServiceManager = mockService
    sut.sendCommunicableObject(MockTABCommunicable()) {result in}
    XCTAssertNotNil(mockService.capturedCompletion)
  }
  
  func test_validateCertificateWhenCertificateArrayIsNilCallsDelegate() {
    delegate.mockValidateCertificateResponse = true
    XCTAssert(sut.validateCertificate(.None))
    XCTAssert(delegate.validateCertificateCallCount == 1)
  }
  
  func test_validateCertificateWhenCertificateArrayIsSecRefsCallsDelegate() {
    delegate.mockValidateCertificateResponse = true
    let certificateArray: [SecCertificateRef] = []
    XCTAssert(sut.validateCertificate(certificateArray))
    XCTAssert(delegate.validateCertificateCallCount == 1)
  }
}
