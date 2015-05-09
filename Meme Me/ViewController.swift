//
//  ViewController.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 3/30/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    
    // Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var userCancel: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var bottomToolBar: UIToolbar!

    
    // Global variable
    var sentMemes: [Meme]!
    
    // Text field delegate objects
    let topTextDelegate = TopTextFieldDelegate()
    let bottomTextDelegate = BottomTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the text delegates.
        self.topTextField.delegate = topTextDelegate
        self.bottomTextField.delegate = bottomTextDelegate
    }
    
    override func viewWillAppear(Bool) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        sentMemes = appDelegate.memes
        
        // Disables camera button if unavailable.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Disables share button until a UIImage is chosen.
        if imagePickerView.image == nil {
            shareButton.enabled = false
        }
        
        // Meme text dictionary
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont (name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -4.0
        ]
        
        // Defines text field attributes.
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        // Sets text alignment.
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        // Sets capitalization default.
        topTextField.autocapitalizationType = .AllCharacters
        bottomTextField.autocapitalizationType = .AllCharacters
        
        // Sets placeholder text.
        topTextField.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: memeTextAttributes)
        bottomTextField.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: memeTextAttributes)
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // Choose an image from photo library.
    @IBAction func pickImageFromLibrary(sender: UIBarButtonItem) {
        // Enables share button.
        shareButton.enabled = true
        
        // Opens photo library.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Take a picture with the camera.
    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        // Enables share button.
        shareButton.enabled = true
        
        // Opens camera.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // Sets UIImageView to selected image.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject: AnyObject]!) {
        let selectedImage : UIImage = image
        imagePickerView.image = selectedImage
        imagePickerView.contentMode = .ScaleAspectFit
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Opens activity view for sharing options.
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {
            activity, completed, returned, error in
            // Allows meme to be saved if activity is completed.
            if completed {
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
    // Create a UIImage that combines the image view and text fields.
    func generateMemedImage() -> UIImage
    {
        // Hides top and bottom toolbars.
        navBar.hidden = true
        bottomToolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
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
    
    @IBAction func userCancel(sender: UIBarButtonItem) {
        if sentMemes.count == 0 {
            // Displays error message if user does not have any sent memes.
            let alertController = UIAlertController()
            alertController.title = "Uh oh."
            alertController.message = "You do not have any sent memes to return to."
            let okAction = UIAlertAction (title: "Let's meme.", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            // Displays sent memes in table view.
            self.dismissViewControllerAnimated(true, completion: nil)
//            var controller: TableView
//            controller = self.storyboard?.instantiateViewControllerWithIdentifier("TableView") as! TableView
//            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
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