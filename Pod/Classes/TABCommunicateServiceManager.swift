//
//  TABCommunicateServiceManager.swift
//  NHCommunicate
//
//  Created by Neil Horton on 29/03/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol TABCommunicateServiceManagerDelegate: class {
  func communicatableDataRecieved(data: NSData)
  func newNumberOfPeers(number: Int)
}

class TABCommunicateServiceManager: NSObject {
  
  private let myPeerId = MCPeerID(displayName: "NHCommunicate\(UIDevice.currentDevice().name)")
  private let serviceAdvertiser : MCNearbyServiceAdvertiser
  private let serviceBrowser : MCNearbyServiceBrowser
  
  private lazy var session : MCSession = {
    let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.Required)
    session.delegate = self
    return session
  }()
  
  weak var delegate: TABCommunicateServiceManagerDelegate?
  
  init(serviceName: String) {
    self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceName)
    self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceName)
    super.init()
    self.serviceAdvertiser.delegate = self
    self.serviceAdvertiser.startAdvertisingPeer()
    self.serviceBrowser.delegate = self
    self.serviceBrowser.startBrowsingForPeers()
  }
  
  func sendCommunicatableObject(object: TABCommunicatable) {
    do {
      let data = try object.dataRepresentation()
      try session.sendData(data, toPeers: session.connectedPeers, withMode: .Reliable)
    } catch let error{
      print(error)
    }
  }
  
  deinit {
    self.serviceAdvertiser.stopAdvertisingPeer()
    self.serviceBrowser.stopBrowsingForPeers()
  }
  
}

extension TABCommunicateServiceManager: MCNearbyServiceAdvertiserDelegate {
  
  func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
    print("didNotStartAdvertisingPeer: \(error)")
  }
  
  func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
    guard peerID.displayName.containsString("NHCommunicate") else { return }
    invitationHandler(true, self.session)
  }
}

extension TABCommunicateServiceManager: MCNearbyServiceBrowserDelegate {
  func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
    guard peerID.displayName.containsString("NHCommunicate") else { return }
    browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 10)
  }
  
  func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    delegate?.newNumberOfPeers(session.connectedPeers.count)
  }
}

extension TABCommunicateServiceManager: MCSessionDelegate {
  func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
    delegate?.newNumberOfPeers(session.connectedPeers.count)
  }
  
  func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void) {
    certificateHandler(true)
    delegate?.newNumberOfPeers(session.connectedPeers.count)
  }
  
  func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
    delegate?.communicatableDataRecieved(data)
  }
  
  func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
  
  func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {}
  
  func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
    print(session.connectedPeers.count)
    delegate?.newNumberOfPeers(session.connectedPeers.count)
  }
}