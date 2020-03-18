//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import Foundation

public struct ErrorResponse: PlaidResponse {
  let errorType: String, code: String, message: String, displayMessage: String?
  
  enum CodingKeys: String, CodingKey {
    case errorType = "error_type"
    case code = "error_code"
    case message = "error_message"
    case displayMessage = "display_message"
  }
}

