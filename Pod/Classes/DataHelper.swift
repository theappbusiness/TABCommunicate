//
//  DataHelper.swift
//  BP Pitch Prototype
//
//  Created by Neil Horton on 31/03/2016.
//  Copyright © 2016 The App Business. All rights reserved.
//

import Foundation

struct DataHelper {
  static func toDataFromDict(dict: [String: AnyObject]) -> NSData {
    return NSKeyedArchiver.archivedDataWithRootObject(dict)
  }
  
  static func toDictFromData(data: NSData) throws -> [String: AnyObject] {
    guard let dict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String: AnyObject] else {
      throw NSError(domain: "", code: 597, userInfo: .None)
    }
    return dict
  }
}
