//
//  MemeTextFieldDelegate.swift
//  MemeMeTest
//
//  Created by Donny Blaine on 11/6/16.
//  Copyright © 2016 RyStudios. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == textField.accessibilityHint {textField.text = ""}
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text == "") {textField.text = textField.accessibilityHint}
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
