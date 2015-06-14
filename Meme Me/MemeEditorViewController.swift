//
//  MemeEditorViewController.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 3/30/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import UIKit
class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

    
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
    var passedImage: UIImage!
    var passedTopText:String!
    var passedBottomText:String!
    
    // Text field delegate objects
    let textDelegate = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Loads existing meme to edit if passed from Detail View Controller.
        imagePickerView.image = passedImage
        topTextField.text = passedTopText
        bottomTextField.text = passedBottomText
        
        // Sets the text delegates.
        self.topTextField.delegate = textDelegate
        self.bottomTextField.delegate = textDelegate
    }
    
    override func viewWillAppear(Bool) {
        // Shared data source
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
        
        // Text field properties method
        func setTextProperties(textField: UITextField, defaultString: String) {
            // Defines text field attributes
            textField.defaultTextAttributes = memeTextAttributes
            
            // Sets text alignment.
            textField.textAlignment = .Center
            
            // Sets capitalization default.
            textField.autocapitalizationType = .AllCharacters
            
            // Sets placeholder text.
            textField.attributedPlaceholder = NSAttributedString(string: defaultString, attributes: memeTextAttributes)
        }
        
        // Sets text field properties.
        setTextProperties(topTextField, "TOP")
        setTextProperties(bottomTextField, "BOTTOM")
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
// MARK: - Actions
    // Choose an image from photo library.
    @IBAction func pickImageFromLibrary(sender: UIBarButtonItem) {
        selectImage(.PhotoLibrary)
    }
    
    // Take a picture with the camera.
    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        selectImage(.Camera)
    }
    
    // Share button
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        // Opens activity view for sharing options.
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
    
    // Cancel button
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
        }
    }
}