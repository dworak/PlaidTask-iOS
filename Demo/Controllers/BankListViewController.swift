//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import UIKit
import LinkKit

class BankListViewController: UIViewController {
  @IBOutlet var tableView: UITableView?
  
  let cellIdentifier = "cellIdentifier"
  var cachedResponse: Link?
  
  var institutions = Set<String>() {
    didSet {
      tableView?.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  private func setupView() {
    tableView?.register(CustomTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
  }

  @IBAction func show() {
    let vc = PLKPlaidLinkViewController(
      configuration: PLKConfiguration(
        key: APIConstants.key,
        env: .sandbox,
        product: .transactions
      ),
      delegate: self
    )
    present(vc, animated: true, completion: nil)
  }
}

extension BankListViewController: PLKPlaidLinkViewDelegate {
  func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
    
    PlaidManager.shared.api.getAccessToken(from: publicToken) { accessToken, error in
      PlaidManager.shared.accessToken = accessToken
    }
    
    guard let dict = metadata else {
      print("Error: missing response metadata")
      return
    }
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
      let response = try JSONDecoder().decode(Link.self, from: jsonData)
      cachedResponse = response
      
      institutions.insert(response.institution.name)
      linkViewController.dismiss(animated: true, completion: nil)
    } catch {
      print("Error: \(error.localizedDescription)")
    }
  }
  
  func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
    linkViewController.dismiss(animated: true, completion: nil)
  }
}

extension BankListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Array(institutions).count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
    let items = Array(institutions)
    let item = items[indexPath.row]
    cell.accessoryType = .disclosureIndicator
    cell.textLabel?.text = item
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let response = cachedResponse else {
      print("Error: missing response data")
      return
    }
    
    let accountsVC = AccountListViewController(accounts: response.accounts)
    navigationController?.pushViewController(accountsVC, animated: true)
  }
}


// https://sandbox.plaid.com/transactions/get
// Content-Type of application/json
