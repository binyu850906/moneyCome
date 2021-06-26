//
//  CategoryDetailCollectionViewCell.swift
//  moneyCome
//
//  Created by binyu on 2021/6/12.
//

import UIKit

class CategoryDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var categoryImageStr: String?
    var categoryLabelStr: String?
    
    func updateUI() {
        categoryImageView.image = UIImage(named: categoryImageStr!)
        categoryLabel.text = categoryLabelStr
    }
}
