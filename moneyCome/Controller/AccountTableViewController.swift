//
//  AccountTableViewController.swift
//  moneyCome
//
//  Created by binyu on 2021/6/12.
//

import UIKit

class AccountTableViewController: UITableViewController {
    var row:Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ExpenseData.accounts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(AccountDetailTableViewCell.self)", for: indexPath) as? AccountDetailTableViewCell else {return AccountDetailTableViewCell()}
        
        let expenseData = ExpenseData.accounts[indexPath.row]
        cell.accountName = expenseData.rawValue
        cell.accountImage = "\(expenseData)"
        cell.updateUI()
        // Configure the cell...

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        row = tableView.indexPathForSelectedRow?.row
    }
    

}
