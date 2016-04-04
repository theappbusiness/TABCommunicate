//
//  AnyTABCommunicateDelegateType.swift
//  Pods
//
//  Created by Neil Horton on 01/04/2016.
//
//

import Foundation

class AnyTABCommunicatorDelegateType<T: TABCommunicable>: TABCommunicatorDelegate {
  
  private let _CommunicableObjectRecieved: (T) -> Void
  private let _connectionDidUpdate: (Bool) -> Void
  
  init<U: TABCommunicatorDelegate where U.Object == T>(_ delegate: U) {
    _CommunicableObjectRecieved = delegate.CommunicableObjectRecieved
    _connectionDidUpdate = delegate.connectionDidUpdate
  }
  
  func CommunicableObjectRecieved(object: T) {
    _CommunicableObjectRecieved(object)
  }
  
  func connectionDidUpdate(connected: Bool) {
    _connectionDidUpdate(connected)
  }
}