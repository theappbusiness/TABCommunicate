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
  func communicableDataRecieved(data: NSData)
  func newNumberOfPeers(number: Int)
  func validateCertificate(certificate: [AnyObject]?) -> Bool
}

class TABCommunicateServiceManager: NSObject {
  
  let myPeerID: MCPeerID
  private let serviceAdvertiser : MCNearbyServiceAdvertiser
  private let serviceBrowser : MCNearbyServiceBrowser
  private let configuration: TABCommunicateConfiguration
  private var retryCount: Int = 0
  
  var session : MCSession?
  
  weak var delegate: TABCommunicateServiceManagerDelegate?
  
  init(configuration: TABCommunicateConfiguration, delegate: TABCommunicateServiceManagerDelegate?) {
    self.delegate = delegate
    self.myPeerID = MCPeerID(displayName: "\(configuration.serviceName)\(UIDevice.currentDevice().name)")
    self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: configuration.serviceName)
    self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: configuration.serviceName)
    self.configuration = configuration
    super.init()
    self.serviceAdvertiser.delegate = self
    self.serviceAdvertiser.startAdvertisingPeer()
    self.serviceBrowser.delegate = self
    self.serviceBrowser.startBrowsingForPeers()
    self.createSession()
  }
  
  func createSession() {
    session = MCSession(peer: self.myPeerID, securityIdentity: self.configuration.identity , encryptionPreference: .Required)
    session?.delegate = self
  }
  
  func sendCommunicableObject(object: TABCommunicable, completion: (TABCommunicateResult) -> Void) {
    guard let session = session else { return }
    do {
      let data = try object.dataRepresentation()
      try session.sendData(data, toPeers: session.connectedPeers, withMode: .Reliable)
      retryCount = 0
      completion(.Success)
    } catch let error {
      if retryCount < configuration.numberOfRetryAttempts {
        retryCount += 1
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(configuration.retryDelay * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
          self.sendCommunicableObject(object, completion: completion)
        }
        return
      }
      completion(.Failure(error as NSError))
    }
  }
  
  deinit {
    self.serviceAdvertiser.stopAdvertisingPeer()
    self.serviceBrowser.stopBrowsingForPeers()
    self.session?.disconnect()
  }
  
}

extension TABCommunicateServiceManager: MCNearbyServiceAdvertiserDelegate {
  
  func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
    print("didNotStartAdvertisingPeer: \(error)")
  }
  
  func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
    guard let session = session else { return }
    invitationHandler(true, session)
  }
}

extension TABCommunicateServiceManager: MCNearbyServiceBrowserDelegate {
  func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
    guard peerID.displayName.containsString(configuration.serviceName), let session = session else { return }
    browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 10)
  }
  
  func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    guard let session = session else { return }
    delegate?.newNumberOfPeers(session.connectedPeers.count)
  }
}

extension TABCommunicateServiceManager: MCSessionDelegate {
  func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {}
  
  func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void) {
    let trustCertificate = delegate?.validateCertificate(certificate) ?? false
    certificateHandler(trustCertificate)
  }
  
  func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
    delegate?.communicableDataRecieved(data)
  }
  
  func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
  
  func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {}
  
  func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
    delegate?.newNumberOfPeers(session.connectedPeers.count)
  }
}

