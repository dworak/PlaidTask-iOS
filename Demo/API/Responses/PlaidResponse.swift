//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import Foundation

public protocol PlaidResponse: Codable {}

extension PlaidResponse {
    static func decode(from data: Data) -> Self? {
        return try! JSONDecoder().decode(self, from: data)
    }
    
    func encode() -> Data? {
        return try! JSONEncoder().encode(self)
    }
}
