//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import Foundation

public struct Item: Codable {
  public let id: String
  public let institutionID: String?
  public var institutionName: String?
  
  enum CodingKeys: String, CodingKey {
    case id = "item_id"
    case institutionID = "institution_id"
  }
}


