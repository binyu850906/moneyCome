//
//  NumberKeyBoardReturn.swift
//  moneyCome
//
//  Created by binyu on 2021/6/11.
//

import Foundation
import  UIKit

extension UITextField {
    func setNumberKeyboardReturn() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectDoneButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([space, doneBtn], animated: true)
        
        self.inputAccessoryView = toolBar
    }
    
    @objc func selectDoneButton(){
        self.resignFirstResponder()
    }
}
