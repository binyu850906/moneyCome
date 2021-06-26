//
//  MainViewController.swift
//  moneyCome
//
//  Created by binyu on 2021/6/11.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noItemLabel: UILabel!
    
    var allExpenseItems = [ExpenseData]() {
        didSet {
            ExpenseData.saveExpenseData(expenseDatas: allExpenseItems)
        }
    }
    
    var expenseItems = [ExpenseData]() {
        didSet{
            if expenseItems.isEmpty {
                noItemLabel.isHidden = false
            }else {
                noItemLabel.isHidden = true
            }
        }
    }
    
    var indexArr = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let allItems = ExpenseData.loadExpenseDatas()  {
            self.allExpenseItems = allItems
            getExpenseItemsByDate(selectedDateStr: dateFormatter(date: Date()))
        }
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    func updateUI() {
        noItemLabel.text = "  No data to display.\n  Please click [+] to add new record."
        datePicker.tintColor = UIColor(named: "MainColor")
        tableView.backgroundColor = UIColor.systemGray6
    }
    
    @IBAction func changeDate(_ sender: UIDatePicker) {
        
        getExpenseItemsByDate(selectedDateStr: dateFormatter(date: sender.date))
    }
    
    

    func getExpenseItemsByDate (selectedDateStr: String) {
        
        expenseItems.removeAll()
        indexArr.removeAll()
        
        var tempArr = allExpenseItems
        for _ in tempArr {
            if let index = tempArr.firstIndex(where: { $0.dateStr.hasPrefix(selectedDateStr)}) {
                print("有資料")
                indexArr.append(index)
                expenseItems.append(allExpenseItems[index])
                tempArr[index].dateStr = ""
            } else {
                print("沒資料")
                break
            }
        }
        tableView.reloadData()
    }
    
    
    func dateFormatter(date:Date) -> String {
        let dateFormtter = DateFormatter()
        dateFormtter.dateFormat = "E, MMMM d, yyyy"
        let dateStr = dateFormtter.string(from: date)
        print(dateStr)
        return dateStr
    }
    
    func numberFormater(amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let amountStr = formatter.string(from: NSNumber(value: amount))!
        return amountStr
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "ShowNavigationController" {
            if let navigationController = segue.destination as? UINavigationController, let targetController = navigationController.topViewController as? AddExpenseItemTableViewController, let row = tableView.indexPathForSelectedRow?.row {
                targetController.expenseItem = expenseItems[row]
                print("給資料")
                
            }
        }else {
            if let navigationController = segue.destination as? UINavigationController, let targetController = navigationController.topViewController as? AddExpenseItemTableViewController{
                targetController.expenseItem.dateStr = dateFormatter(date: datePicker.date)
                print("給data")
            }
        }
    }
    @IBAction func unwindToMain(_ unwindSegue: UIStoryboardSegue) {
        if let controller = unwindSegue.source as? AddExpenseItemTableViewController {
            let expenseItem = controller.expenseItem
            if let indexPath = tableView.indexPathForSelectedRow{
                expenseItems[indexPath.row] = expenseItem
                allExpenseItems[indexPath.row] = expenseItem
            } else {
               expenseItems.insert(expenseItem, at: 0)
               
                allExpenseItems.insert(expenseItem, at: 0)
               
                let indexPath = IndexPath(row: 0 , section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            tableView.reloadData()
        }
    }

}

extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenseItems.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let expAmount = expenseItems.reduce(0, {if $1.category.incomeCategory==nil{return $0+$1.amount};return $0})
        let incAmount = expenseItems.reduce(0, {if $1.category.expenseCategory == nil{ return $0+$1.amount };return $0})
        if expenseItems.isEmpty{
            return nil
        }else{
            return "EXP: \(expAmount)   INC: \(incAmount)   TOTAL: \(expAmount - incAmount)"
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ExpenseItemTableViewCell.self)", for: indexPath) as? ExpenseItemTableViewCell else {return ExpenseItemTableViewCell()}
        let expenseItem = expenseItems[indexPath.row]
        cell.amountLabel.text = numberFormater(amount: expenseItem.amount)
        cell.accountLabel.text = expenseItem.account.rawValue
        cell.memoLabel.text = expenseItem.memo
        if expenseItem.category.incomeCategory == nil {
            cell.categoryLabel.text = expenseItem.category.expenseCategory?.rawValue
            cell.categoryImageView.image = UIImage(named: "\(expenseItem.category.expenseCategory!)")
            cell.amountLabel.backgroundColor = UIColor.clear
            cell.amountLabel.textColor = UIColor.black
        }else{
            cell.categoryLabel.text = expenseItem.category.incomeCategory?.rawValue
            cell.categoryImageView.image = UIImage(named: "\(expenseItem.category.incomeCategory!)")
            cell.amountLabel.backgroundColor = UIColor.systemGreen
            cell.amountLabel.textColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        allExpenseItems.remove(at: indexPath.row)
        expenseItems.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
    
    
    
   
    
    
}
