//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import Foundation

struct Link: Codable {
  let institution: Institution
  let status: String
  let account_id: String?
  let request_id: String
  let link_session_id: String
  let accounts: [Account]
}

