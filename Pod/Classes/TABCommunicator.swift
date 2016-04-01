//
//  TABCommunicate.swift
//  NHCommunicate
//
//  Created by Neil Horton on 29/03/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

///Allows conformer to recieve objects from the multipeer session
public protocol TABCommunicatorDelegate: class {
  associatedtype Object: TABCommunicatable
  /**
   Object recieved through multipeer connectivity
   **Most likely not on the main thread**
   
   - parameter object: TABCommunicatable object recieved
   
   */
  func communicatableObjectRecieved(object: Object)
  
  /**
   Peers have either left or joined the session informs current connection status
   
   - parameter connected: Boolean describing wether anyone is connected
   
   */
  func connectionDidUpdate(connected: Bool)
}

///Allows caller to connect to multipeer session and send objects
public class TABCommunicator<T: TABCommunicatable> {
  private weak var delegate: AnyTABCommunicatorDelegateType<T>?
  private let communicateServiceManager: TABCommunicateServiceManager
  private var objectRecievedFunction: ((T) -> Void)?

  /**
   
   - parameter serviceName: Unique Identifier to broadcast and recieve on
   think of it as the channel for this communication. **Must NOT be greater
   than 15 characters.**
   
   - parameter delegate: Delegate object to recieve the following updates
   for connection status updated and object recieved
   */
  public init<U: TABCommunicatorDelegate where U.Object == T>(serviceName: String, delegate: U) {
    self.delegate = AnyTABCommunicatorDelegateType(delegate)
    communicateServiceManager = TABCommunicateServiceManager(serviceName: serviceName)
    communicateServiceManager.delegate = self
  }
  
  /**
   
   - parameter serviceName: Unique Identifier to broadcast and recieve on
   think of it as the channel for this communication. **Must NOT be greater
   than 15 characters.**
   
   - parameter objectRecieved: Block to be called when object is recieved, captured strongly.
   
   */
  public init(serviceName: String, objectRecieved: (T) -> Void) {
    objectRecievedFunction = objectRecieved
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

extension TABCommunicator: TABCommunicateServiceManagerDelegate {
  func communicatableDataRecieved(data: NSData) {
    let object = T.create(data)
    delegate?.communicatableObjectRecieved(object)
    objectRecievedFunction?(object)
  }
  
  func newNumberOfPeers(number: Int) {
    delegate?.connectionDidUpdate(number > 0)
  }
}
