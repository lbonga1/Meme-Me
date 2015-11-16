//
//  TextFieldDelegate.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 4/21/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        textField.text = newText.uppercaseString
        return false
        // Replaces text input with string in all capital letters.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string: "")
        // Clears text field when it is selected.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
        // Dismisses keyboard when user taps "return".
    }
    
}