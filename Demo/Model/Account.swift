//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import Foundation

public struct Account: Codable, Equatable {
  public let id: String
  public let balances: Balances?
  public let name: String
  public let mask: String?
  public let officialName: String?
  public let type: AccountType
  
  public var displayBalance: Double {
    return balances?.available ?? balances?.current ?? 0
  }
  
  public var item: Item {
    return SessionDataStorage.shared.item!
  }
  
  public var institutionDescription: String {
    let parts = [item.institutionName, type.rawValue].filter { $0 != nil && $0!.lowercased() != "other" } as! [String]
    if parts.count == 0 {
      return "OTHER"
    }
    return parts.joined(separator: " ").uppercased()
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case officialName = "official_name"
    case balances, name, mask, type
  }
  
  public func representsSameAccount(as otherAccount: Account) -> Bool {
    return id == otherAccount.id && item.institutionID == otherAccount.item.institutionID && name == otherAccount.name && mask == otherAccount.mask && officialName == otherAccount.officialName && type == otherAccount.type
  }
  
  public static func ==(lhs: Account, rhs: Account) -> Bool {
    return lhs.representsSameAccount(as: rhs) && lhs.balances == rhs.balances
  }
}

extension Account {
  public enum AccountType: String, Codable, Equatable {
    case brokerage, credit, depository, loan, mortgage, other, investment
  }
}

extension Account {
  public struct Balances: Codable, Equatable {
    public let current: Double?
    public let available: Double?
    public let limit: Double?
    
    public static func ==(lhs: Balances, rhs: Balances) -> Bool {
      return lhs.current == rhs.current && lhs.available == rhs.available && lhs.limit == rhs.limit
    }
  }
}

