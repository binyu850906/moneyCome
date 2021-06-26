//
//  AddExpenseItemTableViewController.swift
//  moneyCome
//
//  Created by binyu on 2021/6/11.
//

import UIKit

class AddExpenseItemTableViewController: UITableViewController {

    var expenseItem = ExpenseData(dateStr: "", amount: 0, category: ExpenseData.Category(incomeCategory: nil, expenseCategory: .clothes), account: .cash, receiptPhotoUrl: nil, memo: nil)
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var receiptPhotoImageView: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var memoTextField: UITextField!
    
    let dataCategorys = DataCategorys.allCases
    var isExpenseCategory :Bool?
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if amountTextField.text?.isEmpty == true {
            didNotCompleteAlertController()
            return false
        }else {
            return true
        }
    }
    
    func didNotCompleteAlertController() {
        let controller = UIAlertController(title: "未填寫金額", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "確認", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataCategory = dataCategorys[indexPath.section]
        switch dataCategory {
        case .neededDatas:
            let neededDatas = NeededDatas.allCases[indexPath.row]
            switch neededDatas {
            case .date:
                return
            case .amount:
                return
            case .category:
                performSegue(withIdentifier: "\(CategoryCollectionViewController.self)", sender: nil)
            case .account:
                performSegue(withIdentifier: "\(AccountTableViewController.self)", sender: nil)
            }
            
        case .additionalDatas:
            let additionalDates = AdditionalDatas.allCases[indexPath.row]
            switch additionalDates {
            case .memo:
                return
            case .receiptPhoto:
                if receiptPhotoImageView.image == nil{
                    selectPhotoAlertController()
                }else{
                    showReceiptImageController()
                }
            }
        }
    }
    
    func showReceiptImageController(){
        if let controller = storyboard?.instantiateViewController(identifier: "\(ReceiptPhotoViewController.self)", creator: { coder in
            ReceiptPhotoViewController(coder: coder, receiptImageUrl: self.expenseItem.receiptPhotoUrl)
        }){
            controller.modalPresentationStyle = .fullScreen
            show(controller, sender: nil)
        }
    }
    
    
    
    
    func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = setDatePickerReturn()
    }
    
    func setDatePickerReturn() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectDoneButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, doneBtn], animated: true)
        return toolBar
    }
    
    @objc func selectDoneButton(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMMM d, yyyy"
        let selectedDate =  dateFormatter.string(from: datePicker.date)
        expenseItem.dateStr = selectedDate
        dateTextField.text = selectedDate
        self.view.endEditing(true)
    }
    
    
    func updateUI() {
        print(expenseItem)
        
        amountTextField.keyboardType = .numberPad
        amountTextField.setNumberKeyboardReturn()
        
        createDatePicker()
        
        dateTextField.text = expenseItem.dateStr
        
        if expenseItem.amount == 0 {
            amountTextField.text = ""
        }else {
            amountTextField.text = expenseItem.amount.description
        }
        
        if expenseItem.category.expenseCategory == nil {
            segmentedControl.selectedSegmentIndex = 1
            isExpenseCategory = false
            categoryImageView.image = UIImage(named: "\(expenseItem.category.incomeCategory!)")
            categoryLabel.text = expenseItem.category.incomeCategory?.rawValue
            
        } else {
            segmentedControl.selectedSegmentIndex = 0
            isExpenseCategory = true
            categoryImageView.image = UIImage(named: "\(expenseItem.category.expenseCategory!)")
            categoryLabel.text = expenseItem.category.expenseCategory?.rawValue
        }
        
        accountImageView.image = UIImage(named: "\(expenseItem.account)")
        accountLabel.text = expenseItem.account.rawValue
        
        ExpenseData.fetchReceiptImage(imageUrl: expenseItem.receiptPhotoUrl, imageView: receiptPhotoImageView)
        
        memoTextField.text = expenseItem.memo
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
    dismiss(animated: true, completion: nil)
     }
   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let amount = Int(amountTextField.text!) ?? 0
        expenseItem.amount = amount
        
        if let memo = memoTextField.text{
            expenseItem.memo = memo
        }
    }
    
    @IBSegueAction func categoryDetail(_ coder: NSCoder) -> CategoryCollectionViewController? {
        return CategoryCollectionViewController(coder: coder, isExpenseCategory: isExpenseCategory ?? true)
    }
    
    @IBAction func unwindToAddExpenseScene(_ unwindSegue: UIStoryboardSegue) {
        
        if let categoryViewController = unwindSegue.source as? CategoryCollectionViewController, let row = categoryViewController.row {
        if isExpenseCategory! {
            let category = ExpenseData.expenseCategories[row]
            print(category)
            
            expenseItem.category = ExpenseData.Category(incomeCategory: nil, expenseCategory: category )
            
            categoryImageView.image = UIImage(named: "\(expenseItem.category.expenseCategory!)")
            
            categoryLabel.text = expenseItem.category.expenseCategory?.rawValue
        } else{
            let category = ExpenseData.incomeCategories[row]
            expenseItem.category = ExpenseData.Category(incomeCategory: category, expenseCategory: nil)
            categoryImageView.image = UIImage(named: "\(expenseItem.category.incomeCategory)")
            categoryLabel.text = expenseItem.category.incomeCategory?.rawValue
          }
        
        }else if let accountController = unwindSegue.source as? AccountTableViewController, let row = accountController.row {
            
            let account = ExpenseData.accounts[row]
            expenseItem.account = account
            accountImageView.image = UIImage(named: "\(account)")
            accountLabel.text = account.rawValue
        
        }else if let _ = unwindSegue.source as? ReceiptPhotoViewController{
            expenseItem.receiptPhotoUrl = nil
            receiptPhotoImageView.image = nil
            cameraBtn.isHidden = false
        }
        tableView.reloadData()
    }
    
    @IBAction func selectCategory(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isExpenseCategory = true
            expenseItem.category.expenseCategory = ExpenseData.expenseCategories.first
            expenseItem.category.incomeCategory = nil
            categoryImageView.image = UIImage(named: "\(ExpenseData.expenseCategories.first!)")
            categoryLabel.text = ExpenseData.expenseCategories.first?.rawValue
        }else {
            isExpenseCategory = false
            expenseItem.category.expenseCategory = nil
            expenseItem.category.incomeCategory = ExpenseData.incomeCategories.first
            categoryImageView.image = UIImage(named: "\(ExpenseData.incomeCategories.first!)")
            categoryLabel.text = ExpenseData.incomeCategories.first?.rawValue
        }
    }
    
        
}
extension AddExpenseItemTableViewController :UITextFieldDelegate  {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
extension AddExpenseItemTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        expenseItem.receiptPhotoUrl = info[.imageURL] as? URL
        receiptPhotoImageView.image = info[.originalImage] as? UIImage
        cameraBtn.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    func selectPhotoAlertController() {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let sources: [(sheetTittle: String,sourceType: UIImagePickerController.SourceType)]
            = [("Album",.photoLibrary),("Camera", .camera)]
        for source in sources {
            let action = UIAlertAction(title: source.sheetTittle, style: .default) { _ in
                self.selectPhoto(sourceType: source.sourceType)
            }
            controller.addAction(action)
        }
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
    func selectPhoto(sourceType:UIImagePickerController.SourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
}
