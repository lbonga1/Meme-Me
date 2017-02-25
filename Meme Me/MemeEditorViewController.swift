//
//  MemeEditorViewController.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 3/30/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import UIKit
class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {

// MARK: - Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var userCancel: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var bottomToolBar: UIToolbar!

// MARK: - Variables
    var sentMemes: [Meme]!
    var passedImage: UIImage!
    var passedTopText:String!
    var passedBottomText:String!
    
    // Text field delegate objects
    let textDelegate = TextFieldDelegate()
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Loads existing meme to edit if passed from Detail View Controller.
        imagePickerView.image = passedImage
        topTextField.text = passedTopText
        bottomTextField.text = passedBottomText
        
        // Sets the text delegates.
        topTextField.delegate = textDelegate
        bottomTextField.delegate = textDelegate
    }
    
    override func viewWillAppear(_: Bool) {
        // Shared data source
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        sentMemes = appDelegate.memes
        
        // Disables camera button if unavailable.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        // Disables share button until a UIImage is chosen.
        if imagePickerView.image == nil {
            shareButton.isEnabled = false
        }
        
        // Sets text field properties.
        setTextProperties(topTextField, defaultString: "TOP")
        setTextProperties(bottomTextField, defaultString: "BOTTOM")
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
// MARK: - Actions
    // Choose an image from photo library.
    @IBAction func pickImageFromLibrary(_ sender: UIBarButtonItem) {
        selectImage(.photoLibrary)
    }
    
    // Take a picture with the camera.
    @IBAction func pickImageFromCamera(_ sender: UIBarButtonItem) {
        selectImage(.camera)
    }
    
    // Share button
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        // Opens activity view for sharing options.
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {
            activity, completed, returned, error in
            // Allows meme to be saved if activity is completed.
            if completed {
                self.saveMeme()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    // Cancel button
    @IBAction func userCancel(_ sender: UIBarButtonItem) {
        if sentMemes.count == 0 {
            // Displays error message if user does not have any sent memes.
            let alertController = UIAlertController()
            alertController.title = "Uh oh."
            alertController.message = "You do not have any sent memes to return to."
            let okAction = UIAlertAction (title: "Let's meme.", style: UIAlertActionStyle.default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else {
            // Displays sent memes in table view.
            dismiss(animated: true, completion: nil)
        }
    }
}
