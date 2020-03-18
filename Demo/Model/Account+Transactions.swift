//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import Foundation

extension Account {
  public var transactions: [Transaction] {
    return SessionDataStorage.shared.transactions(for: self)
  }
}

public class SessionDataStorage {
  public static let shared = SessionDataStorage()
  public static let accountsChangedNotification = Notification.Name(rawValue: "BankSessionDataStorageAccountsChangedNotificationName")
  public static let transactionsChangedNotification = Notification.Name(rawValue: "BankSessionDataStorageTransactionsChangedNotificationName")
  
  private init() {}
  
  public var item: Item?
  
  public var accounts: [Account]? {
    didSet {
      if oldValue ?? [] == accounts ?? [] { return }
      NotificationCenter.default.post(name: SessionDataStorage.accountsChangedNotification, object: nil)
    }
  }
  
  public var transactions: [Transaction]? {
    didSet {
      if oldValue ?? [] == transactions ?? [] { return }
      NotificationCenter.default.post(name: SessionDataStorage.transactionsChangedNotification, object: nil)
    }
  }
  
  public func transactions(for account: Account) -> [Transaction] {
    return transactions?.filter { $0.accountID == account.id } ?? []
  }
}

