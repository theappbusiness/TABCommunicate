//
//  TABCommunicateConfiguration.swift
//  Pods
//
//  Created by Neil Horton on 04/04/2016.
//
//

import Foundation

public struct TABCommunicateConfiguration {
  /**
   Unique Identifier to broadcast and recieve on
   think of it as the channel for this communication. **Must NOT be greater
   than 15 characters.**
   */
  let serviceName: String
  /**
   Number of times framework will attempt to send the object if transfer fails
   */
  let numberOfRetryAttempts: Int
  /**
   Time delay in seconds between retry attempts
   */
  let retryDelay: NSTimeInterval
  /**
   Array consisting of [ SecIdentityRef, [ zero or more additional certs ] ]
  */
  let identity: [AnyObject]?
  
  /**
   The serviceName parameter is a short text string used to describe the
   app's networking protocol.  It should be in the same format as a
   Bonjour service type: up to 15 characters long and valid characters
   include ASCII lowercase letters, numbers, and the hyphen.  A short
   name that distinguishes itself from unrelated services is recommended;
   for example, a text chat app made by ABC company could use the service
   type "abc-txtchat". For more detailed information about service type
   restrictions, see RFC 6335, Section 5.1.
   
   - parameter serviceName: Unique Identifier to broadcast and recieve on
   think of it as the channel for this communication. **Must NOT be greater
   than 15 characters.**
   
   - parameter numberOfRetryAttempts: Number of times framework will attempt to send the object if transfer fails. Default value of 0
   
   - parameter retryDelay: Time delay in seconds between retry attempts. Default value of 1
   
   - parameter identity: Array consisting of [ SecIdentityRef, [ zero or more additional certs ] ]
   
   */
  public init(serviceName: String, numberOfRetryAttempts: Int = 0, retryDelay: NSTimeInterval = 1, identity: [AnyObject]?) {
    self.serviceName = serviceName
    self.numberOfRetryAttempts = numberOfRetryAttempts
    self.retryDelay = retryDelay
    self.identity = identity
  }
}
