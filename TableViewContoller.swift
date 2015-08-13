//
//  TableViewController.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 5/3/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
        
        
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    
    // Variables
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedMemes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up buttons
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        navigationItem.rightBarButtonItem = editButton
        navigationItem.leftBarButtonItem = addButton
        updateDeleteButtonTitle()
        // Allows user to select multiple memes.
        self.tableView.allowsMultipleSelectionDuringEditing = true
        
        // Core Data convenience.
        var sharedContext: NSManagedObjectContext {
            return CoreDataStackManager.sharedInstance().managedObjectContext!
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh sent meme data.
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        // Redirects to MemeEditorVC if no memes have been sent.
        if appDelegate.memes.count == 0 {
            let storyboard = self.storyboard
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorVC") as! MemeEditorViewController
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
// MARK: - Table View methods
    // Table View data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    // Table View row information
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Assigns custom cell
        let CellID = "SentMeme"
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID, forIndexPath: indexPath) as! TableViewCell
        let meme = self.appDelegate.memes[indexPath.row]
        
        // Sets cell label and image from Meme struct.
        cell.previewText?.text = meme.topText
        cell.memeImageView?.image = meme.memedImage
        cell.memeImageView.contentMode = .ScaleAspectFit
            
        return cell
    }

    // Cell selection options
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Updates bar button and delete button title.
        if self.tableView.editing {
            navigationItem.rightBarButtonItem = deleteButton
            updateDeleteButtonTitle()
        } else {
            // Gets Detail View Controller.
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailVC") as! DetailViewController
            detailController.sentMemes = self.appDelegate.memes[indexPath.row]
            detailController.memeIndex = indexPath.row
            
            self.navigationController!.pushViewController(detailController, animated: true)
        }
    }
    
    // Update delete button title when memes are deselected.
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        updateDeleteButtonTitle()
    }
    
    // Allows for editing tableView cells.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Delete single meme with swipe.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            appDelegate.memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    
        // Gets Meme Editor View Controller if no sent memes are remaining.
        if appDelegate.memes.count == 0 {
            let storyboard = self.storyboard
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorVC") as! MemeEditorViewController
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
// MARK: - Additional methods
    // Delete memes.
    func deleteSelection() {
        println("Starting delete")
        // Get selected rows paths from tableView.
        if let selectedRows = tableView?.indexPathsForSelectedRows() as? [NSIndexPath]{
            // Check if items are selected.
            if selectedRows.isEmpty {
                println("No selections")
                // Delete everything, delete the objects from data model.
                appDelegate.memes.removeAll(keepCapacity: false)
                tableView.reloadData()
            } else if selectedRows.count == appDelegate.memes.count {
                println("Deleting all")
                // Delete everything, delete the objects from data model.
                appDelegate.memes.removeAll(keepCapacity: false)
                tableView.reloadData()
            } else {
                println("Some selections")
                // Create temporary array of selected items.
                for selectedRow in selectedRows{
                    selectedMemes.append(appDelegate.memes[selectedRow.row])
                }
                // Find objects from temporary array in data source and delete them.
                for object in selectedMemes {
                    if let index = find(appDelegate.memes, object){
                        appDelegate.memes.removeAtIndex(index)
                        tableView.reloadData()
                    }
                }
            }
            updateDeleteButtonTitle()
        }
        
        // Turns off editing mode.
        self.tableView.setEditing(false, animated: true)
        // Hides and reveals necessary toolbars and buttons.
        self.tabBarController?.tabBar.hidden = false
        navigationItem.rightBarButtonItem = editButton
        navigationItem.leftBarButtonItem = addButton
        
        // Gets Meme Editor View Controller if no sent memes are remaining.
        if appDelegate.memes.count == 0 {
            let storyboard = self.storyboard
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorVC") as! MemeEditorViewController
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

    // Update delete button title depeding on number of rows selected.
    func updateDeleteButtonTitle() {
        if let selectedRows = tableView.indexPathsForSelectedRows() {
            deleteButton.title = "Delete (\(selectedRows.count))"
            
            let allItemsAreSelected = selectedRows.count == appDelegate.memes.count ? true : false
            if allItemsAreSelected {self.deleteButton.title = "Delete All"}
        } else {
            deleteButton.title = "Delete All"
        }
    }
    
// MARK: - Actions
    // Edit button
    @IBAction func editMemes(sender: AnyObject) {
        // Turns on editing mode.
        self.tableView.setEditing(true, animated: true)
        // Updates buttons.
        navigationItem.rightBarButtonItem = deleteButton
        navigationItem.leftBarButtonItem = doneButton
        updateDeleteButtonTitle()
    }
    
    // Delete button
    @IBAction func deleteMemes(sender: AnyObject) {
        // UIAlertController titles
        var alertTitle = "Remove Memes"
        var actionTitle = "Are you sure you want to remove these items?"
        // UIAlertController titles if only one meme is selected
        if let indexPaths = tableView?.indexPathsForSelectedRows() {
            if indexPaths.count == 1 {
                alertTitle = "Remove Meme"
                actionTitle = "Are you sure you want to remove this item?"
            }
        }
        // UIAlertController actions
        let alertController = UIAlertController(title: alertTitle, message: actionTitle, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {action in self.dismissViewControllerAnimated(true, completion: nil)})
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {action in self.deleteSelection()})
        // Presents Alert Controller for deletion options
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Done button.
    @IBAction func doneEditing(sender: AnyObject) {
        // Turns off editing mode.
        self.tableView.setEditing(false, animated: true)
        // Updates buttons.
        navigationItem.rightBarButtonItem = editButton
        navigationItem.leftBarButtonItem = addButton
    }
    
    // Add button.
    @IBAction func newMeme(sender: AnyObject) {
        // Gets Meme Editor View Controller.
        let storyboard = self.storyboard
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorVC") as! MemeEditorViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
}



