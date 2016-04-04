//
//  AnyTABCommunicateDelegateType.swift
//  Pods
//
//  Created by Neil Horton on 01/04/2016.
//
//

import Foundation

class AnyTABCommunicatorDelegateType<T: TABCommunicable>: TABCommunicatorDelegate {
  
  private let _communicableObjectRecieved: (T) -> Void
  private let _connectionDidUpdate: (Bool) -> Void
  
  init<U: TABCommunicatorDelegate where U.Object == T>(_ delegate: U) {
    _communicableObjectRecieved = delegate.communicableObjectRecieved
    _connectionDidUpdate = delegate.connectionDidUpdate
  }
  
  func communicableObjectRecieved(object: T) {
    _communicableObjectRecieved(object)
  }
  
  func connectionDidUpdate(connected: Bool) {
    _connectionDidUpdate(connected)
  }
}
