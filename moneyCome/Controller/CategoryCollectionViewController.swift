//
//  CategoryCollectionViewController.swift
//  moneyCome
//
//  Created by binyu on 2021/6/12.
//

import UIKit

private let reuseIdentifier = "\(CategoryDetailCollectionViewCell.self)"

class CategoryCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var expenseCategories = ExpenseData.expenseCategories
    var incomeCategories = ExpenseData.incomeCategories
    
    var row:Int?
    var isExpenseCategory:Bool?
    
    init?(coder: NSCoder, isExpenseCategory: Bool) {
        self.isExpenseCategory = isExpenseCategory
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        collectionView.reloadData()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isExpenseCategory! {
            return expenseCategories.count
        }else {
            return incomeCategories.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CategoryDetailCollectionViewCell else {return CategoryDetailCollectionViewCell() }
         
        if isExpenseCategory! {
            let category = expenseCategories[indexPath.row]
            cell.categoryImageStr = "\(category.self)"
            cell.categoryLabelStr = category.rawValue
            cell.updateUI()
        }else {
            let category = incomeCategories[indexPath.row]
            cell.categoryImageStr = "\(category.self)"
            cell.categoryLabelStr = category.rawValue
            cell.updateUI()
        }
        // Configure the cell
    
        return cell
    }

   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      row = collectionView.indexPathsForSelectedItems?.first?.row
    }

    
    
   

}
