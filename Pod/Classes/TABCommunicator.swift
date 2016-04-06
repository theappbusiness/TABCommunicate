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
  associatedtype Object: TABCommunicable
  /**
   Object recieved through multipeer connectivity
   **Most likely not on the main thread**
   
   - parameter object: TABCommunicable object recieved
   
   */
  func communicableObjectRecieved(object: Object)
  
  /**
   Peers have either left or joined the session informs current connection status
   
   - parameter connected: Boolean describing wether anyone is connected
   
   */
  func connectionDidUpdate(connected: Bool)
  
  /**
  Function used to validate a certifacte recieved from a peer trying to
  connect.
   
  - parameter certificate: A certificate chain, presented as an array of SecCertificateRef certificate objects. The first certificate in this chain is the peer’s certificate, which is derived from the identity that the peer provided when it called the initWithPeer:securityIdentity:encryptionPreference: method. The other certificates are the (optional) additional chain certificates provided in that same array.
    If the nearby peer did not provide a security identity, then this parameter’s value is nil.
   
   - returns: Boolean indicating weather or not the app trusts this certificate and wants to connect.
  */
  func validateCertificate(certificate: [SecCertificateRef]?) -> Bool
}

/** 
 Allows caller to connect to multipeer session and send objects of the
 type T, where T conforms to TABCommunicable.
*/
public class TABCommunicator<T: TABCommunicable> {
  private let delegate: AnyTABCommunicatorDelegateType<T>
  var communicateServiceManager: TABCommunicateServiceManager?
  private let config: TABCommunicateConfiguration

  /**
   Initialise with a Configuration and a delegate. The delegate Object type
   (input value to the CommunicableObjectRecieved function) **Must** equal
   the type being used to specialise the communicator instance other wise a
   compiler error will be thrown.
   
   - parameter configuration: TABCommunicateConfiguration containing details 
   on how the communication should be configured.
   
   - parameter delegate: Delegate object to recieve the following updates
   for connection status updated and object recieved
   */
  public init<U: TABCommunicatorDelegate where U.Object == T>(configuration: TABCommunicateConfiguration, delegate: U) {
    self.delegate = AnyTABCommunicatorDelegateType(delegate)
    self.config = configuration
    self.communicateServiceManager = TABCommunicateServiceManager(configuration: configuration, delegate: self)
  }
  /**
   Send Object to all peers
   
   - parameter object: TABCommunicable object to send
   
   */
  public func sendCommunicableObject(object: T, completion: (TABCommunicateResult) -> Void) {
    communicateServiceManager?.sendCommunicableObject(object, completion: completion)
  }
  
  /**
   Kill old connection and create a new instance with the same parameters
   */
  public func resetConnection() {
    communicateServiceManager = .None
    communicateServiceManager = TABCommunicateServiceManager(configuration: config, delegate: self)
  }
}

extension TABCommunicator: TABCommunicateServiceManagerDelegate {
  func communicableDataRecieved(data: NSData) {
    dispatch_async(dispatch_get_main_queue()) {
      let object = T.create(data)
      self.delegate.communicableObjectRecieved(object)
    }
  }
  
  func newNumberOfPeers(number: Int) {
    dispatch_async(dispatch_get_main_queue()) {
      self.delegate.connectionDidUpdate(number > 0)
    }
  }
  
  func validateCertificate(certificate: [AnyObject]?) -> Bool {
    guard let certificateArray = certificate else {
      return delegate.validateCertificate(.None)
    }
    guard let certificateChain = certificateArray as? [SecCertificateRef] else {
      return false
    }
    return delegate.validateCertificate(certificateChain)
  }
}
