//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import Foundation
import CoreLocation

public struct Transaction: Codable {
  public let id: String
  public let name: String
  public let pending: Bool
  public let variety: Variety
  public let amount: Double
  public let serverDate: String
  public let categories: [String]?
  public let accountID: String
  public let location: Location?
  
  public var didIncreaseBalance: Bool {
    return amount < 0
  }
  
  /// The date the transaction occurred on.
  public var date: Date {
    return Transaction.dateFormatter.date(from: serverDate)!
  }
  
  enum CodingKeys: String, CodingKey {
    case id = "transaction_id"
    case variety = "transaction_type"
    case categories = "category"
    case accountID = "account_id"
    case serverDate = "date"
    case name, amount, pending, location
  }
  
  /// Date formatter for use later, decoding server dates
  static var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()
}

// MARK: - Equatable
extension Transaction: Equatable {
  public static func ==(lhs: Transaction, rhs: Transaction) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name && lhs.pending == rhs.pending && lhs.variety == rhs.variety && lhs.amount == rhs.amount && lhs.serverDate == rhs.serverDate && lhs.categories ?? [] == rhs.categories ?? [] && lhs.accountID == rhs.accountID && lhs.location == rhs.location
  }
}

// MARK: - Models
extension Transaction {
  /// Enum describing the type of transaction that took place.
  public enum Variety: String, Codable {
    case place, digital, special, unresolved
  }
  
  /// An object describing the location of a transaction
  public struct Location: Codable, Equatable {
    let address: String?, city: String?, state: String?, zipCode: String?
    let latitude: CLLocationDegrees?, longitude: CLLocationDegrees?
    
    enum CodingKeys: String, CodingKey {
      case address, city, state
      case zipCode = "zip"
      case latitude = "lat"
      case longitude = "lon"
    }
    
    public var location: CLLocation? {
      guard let latitude = latitude, let longitude = longitude else { return nil }
      return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    public static func ==(lhs: Location, rhs: Location) -> Bool {
      return lhs.address == rhs.address && lhs.city == rhs.city && lhs.state == rhs.state && lhs.zipCode == rhs.zipCode && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
  }
}

