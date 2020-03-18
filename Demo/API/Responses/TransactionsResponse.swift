//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import Foundation

public struct TransactionsResponse: PlaidResponse {
    let item: Item
    let transactions: [Transaction] 
}
