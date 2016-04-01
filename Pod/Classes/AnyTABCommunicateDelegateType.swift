//
//  AnyTABCommunicateDelegateType.swift
//  Pods
//
//  Created by Neil Horton on 01/04/2016.
//
//

import Foundation

class AnyTABCommunicatorDelegateType<T: TABCommunicatable>: TABCommunicatorDelegate {
  
  private let _communicatableObjectRecieved: (T) -> Void
  private let _connectionDidUpdate: (Bool) -> Void
  
  init<U: TABCommunicatorDelegate where U.Object == T>(_ delegate: U) {
    _communicatableObjectRecieved = delegate.communicatableObjectRecieved
    _connectionDidUpdate = delegate.connectionDidUpdate
  }
  
  func communicatableObjectRecieved(object: T) {
    _communicatableObjectRecieved(object)
  }
  
  func connectionDidUpdate(connected: Bool) {
    _connectionDidUpdate(connected)
  }
}