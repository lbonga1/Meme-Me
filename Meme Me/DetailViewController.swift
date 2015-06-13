//
//  DetailViewController.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 5/6/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // Outlets
    @IBOutlet weak var memeImageDetail: UIImageView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    // Global variable
    var sentMemes: Meme!
    var memeIndex = Int()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Hides bottom tab bar.
        self.tabBarController?.tabBar.hidden = true
        
        // Sets UIImageView to meme image.
        self.memeImageDetail!.image = self.sentMemes.memedImage
        self.memeImageDetail!.contentMode = .ScaleAspectFit
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Displays bottom tab bar.
        self.tabBarController?.tabBar.hidden = false
    }
    
// MARK: - Actions
    // Edit button
    @IBAction func editMeme(sender: UIBarButtonItem) {
        // Segue to Meme Editor View Controller
        self.performSegueWithIdentifier("detailToEdit", sender: self)
    }

    // Delete button
    @IBAction func deleteMeme(sender: UIBarButtonItem) {
        // Shared data source
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        // Removes meme from array.
        appDelegate.memes.removeAtIndex(memeIndex)
        self.navigationController!.popViewControllerAnimated(true)
    }
    
// MARK: - Additional method
    // Pass meme data to Meme Editor View Controller.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailToEdit") {
            let memeEditorVC = segue.destinationViewController as!
            ViewController
            memeEditorVC.passedImage = self.sentMemes.originalImage
            memeEditorVC.passedTopText = self.sentMemes.topText
            memeEditorVC.passedBottomText = self.sentMemes.bottomText
        }
    }
}
