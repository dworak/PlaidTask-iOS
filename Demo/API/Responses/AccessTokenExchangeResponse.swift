//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import Foundation

public struct AccessTokenExchangeResponse: PlaidResponse {
  let accessToken: String
  
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
  }
}

