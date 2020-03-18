//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import UIKit

final class CustomTableViewCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class AccountListViewController: UIViewController {
  private let tableView = UITableView()
  private let accounts: [Account]
  
  init(accounts: [Account]) {
    self.accounts = accounts
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = tableView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Accounts"
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "identifier")
  }
}

extension AccountListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
    
    let account = accounts[indexPath.row]
    cell.textLabel?.text = account.name
    cell.detailTextLabel?.text = account.type.rawValue
    cell.accessoryType = .disclosureIndicator
  
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return accounts.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let account = accounts[indexPath.row]
    PlaidManager.shared.api.getTransactions(for: account.id) { [weak self] (item, transactions, error) in
      DispatchQueue.main.async {
        let vc = TransactionsListViewController(transactions: transactions ?? [])
        self?.navigationController?.pushViewController(vc, animated: true)
      }
    }
  }
}

class ButtonWithShadow: UIButton {
  override func draw(_ rect: CGRect) {
    updateLayerProperties()
  }
  
  func updateLayerProperties() {
    layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    layer.shadowOffset = CGSize(width: 2, height: 3)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 10.0
    layer.masksToBounds = false
    layer.cornerRadius = 8
  }
}
