//
//  AccountDetailTableViewCell.swift
//  moneyCome
//
//  Created by binyu on 2021/6/12.
//

import UIKit

class AccountDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var accountImageView: UIImageView!
    var accountImage: String?
    var  accountName: String?
    
    func updateUI(){
        accountImageView.image = UIImage(named: accountImage!)
        accountLabel.text = accountName!
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
