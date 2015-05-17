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
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedMemes = [Meme]()
    
    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        navigationItem.leftBarButtonItem = editButton
        navigationItem.rightBarButtonItem = addButton
        updateDeleteButtonTitle()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh sent meme data.
        self.collectionView.reloadData()
    }

    // Collection View data source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Defines collectionView cell.
        let CellID = "CollectionMeme"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellID, forIndexPath: indexPath) as! CollectionViewCell
        let meme = appDelegate.memes[indexPath.item]
        
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
    
    // Meme selection options
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Gets Detail View Controller if not editing.
        if navigationItem.leftBarButtonItem == editButton {
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailVC") as! DetailViewController
                detailController.sentMemes = appDelegate.memes[indexPath.row]
            self.navigationController!.pushViewController(detailController, animated: true)
        // Makes selections visible if editing.
        } else if navigationItem.leftBarButtonItem == deleteButton {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            cell?.alpha = 0.75
            updateDeleteButtonTitle()
        }
    }
    
    // Changes cell opacity and updates delete button title when deselected.
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.alpha = 1.0
        updateDeleteButtonTitle()
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
    
    // Presents Alert Controller for deletion options.
    @IBAction func deleteMemes(sender: AnyObject) {
        // UIAlertController titles
        var alertTitle = "Remove Memes"
        var actionTitle = "Are you sure you want to remove these items?"
        // UIAlertController titles if only one meme is selected
        if let indexPaths = collectionView?.indexPathsForSelectedItems() {
            if indexPaths.count == 1 {
                alertTitle = "Remove Meme"
                actionTitle = "Are you sure you want to remove this item?"
            }
        }
        
        // UIAlertController actions
        let alertController = UIAlertController(title: alertTitle, message: actionTitle, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {action in self.dismissViewControllerAnimated(true, completion: nil)})
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {action in self.deleteSelection()})
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // Gets Meme Editor View Controller.
    @IBAction func newMeme(sender: AnyObject) {
        let storyboard = self.storyboard
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorVC") as! ViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }

    // Delete memes.
    func deleteSelection() {
        // Get selected items paths from collectionView.
        if let selectedItems = collectionView?.indexPathsForSelectedItems() as? [NSIndexPath]{
            // Check if items are selected.
            if selectedItems.isEmpty {
                // Create temporary array of selected items.
                for selectedItem in selectedItems{
                    selectedMemes.append(appDelegate.memes[selectedItem.row])
                }
                // Find objects from temporary array in data source and delete them.
                for object in selectedMemes {
                    if let index = find(appDelegate.memes, object){
                        appDelegate.memes.removeAtIndex(index)
                    }
                }
            } else {
                // Delete everything, delete the objects from data model.
                appDelegate.memes.removeAll(keepCapacity: false)
                collectionView?.reloadSections(NSIndexSet(index: 0))
            }
        }
        
        // Hides and reveals necessary toolbars and buttons.
        self.tabBarController?.tabBar.hidden = false
        navigationItem.leftBarButtonItem = editButton
        navigationItem.rightBarButtonItem = addButton
        
        // Gets Meme Editor View Controller if no sent memes are remaining.
        if appDelegate.memes.count == 0 {
            let storyboard = self.storyboard
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorVC") as! ViewController
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // Updates delete button title depending on number of items selected.
    func updateDeleteButtonTitle() {
        let selectedItems = collectionView?.indexPathsForSelectedItems() as? [NSIndexPath]
        let allItemsSelected = selectedItems!.count == appDelegate.memes.count
        let noItemsSelected = selectedItems!.isEmpty
        
        if noItemsSelected {
            deleteButton.title = "Delete All"
        } else if allItemsSelected {
            deleteButton.title = "Delete All"
        } else {
            deleteButton.title = "Delete (\(selectedItems!.count))"
        }
    }

    
}
