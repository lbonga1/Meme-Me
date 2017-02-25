//
//  DetailViewController.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 5/6/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var memeImageDetail: UIImageView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
// MARK: - Variables
    var sentMemes: Meme!
    var memeIndex = Int()
    
// MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hides bottom tab bar.
        tabBarController?.tabBar.isHidden = true
        
        // Sets UIImageView to meme image.
        memeImageDetail!.image = sentMemes.memedImage
        memeImageDetail!.contentMode = .scaleAspectFit
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Displays bottom tab bar.
        tabBarController?.tabBar.isHidden = false
    }
    
// MARK: - Actions
    // Edit button
    @IBAction func editMeme(_ sender: UIBarButtonItem) {
        // Segue to Meme Editor View Controller
        performSegue(withIdentifier: "detailToEdit", sender: self)
    }

    // Delete button
    @IBAction func deleteMeme(_ sender: UIBarButtonItem) {
        // Shared data source
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        // Removes meme from array.
        appDelegate.memes.remove(at: memeIndex)
        navigationController!.popViewController(animated: true)
    }
    
// MARK: - Additional method
    // Pass meme data to Meme Editor View Controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailToEdit") {
            let memeEditorVC = segue.destination as!
            MemeEditorViewController
            memeEditorVC.passedImage = sentMemes.originalImage
            memeEditorVC.passedTopText = sentMemes.topText
            memeEditorVC.passedBottomText = sentMemes.bottomText
        }
    }
}
