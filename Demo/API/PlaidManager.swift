//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import Foundation
import LinkKit

public class PlaidManager {
  public static let shared = PlaidManager()
  static let groupIdentifier = "group.demo.ios.Plaid"
  public static let statusChangedNotification = Notification.Name(rawValue: "PlaidManagerStatusChangedNotificationName")
  public var api: PlaidAPI!
  public var userDefaults: UserDefaults!
  
  private init() {
    api = info.createAPI()
    userDefaults = UserDefaults(suiteName: PlaidManager.groupIdentifier)
    if userDefaults == nil {
      print("Couldn't initialize user defaults with the app group identifier you specified. Falling back to app-only storage for now, but you should fix this if you want the today widget to work.")
      userDefaults = .standard
    }
  }
  
  public func setup() {
    if status.isReady {
      print("Not setting up Plaid Link, as it is already ready for use.")
      return
    }
    print("Setting up Plaid Link for use...")
    PLKPlaidLink.setup(with: info.configuration) { (success, error) in
      guard success else {
        print("Unable to setup Plaid Link:", error?.localizedDescription ?? "No error")
        self._status = .failed(error)
        return
      }
      print("Plaid Link setup was successful.")
      self._status = .ready
    }
  }
  
  // MARK: - Storage
  
  public var accessToken: String? {
    get { return userDefaults.string(forKey: "PlaidAccessToken") }
    set { userDefaults.set(newValue, forKey: "PlaidAccessToken") }
  }
  
  // MARK: - Status
  
  public var status: Status {
    return _status
  }

  private var _status = Status.notReady {
    didSet {
      NotificationCenter.default.post(name: PlaidManager.statusChangedNotification, object: nil)
    }
  }
}

// MARK: - Add PlaidManager Status enum
extension PlaidManager {
  /// An enum for showing the current status of the Plaid Manager.
  public enum Status {
    case ready, notReady, failed(Error?)
    
    /// Whether the status represents one that is ready or not.
    public var isReady: Bool {
      switch self {
      case .ready: return true
      default: return false
      }
    }
    
    /// The status's error, if applicable.
    public var error: Error? {
      switch self {
      case .failed(let error): return error
      default: return nil
      }
    }
  }
}

extension PlaidManager {
  public struct PlaidInfo {
    let publicKey: String, secret: String, clientID: String, environment: Environment
    
    public var baseURL: String {
      return "https://\(environment).plaid.com/"
    }
    
    public var configuration: PLKConfiguration {
      let config = PLKConfiguration(key: publicKey, env: environment.linkEnvironment, product: .transactions)
      config.clientName = "iOS"
      return config
    }
    
    fileprivate func createAPI() -> PlaidAPI {
      return PlaidAPI(rootServerURL: baseURL, clientID: clientID, secret: secret)
    }
    
    enum Environment: String {
      case development, sandbox, production
      
      var linkEnvironment: PLKEnvironment {
        switch self {
        case .development: return .development
        case .sandbox: return .sandbox
        case .production: return .production
        }
      }
    }
  }
  
  public var info: PlaidInfo {
    // Read Plaid.plist from main bundle
    guard let plistURL = Bundle.main.url(forResource: "Plaid", withExtension: "plist"), let plistData = try? Data(contentsOf: plistURL), let info = (try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil)) as? [String: String] else { fatalError("Invalid or non-existant Plaid info .plist file was provided.") }
    // Get configuration from Plaid.plist
    guard let key = info["publicKey"], let clientID = info["clientID"], let secret = info["secret"], let env = info["environment"], let environment = PlaidInfo.Environment(rawValue: env) else { fatalError("Couldn't get required Plaid API Info from Info.plist") }
    return PlaidInfo(publicKey: key, secret: secret, clientID: clientID, environment: environment)
  }
}

