//
//  TABCommunicatable.swift
//  NHCommunicate
//
//  Created by Neil Horton on 29/03/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public protocol TABCommunicatable {
  static func create(data: NSData) -> Self
  func dataRepresentation() throws -> NSData
}
