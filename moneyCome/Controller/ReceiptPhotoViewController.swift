//
//  ReceiptPhotoViewController.swift
//  moneyCome
//
//  Created by binyu on 2021/6/12.
//

import UIKit

class ReceiptPhotoViewController: UIViewController {
    var receiptImageUrl:URL?
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ExpenseData.fetchReceiptImage(imageUrl: receiptImageUrl, imageView: imageView)
    }
    init?(coder: NSCoder, receiptImageUrl:URL?) {
        self.receiptImageUrl = receiptImageUrl
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      receiptImageUrl = nil
    }


}
