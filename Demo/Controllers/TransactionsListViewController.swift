//  Copyright © 2020 Lukasz Dworakowski. All rights reserved.

import UIKit
import LinkKit

final class TransactionTableViewCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class TransactionsListViewController: UIViewController {
  private let tableView = UITableView()
  private let transactions: [Transaction]
  
  override func loadView() {
    view = tableView
  }
  
  init(transactions: [Transaction]) {
    self.transactions = transactions
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    title = "Transactions"
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "identifier")
    view.backgroundColor = .white
  }
}

extension TransactionsListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath)
    
    let transaction = transactions[indexPath.row]
    cell.textLabel?.text = transaction.name
    cell.detailTextLabel?.text = "\(transaction.amount)"
    cell.detailTextLabel?.textColor = transaction.amount < 0 ? .red : .systemGreen
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return transactions.count
  }
}
