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
  
  let testConfiguration = TABCommunicateConfiguration(serviceName: "test", numberOfRetryAttempts: 3, retryDelay: 0.1, password: "testPassword")

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
  
  func test_advetiserDidRecieveInvitation_withValidContextCallsTrueInCompletion() {
    let validContext = testConfiguration.createServiceContext()
    let expectation = expectationWithDescription("Result block called")
    let advetiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: .None, serviceType: "test")
    sut.advertiser(advetiser, didReceiveInvitationFromPeer: peer, withContext: validContext) { acceptance, session
      in
      expectation.fulfill()
      XCTAssert(acceptance)
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
  
  func test_sessionDidRecieveCertificate_callsTrueInCompletion() {
    let expectation = expectationWithDescription("Result block called")
    sut.session(mockSession, didReceiveCertificate: .None, fromPeer: peer) { result in
      expectation.fulfill()
      XCTAssert(result)
    }
    waitForExpectationsWithTimeout(2.0) { error in
      if error != nil { XCTFail() }
      XCTAssertNotNil(self.mockDelegate.capturedNumberOfPeers)
    }
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
