//
//  MockMultipeerSession.swift
//  TABCommunicate
//
//  Created by Neil Horton on 04/04/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MockMultipeerSession : MCSession {
  
  var errorToThrow: ErrorType?
  var capturedData: NSData?
  var callCount = 0
  
  init() {
    super.init(peer: MCPeerID(displayName: "Test") , securityIdentity: nil, encryptionPreference: .Required)
  }
  
  override func sendData(data: NSData, toPeers peerIDs: [MCPeerID], withMode mode: MCSessionSendDataMode) throws {
    callCount += 1
    if let error = errorToThrow {
      throw error
    }
    capturedData = data
  }
}