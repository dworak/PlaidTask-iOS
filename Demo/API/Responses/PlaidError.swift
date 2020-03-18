//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import Foundation

public struct PlaidError: LocalizedError {
  var response: ErrorResponse?
  
  public var errorDescription: String? { return response?.message }
  public var failureReason: String? { return response?.message }
}

