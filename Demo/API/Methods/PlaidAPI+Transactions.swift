//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import Foundation

extension PlaidAPI {
  func getTransactions(for accountId: String, completionHandler: @escaping (Item?, [Transaction]?, Error?) -> Void) {
    makeAuthedRequest(
      to: "transactions/get",
      body: [
        "start_date": "2000-01-01",
        "end_date": "9999-12-31",
        "options": [
          "count": APIConstants.maxCount,
          "account_ids": [accountId]
        ]
      ],
      type: TransactionsResponse.self) { response, error in
        completionHandler(
          response?.item, response?.transactions, error
        )
    }
  }
}

