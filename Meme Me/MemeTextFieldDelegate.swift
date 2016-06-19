//
//  MemeTextFieldDelegate.swift
//  Meme Me
//
//  Created by Jennifer Person on 5/9/16
//  Copyright © 2016 udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {

    // Clears default text for user to begin entering
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}


