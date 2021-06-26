//
//  ReportsTableViewController.swift
//  moneyCome
//
//  Created by binyu on 2021/6/14.
//

import UIKit
import Charts

class ReportsTableViewController: UITableViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
   
    @IBOutlet weak var monthTextField: UITextField!
    
    var allExpenseItems = [ExpenseData]()
    var nowMonthItems = [ExpenseData]()
    var pieChartDataEntries = [PieChartDataEntry]()
    
    var nowDate: Date?
    let datePicker = UIDatePicker()
    var nowDateStr: String?
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    
    override func viewWillAppear(_ animated: Bool) {
        createDatePicker()
        
        if let allItems = ExpenseData.loadExpenseDatas() {
            self.allExpenseItems = allItems
            self.nowMonthItems = fetchMonthData(allItems)
          setChartView()
        }
       
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        
        let legend = pieChartView.legend
         legend.horizontalAlignment = .center
         legend.verticalAlignment = .bottom
         legend.orientation = .horizontal
         pieChartView.usePercentValuesEnabled = true
        
        
    }
    
    
    func fetchMonthData(_ allExpenseItems: [ExpenseData]) -> [ExpenseData] {
        let monthItem = allExpenseItems.filter { data -> Bool in
            if ( data.dateStr.contains(months[currentMonth - 1]) && data.dateStr.contains("\(currentYear)") ) {
                return true
            }else{
                return false
            }
        }
        tableView.reloadData()
        setChartView()
        print(nowDateStr!)
        return monthItem
    }
    
    func createDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = " MMMM,yyyy "
        nowDate = Date()
        nowDateStr = dateFormatter.string(from: nowDate!)
        monthTextField.text = dateFormatter.string(from: nowDate!)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        monthTextField.inputView = datePicker
        monthTextField.inputAccessoryView = setDatePickerReturn()
    }
    func setDatePickerReturn() -> UIToolbar {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectDoneButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolBar.setItems([space, doneBtn], animated: true)
        return toolBar
    }
    
    @objc func selectDoneButton(){
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = " MMMM,yyyy "
        nowDate = datePicker.date
        nowDateStr = dateFormatter.string(from: nowDate!)
        monthTextField.text = dateFormatter.string(from: nowDate!)
        
        
        currentMonth = Calendar.current.component(.month, from: nowDate!)
        currentYear = Calendar.current.component(.year, from: nowDate!)
        nowMonthItems = fetchMonthData(allExpenseItems)
        setChartView()
        print(currentMonth,currentYear)
        
        self.view.endEditing(true)
    }
    
    func setChartView() {
       
        pieChartDataEntries = ExpenseData.expenseCategories.map({(category)->PieChartDataEntry in
            return PieChartDataEntry(value: Double(calculateSum(category: category)), label: category.rawValue)
        })
        
        //設定項目 DataSet
        let dataSet = PieChartDataSet(entries: pieChartDataEntries, label: "")
        // 設定項目顏色
        dataSet.colors = ExpenseData.expenseCategories.map({ (category)->UIColor in
            return UIColor(named: "\(category)") ?? UIColor.white
        })
        // 點選後突出距離
        dataSet.selectionShift = 10
        // 圓餅分隔間距
        dataSet.sliceSpace = 5
        // 不顯示數值
        
        //設定資料 Data
        let data = PieChartData(dataSet: dataSet)
        data.setValueFormatter(DigitValueFormatter())
        pieChartView.data = data
        let totalAmount = nowMonthItems.reduce(0, {$0+$1.amount})
        pieChartView.centerText = "支出總和\n$\(numberFormatter(amount: totalAmount))"
        
        //動畫
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
    }
    
    func calculateSum(category: ExpenseCategory) -> Int {
        let totalAmount = nowMonthItems.reduce(0) {
            if $1.category.expenseCategory == category {
                return $0 + $1.amount
            }else {
                return $0
            }
        }
        return totalAmount
    }
    
    
    func numberFormatter(amount:Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.usesGroupingSeparator = true
        formatter.groupingSize = 3
        formatter.groupingSeparator = ","
        let amountStr = formatter.string(from: NSNumber(value: amount))!
        return amountStr
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return ExpenseData.expenseCategories.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReportsTableViewCell", for: indexPath) as? ReportsTableViewCell else {
            return ReportsTableViewCell()
        }
        let category = ExpenseData.expenseCategories[indexPath.row]
        cell.categoryImageStr = "\(category)"
        cell.category = category.rawValue
        cell.amount = "$\(numberFormatter(amount: calculateSum(category: category)))"
        cell.updateUI()
        // Configure the cell...

        return cell
    }

   
    @IBAction func nextMonthButtonPress(_ sender: Any) {
        currentMonth += 1
            if currentMonth == 13{
                currentMonth = 1
                currentYear += 1
            }
        monthTextField.text = "\(months[currentMonth - 1]),\(currentYear)"
        nowDateStr = monthTextField.text
        nowMonthItems = fetchMonthData(allExpenseItems)
        setChartView()
    }
    @IBAction func previousMonthButtonPress(_ sender: Any) {
        currentMonth -= 1
            if currentMonth == 0{
                currentMonth = 12
                currentYear -= 1
            }
        monthTextField.text = "\(months[currentMonth - 1]),\(currentYear)"
        nowDateStr = monthTextField.text
        nowMonthItems = fetchMonthData(allExpenseItems)
        setChartView()
    }
    
   
}

class DigitValueFormatter: NSObject, ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        let valueWithoutDecimalPart = String(format: "%.1f%%", value)
        return valueWithoutDecimalPart
    }
}
