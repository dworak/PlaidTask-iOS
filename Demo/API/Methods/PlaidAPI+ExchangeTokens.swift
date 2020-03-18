//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import Foundation

extension PlaidAPI {
  public func getAccessToken(from publicToken: String, completionHandler: @escaping (String?, Error?) -> Void) {
    makeRequest(
      to: "item/public_token/exchange",
      body: [
        "client_id": clientID,
        "secret": secret,
        "public_token": publicToken
      ],
      type: AccessTokenExchangeResponse.self) { (response, error) in
        completionHandler(response?.accessToken, error)
      }
    }
}

