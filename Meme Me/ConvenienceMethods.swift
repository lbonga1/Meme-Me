//
//  ConvenienceMethods.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 6/13/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
// MARK: - Image methods
    // Image selection method
    func selectImage(source: UIImagePickerControllerSourceType) {
        // Enables share button.
        shareButton.enabled = true
        
        // Opens photo library.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Sets UIImageView to selected image.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject: AnyObject]!) {
        let selectedImage : UIImage = image
        imagePickerView.image = selectedImage
        imagePickerView.contentMode = .ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Create a UIImage that combines the image view and text fields.
    func generateMemedImage() -> UIImage
    {
        // Hides top and bottom toolbars.
        navBar.hidden = true
        bottomToolBar.hidden = true
        
        let selectedImage = imagePickerView.image
        let imageWidth = CGFloat(selectedImage!.size.width)
        let imageHeight = CGFloat(selectedImage!.size.height)
        
        // Render view to an image
        if imageWidth < imageHeight {
            UIGraphicsBeginImageContext(CGSizeMake(400, 562))
            self.view.drawViewHierarchyInRect(CGRectMake(0, -63, view.bounds.size.width, view.bounds.size.height), afterScreenUpdates: true)
        } else {
            UIGraphicsBeginImageContext(CGSizeMake(562, 400))
            self.view.drawViewHierarchyInRect(CGRectMake(-52, 0, view.bounds.size.width, view.bounds.size.height), afterScreenUpdates: true)
        }
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Makes top and bottom toolbars visible.
        navBar.hidden = false
        bottomToolBar.hidden = false
        
        return memedImage
    }
    
    // Create the meme object and add it to memes array.
    func saveMeme() {
        //Create the meme
        var meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage:
            imagePickerView.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
// MARK: - Keyboard methods
    // Gets the height of the keyboard to move the view.
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // Moves the view up when editing bottom text field.
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // Moves the view down when finished editing bottom text field.
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.resignFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    // Keyboard notification subscription
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Keyboard notification unsubscription
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
}
