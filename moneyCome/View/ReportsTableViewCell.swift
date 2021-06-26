//
//  ReportsTableViewCell.swift
//  moneyCome
//
//  Created by binyu on 2021/6/14.
//

import UIKit

class ReportsTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var categoryImageStr: String?
    var category: String?
    var amount: String?
    
    func updateUI() {
        categoryImageView.image = UIImage(named: categoryImageStr!)
        categoryLabel.text = category!
        amountLabel.text = amount!
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
