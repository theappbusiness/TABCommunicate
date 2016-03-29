//
//  TABCommunicate.swift
//  NHCommunicate
//
//  Created by Neil Horton on 29/03/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

///Allows conformer to recieve objects from the multipeer session
public protocol TABCommunicateDelegate: class {
  /**
   Object recieved through multipeer connectivity
   **Most likely not on the main thread**
   
   - parameter object: TABCommunicatable object recieved
   
   */
  func communicatableObjectRecieved(object: TABCommunicatable)
  
  /**
   Peers have either left or joined the session informs current connection status
   
   - parameter connected: Boolean describing wether anyone is connected
   
   */
  func connectionDidUpdate(connected: Bool)
}

///Allows caller to connect to multipeer session and send objects
public class TABCommunicate<T: TABCommunicatable> {
  /**
   TAB communicate delegate will recieve the following updates
   - Connection status updated
   - Object recieved
   */
  public weak var delegate: TABCommunicateDelegate?
  private let communicateServiceManager: TABCommunicateServiceManager
  
  public init(serviceName: String) {
    communicateServiceManager = TABCommunicateServiceManager(serviceName: serviceName)
    communicateServiceManager.delegate = self
  }
  
  /**
   Send Object to all peers
   
   - parameter object: TABCommunicatable object to send
   
   */
  public func sendCommunicatableObject(object: TABCommunicatable) {
    communicateServiceManager.sendCommunicatableObject(object)
  }
}

extension TABCommunicate: TABCommunicateServiceManagerDelegate {
  func communicatableDataRecieved(data: NSData) {
    delegate?.communicatableObjectRecieved(T.create(data))
  }
  
  func newNumberOfPeers(number: Int) {
    delegate?.connectionDidUpdate(number > 0)
  }
}
