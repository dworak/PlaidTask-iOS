//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import Foundation

public protocol PaginatingPlaidResponse: PlaidResponse {
    var total: Int { get }
}
