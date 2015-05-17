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
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!

    // Global variable
    var sentMemes: [Meme]!
    var selectedMemes = [Meme]()
    var editModeEnabled = false
    
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        navigationItem.leftBarButtonItem = editButton
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        sentMemes = appDelegate.memes
        
        self.collectionView.reloadData()
    }

    // Collection View data source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sentMemes.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let CellID = "CollectionMeme"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellID, forIndexPath: indexPath) as! CollectionViewCell
        let meme = self.sentMemes[indexPath.item]
        
        // Sets cell image from Meme struct.
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
        cell.backgroundView?.contentMode = .ScaleAspectFit
        
        return cell
    }
    
    // Allows for editing collectionView cells.
    func collectionView(collectionView: UICollectionView, canEditItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Gets Detail View Contoller or makes selections visible.
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if navigationItem.leftBarButtonItem == editButton {
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailVC") as! DetailViewController
                detailController.sentMemes = self.sentMemes[indexPath.row]
            self.navigationController!.pushViewController(detailController, animated: true)
        } else if navigationItem.leftBarButtonItem == deleteButton {
            let CellID = "CollectionMeme"
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellID, forIndexPath: indexPath) as! CollectionViewCell
            cell.backgroundColor = UIColor.lightGrayColor()
        }
    }

    @IBAction func editMemes(sender: AnyObject) {
        // Hides and reveals necessary toolbars and buttons.
        self.tabBarController?.tabBar.hidden = true
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = deleteButton
        // Allows user to select multiple memes.
        collectionView.allowsMultipleSelection = true
    }
    
    @IBAction func doneEditing(sender: AnyObject) {
        // Hides and reveals necessary toolbars and buttons.
        self.tabBarController?.tabBar.hidden = false
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = editButton
        // Disables selection of multiple memes.
        collectionView.allowsMultipleSelection = false
    }
    
    @IBAction func deleteMemes(sender: AnyObject) {
        // Preparing UIAlertController to present the alert on deletion
        var alertTitle = "Remove villains"
        var actionTitle = "Are you sure you want to remove these items?"
        
        if let indexPaths = collectionView?.indexPathsForSelectedItems() {
            if indexPaths.count == 1 {
                alertTitle = "Remove villain"
                actionTitle = "Are you sure you want to remove this item?"
            }
        }
        
        let alertController = UIAlertController(title: alertTitle, message: actionTitle, preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {action in  self.dismissViewControllerAnimated(true, completion: nil)}
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {action in  self.deleteSelection()}
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // Gets Meme Editor View Controller.
    @IBAction func newMeme(sender: AnyObject) {
        let storyboard = self.storyboard
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorVC") as! ViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }

    func deleteSelection() {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        sentMemes = appDelegate.memes
        // Get selected items paths from collection View
        // Unwrapping here is not really necessary as .indexPathsForSelectedItems() returns empty array if no rows are selected and not nil.
        if let selectedRows = collectionView?.indexPathsForSelectedItems() as? [NSIndexPath]{
            // Check if rows are selected
            if !selectedRows.isEmpty {
                // Create temporary array of selected items
                for selectedRow in selectedRows{
                    selectedMemes.append(sentMemes[selectedRow.row])
                }
                // Find objects from temporary array in data source and delete them
                for object in selectedMemes {
                    if let index = find(sentMemes, object){
                        sentMemes.removeAtIndex(index)
                    }
                }
                collectionView?.deleteItemsAtIndexPaths(selectedRows)
                // Clear temporary array just in case
                    selectedMemes.removeAll(keepCapacity: false)
                
            }else{
                
                // Delete everything, delete the objects from data model.
                sentMemes.removeAll(keepCapacity: false)
                collectionView?.reloadSections(NSIndexSet(index: 0))
            }
//            self.selecting = !selecting
//            updateButtonsToMatchTableState()
        }
    }

    
}
