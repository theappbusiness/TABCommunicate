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

/** 
 Allows caller to connect to multipeer session and send objects of the
 type T, where T conforms to TABCommunicatable.
*/
public class TABCommunicator<T: TABCommunicatable> {
  private var delegate: AnyTABCommunicatorDelegateType<T>?
  private let communicateServiceManager: TABCommunicateServiceManager
  private var objectRecievedFunction: ((T) -> Void)?

  /**
   Initialise with a Configuration and a delegate. The delegate Object type
   (input value to the communicatableObjectRecieved function) **Must** equal
   the type being used to specialise the communicator instance other wise a
   compiler error will be thrown.
   
   - parameter configuration: TABCommunicateConfiguration containing details 
   on how the communication should be configured.
   
   - parameter delegate: Delegate object to recieve the following updates
   for connection status updated and object recieved
   */
  public init<U: TABCommunicatorDelegate where U.Object == T>(configuration: TABCommunicateConfiguration, delegate: U) {
    self.delegate = AnyTABCommunicatorDelegateType(delegate)
    communicateServiceManager = TABCommunicateServiceManager(configuration: configuration)
    communicateServiceManager.delegate = self
  }
  
  /**
   
   - parameter configuration: TABCommunicateConfiguration containing details on how the
   communication should be configured.
   
   - parameter objectRecieved: Block to be called when object is recieved, **captured strongly**.
   
   */
  public init(configuration: TABCommunicateConfiguration, objectRecieved: (T) -> Void) {
    objectRecievedFunction = objectRecieved
    communicateServiceManager = TABCommunicateServiceManager(configuration: configuration)
    communicateServiceManager.delegate = self
  }
  
  /**
   Send Object to all peers
   
   - parameter object: TABCommunicatable object to send
   
   */
  public func sendCommunicatableObject(object: T, completion: (TABCommunicateResult) -> Void) {
    communicateServiceManager.sendCommunicatableObject(object, completion: completion)
  }
}

extension TABCommunicator: TABCommunicateServiceManagerDelegate {
  func communicatableDataRecieved(data: NSData) {
    dispatch_async(dispatch_get_main_queue()) {
      let object = T.create(data)
      self.delegate?.communicatableObjectRecieved(object)
      self.objectRecievedFunction?(object)
    }
  }
  
  func newNumberOfPeers(number: Int) {
    dispatch_async(dispatch_get_main_queue()) {
      self.delegate?.connectionDidUpdate(number > 0)
    }
  }
}
