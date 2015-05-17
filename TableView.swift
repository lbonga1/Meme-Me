//
//  TableView.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 5/3/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import UIKit

class TableView: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
        
        
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    
    // Global variable
    var sentMemes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up buttons
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        navigationItem.leftBarButtonItem = editButton
        navigationItem.rightBarButtonItem = addButton
        
        self.tableView.allowsMultipleSelectionDuringEditing = true

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Loads meme data from AppDelegate when view refreshes.
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        sentMemes = appDelegate.memes
        
        // Refresh sent meme data.
        self.tableView.reloadData()
            
        self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0)
    }
    
    override func viewDidAppear(animated: Bool) {
        // Redirects to MemeEditorVC if no memes have been sent.
        if sentMemes.count == 0 {
            let storyboard = self.storyboard
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorVC") as! ViewController
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // Table View data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentMemes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Assigns custom cell
        let CellID = "SentMeme"
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID, forIndexPath: indexPath) as! TableViewCell
        let meme = self.sentMemes[indexPath.row]
            
        // Sets cell label and image from Meme struct.
        cell.previewText?.text = meme.topText
        cell.memeImageView?.image = meme.memedImage
        cell.memeImageView.contentMode = .ScaleAspectFit
            
        return cell
    }

    // Cell selection options
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.tableView.editing {
            navigationItem.leftBarButtonItem = deleteButton
            //self.updateButtonsToMatchTableState()
        } else {
            // Gets Detail View Controller
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailVC") as! DetailViewController
            detailController.sentMemes = self.sentMemes[indexPath.row]
            detailController.memeIndex = indexPath.row
            
            self.navigationController!.pushViewController(detailController, animated: true)
        }
    }
    
    // Allows for editing tableView cells.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Delete single meme with swipe.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            sentMemes = appDelegate.memes
            
            sentMemes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            appDelegate.memes.removeAtIndex(indexPath.row)
        }
    }
    
    @IBAction func editMemes(sender: AnyObject) {
        // Turns on editing mode.
        self.tableView.setEditing(true, animated: true)
        // Updates buttons.
        navigationItem.leftBarButtonItem = deleteButton
        navigationItem.rightBarButtonItem = doneButton
        updateDeleteButtonTitle()
    }
    
    @IBAction func deleteMemes(sender: AnyObject) {
        // Delete multiple memes.
        func deleteSelection() {
            // Unwrap indexPaths to check if rows are selected.
            if let _ = tableView.indexPathsForSelectedRows() {
                // Delete rows from data source and tableView while all selected rows are deleted.
                do {
                    if let selectedRow = tableView.indexPathForSelectedRow(){
                        // Remove from tableView data source and tableView.
                        self.sentMemes.removeAtIndex(selectedRow.row)
                        tableView.deleteRowsAtIndexPaths([selectedRow], withRowAnimation: .Automatic)
                    }
                } while tableView.indexPathsForSelectedRows() != nil
            } else {
                // Delete everything, delete the objects from data model.
                self.sentMemes.removeAll(keepCapacity: false)
                // Tell the tableView that we deleted the objects.
                // Because we are deleting all the rows, just reload the current table section.
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
            }
            
            // Turns off editing mode.
            self.tableView.setEditing(false, animated: true)
            // Updates buttons.
            navigationItem.leftBarButtonItem = editButton
        }
        
        let alertController = UIAlertController(title: "Delete Memes", message: "Are you sure you want to delete these items?", preferredStyle: .Alert)
        
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {action in self.deleteSelection()}
//        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func doneEditing(sender: AnyObject) {
        // Turns off editing mode.
        self.tableView.setEditing(false, animated: true)
        // Updates buttons.
        navigationItem.leftBarButtonItem = editButton
        navigationItem.rightBarButtonItem = addButton
    
    }
    
    // Gets Meme Editor View Controller.
    @IBAction func newMeme(sender: AnyObject) {
        let storyboard = self.storyboard
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorVC") as! ViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func updateDeleteButtonTitle() {
        if let selectedRows = tableView.indexPathsForSelectedRows() {
            deleteButton.title = "Delete (\(selectedRows.count))"
        } else {
            deleteButton.title = "Delete All"
        }
    }
    
}



