//
//  CollectionView.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 5/3/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import UIKit

class CollectionView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addMeme: UIBarButtonItem!
    
    // Global variable
    var sentMemes: [Meme]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        sentMemes = appDelegate.memes
        
        self.collectionView.reloadData()
    }

    // Collection View data source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println ("returning count")
        return sentMemes.count
        
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let CellID = "CollectionMeme"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellID, forIndexPath: indexPath) as! CollectionViewCell
        let meme = self.sentMemes[indexPath.item]
        
        // Sets cell image from Meme struct.
        let imageView = UIImageView(image: meme.memedImage)
        cell.memeImageView? = imageView
        println("completed cell")
        return cell
    }

    // Gets Meme Editor View Controller.
    @IBAction func newMeme(sender: UIBarButtonItem) {
        let storyboard = self.storyboard
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorVC") as! ViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
 
}
