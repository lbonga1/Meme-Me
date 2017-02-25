//
//  ConvenienceMethods.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 6/13/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import Foundation
import UIKit

extension MemeEditorViewController {
    
// MARK: - Setup
    // Text field properties method
    func setTextProperties(_ textField: UITextField, defaultString: String) {
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont (name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -4.0
            ] as [String : Any]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.autocapitalizationType = .allCharacters
        textField.attributedPlaceholder = NSAttributedString(string: defaultString, attributes: memeTextAttributes)
    }
    
// MARK: - Image methods
    // Image selection method
    func selectImage(_ source: UIImagePickerControllerSourceType) {
        // Enables share button.
        shareButton.isEnabled = true
        
        // Opens photo library.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Sets UIImageView to selected image.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        let selectedImage : UIImage = image
        imagePickerView.image = selectedImage
        imagePickerView.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
    }
    
    // Create a UIImage that combines the image view and text fields.
    func generateMemedImage() -> UIImage
    {
        // Hides top and bottom toolbars.
        navBar.isHidden = true
        bottomToolBar.isHidden = true
        
        let selectedImage = imagePickerView.image
        let imageWidth = CGFloat(selectedImage!.size.width)
        let imageHeight = CGFloat(selectedImage!.size.height)
        
        // Render view to an image
        if imageWidth < imageHeight {
            UIGraphicsBeginImageContext(CGSize(width: 400, height: 562))
            view.drawHierarchy(in: CGRect(x: 0, y: -63, width: view.bounds.size.width, height: view.bounds.size.height), afterScreenUpdates: true)
        } else {
            UIGraphicsBeginImageContext(CGSize(width: 562, height: 400))
            view.drawHierarchy(in: CGRect(x: -52, y: 0, width: view.bounds.size.width, height: view.bounds.size.height), afterScreenUpdates: true)
        }
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Makes top and bottom toolbars visible.
        navBar.isHidden = false
        bottomToolBar.isHidden = false
        
        return memedImage
    }
    
    // Create the meme object and add it to memes array.
    func saveMeme() {
        //Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage:
            imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
// MARK: - Keyboard methods
    // Gets the height of the keyboard to move the view.
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Moves the view up when editing bottom text field.
    func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Moves the view down when finished editing bottom text field.
    func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.resignFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    // Keyboard notification subscription
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Keyboard notification unsubscription
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
}
