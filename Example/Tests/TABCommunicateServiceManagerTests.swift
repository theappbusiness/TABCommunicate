//
//  TABCommunicateServiceManagerTests.swift
//  TABCommunicate
//
//  Created by Neil Horton on 04/04/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import MultipeerConnectivity
import TABCommunicate_Example
@testable import TABCommunicate

class TABCommunicateServiceManagerTests: XCTestCase {
  
  var sut: TABCommunicateServiceManager!
  var mockDelegate: MockTABCommunicateServiceManagerDelegate!
  var mockSession: MockMultipeerSession!
  let peer = MCPeerID(displayName: "test")
  
  let testConfiguration = TABCommunicateConfiguration(serviceName: "test", numberOfRetryAttempts: 3, retryDelay: 0.1, identity: .None)

  override func setUp() {
    super.setUp()
    mockDelegate = MockTABCommunicateServiceManagerDelegate()
    mockSession = MockMultipeerSession()
    sut = TABCommunicateServiceManager(configuration: testConfiguration, delegate: mockDelegate)
    sut.session = mockSession
  }
  
  override func tearDown() {
    sut = nil
    mockDelegate = nil
    super.tearDown()
  }
  
  func test_onInitialisationPeerIdContainingServiceNameIsSet() {
    XCTAssert(sut.myPeerID.displayName.containsString(testConfiguration.serviceName))
  }
  
  func test_sendCommunicableObject_sendsCorrectData() {
    sut.sendCommunicableObject(MockTABCommunicable()) { result in }
    let testInstance = MockTABCommunicable.create(mockSession.capturedData!)
    XCTAssert(testInstance.caprturedCreationDict!["test"] as! String == "test")
  }
  
  func test_sendCommunicableObject_whenErrorNotThrownReturnsSuccess() {
    let expectation = expectationWithDescription("Result block called")
    sut.sendCommunicableObject(MockTABCommunicable()) { result in
      expectation.fulfill()
      if case .Success = result   {
        return
      }
      XCTFail()
    }
    waitForExpectationsWithTimeout(2.0) { error in
      if error != nil { XCTFail() }
    }
  
  }
    
  func test_sendCommunicableObject_whenErrorThrownReturnsFailure() {
    let expectation = expectationWithDescription("Result block called")
    mockSession.errorToThrow = NSError(domain: "", code: 403, userInfo: .None)
    sut.sendCommunicableObject(MockTABCommunicable()) { result in
      expectation.fulfill()
      if case .Failure = result   {
        return
      }
      XCTFail()
    }
    waitForExpectationsWithTimeout(2.0) { error in
      if error != nil { XCTFail() }
    }
  }
  
  func test_sessionDidRecieveCertificateWhenDelegateIsNilCallsCompletionHandlerWithFalse() {
    sut.delegate = .None
    let expectation = expectationWithDescription("Result block called")
    sut.session(mockSession, didReceiveCertificate: .None, fromPeer: peer) {response in
      expectation.fulfill()
      XCTAssert(!response)
    }
    waitForExpectationsWithTimeout(2.0) { error in
      if error != nil { XCTFail() }
    }
  }
  
  func test_sessionDidRecieveCertificateWhenDelegateReturnsFalseCallsCompletionHandlerWithFalse() {
    mockDelegate.mockValidateCertificateResponse = false
    let expectation = expectationWithDescription("Result block called")
    sut.session(mockSession, didReceiveCertificate: .None, fromPeer: peer) {response in
      expectation.fulfill()
      XCTAssert(!response)
    }
    waitForExpectationsWithTimeout(2.0) { error in
      if error != nil { XCTFail() }
    }
  }
  
  func test_sessionDidRecieveCertificateWhenDelegateReturnsTrueCallsCompletionHandlerWithFalse() {
    mockDelegate.mockValidateCertificateResponse = true
    let expectation = expectationWithDescription("Result block called")
    sut.session(mockSession, didReceiveCertificate: .None, fromPeer: peer) {response in
      expectation.fulfill()
      XCTAssert(response)
    }
    waitForExpectationsWithTimeout(2.0) { error in
      if error != nil { XCTFail() }
    }
  }
    
  func test_sendCommunicableObject_whenErrorThrownRetriesCorrectNumberOfTimes() {
    let expectation = expectationWithDescription("Result block called")
    mockSession.errorToThrow = NSError(domain: "", code: 403, userInfo: .None)
    sut.sendCommunicableObject(MockTABCommunicable()) { result in
      expectation.fulfill()
      if case .Failure = result   {
        XCTAssert(self.mockSession.callCount == 4, "\(self.mockSession.callCount)")
        return
      }
      XCTFail()
    }
    waitForExpectationsWithTimeout(2.0) { error in
      if error != nil { XCTFail() }
    }
  }
  
  func test_browserLostPeer_informsDelegate() {
    let browser = MCNearbyServiceBrowser(peer: peer, serviceType: "test")
    sut.browser(browser, lostPeer: peer)
    XCTAssert(mockDelegate.capturedNumberOfPeers! == 0)
  }
  
  func test_sessionDidRecieveData_callsDelegate() {
    sut.session(mockSession, didReceiveData: NSData(), fromPeer: peer)
    XCTAssertNotNil(mockDelegate.capturedData)
  }
  
  func test_sessionDidChangeState_informsDelegate() {
    sut.session(mockSession, peer: peer, didChangeState: .Connected)
    XCTAssertNotNil(mockDelegate.capturedNumberOfPeers)
  }
}
