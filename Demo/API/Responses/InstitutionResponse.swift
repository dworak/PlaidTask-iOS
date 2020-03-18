//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import Foundation

struct InstitutionResponse: PaginatingPlaidResponse {
    let institutions: [Institution]
    let total: Int
}
