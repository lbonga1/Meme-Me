//
//  TableViewController.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 5/3/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
        
// MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    
// MARK: - Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var selectedMemes = [Meme]()
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up buttons
        navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.rightBarButtonItem = editButton
        navigationItem.leftBarButtonItem = addButton
        updateDeleteButtonTitle()
        // Allows user to select multiple memes.
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh sent meme data.
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Redirects to MemeEditorVC if no memes have been sent.
        if appDelegate.memes.count == 0 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorViewController
            
            present(controller, animated: true, completion: nil)
        }
    }
    
// MARK: - Table View methods
    // Table View data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    // Table View row information
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Assigns custom cell
        let CellID = "SentMeme"
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID, for: indexPath) as! TableViewCell
        let meme = appDelegate.memes[indexPath.row]
        
        // Sets cell label and image from Meme struct.
        cell.previewText?.text = meme.topText
        cell.memeImageView?.image = meme.memedImage
        cell.memeImageView.contentMode = .scaleAspectFit
            
        return cell
    }

    // Cell selection options
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Updates bar button and delete button title.
        if self.tableView.isEditing {
            navigationItem.rightBarButtonItem = deleteButton
            updateDeleteButtonTitle()
        } else {
            // Gets Detail View Controller.
            let detailController = storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
            detailController.sentMemes = appDelegate.memes[indexPath.row]
            detailController.memeIndex = indexPath.row
            
            navigationController!.pushViewController(detailController, animated: true)
        }
    }
    
    // Update delete button title when memes are deselected.
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateDeleteButtonTitle()
    }
    
    // Allows for editing tableView cells.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Delete single meme with swipe.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    
        // Gets Meme Editor View Controller if no sent memes are remaining.
        if appDelegate.memes.count == 0 {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorViewController
            
            present(controller, animated: true, completion: nil)
        }
    }
    
// MARK: - Additional methods
    // Delete memes.
    func deleteSelection() {
        print("Starting delete")
        // Get selected rows paths from tableView.
        if let selectedRows = tableView.indexPathsForSelectedRows as [IndexPath]? {
            // Check if items are selected.
            if selectedRows.isEmpty {
                print("No selections")
                // Delete everything, delete the objects from data model.
                appDelegate.memes.removeAll(keepingCapacity: false)
                tableView.reloadData()
            } else if selectedRows.count == appDelegate.memes.count {
                print("Deleting all")
                // Delete everything, delete the objects from data model.
                appDelegate.memes.removeAll(keepingCapacity: false)
                tableView.reloadData()
            } else {
                print("Some selections")
                // Create temporary array of selected items.
                for selectedRow in selectedRows{
                    selectedMemes.append(appDelegate.memes[selectedRow.row])
                }
                // Find objects from temporary array in data source and delete them.
                for object in selectedMemes {
                    if let index = appDelegate.memes.index(of: object) {
                        appDelegate.memes.remove(at: index)
                        tableView.reloadData()
                    }
                }
            }
            updateDeleteButtonTitle()
        }
        
        // Turns off editing mode.
        tableView.setEditing(false, animated: true)
        // Hides and reveals necessary toolbars and buttons.
        tabBarController?.tabBar.isHidden = false
        navigationItem.rightBarButtonItem = editButton
        navigationItem.leftBarButtonItem = addButton
        
        // Gets Meme Editor View Controller if no sent memes are remaining.
        if appDelegate.memes.count == 0 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorViewController
            
            present(controller, animated: true, completion: nil)
        }
    }

    // Update delete button title depeding on number of rows selected.
    func updateDeleteButtonTitle() {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            deleteButton.title = "Delete (\(selectedRows.count))"
            
            let allItemsAreSelected = selectedRows.count == appDelegate.memes.count ? true : false
            if allItemsAreSelected {deleteButton.title = "Delete All"}
        } else {
            deleteButton.title = "Delete All"
        }
    }
    
// MARK: - Actions
    // Edit button
    @IBAction func editMemes(_ sender: AnyObject) {
        // Turns on editing mode.
        tableView.setEditing(true, animated: true)
        // Updates buttons.
        navigationItem.rightBarButtonItem = deleteButton
        navigationItem.leftBarButtonItem = doneButton
        updateDeleteButtonTitle()
    }
    
    // Delete button
    @IBAction func deleteMemes(_ sender: AnyObject) {
        // UIAlertController titles
        var alertTitle = "Remove Memes"
        var actionTitle = "Are you sure you want to remove these items?"
        // UIAlertController titles if only one meme is selected
        if let indexPaths = tableView?.indexPathsForSelectedRows {
            if indexPaths.count == 1 {
                alertTitle = "Remove Meme"
                actionTitle = "Are you sure you want to remove this item?"
            }
        }
        // UIAlertController actions
        let alertController = UIAlertController(title: alertTitle, message: actionTitle, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {action in self.dismiss(animated: true, completion: nil)})
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {action in self.deleteSelection()})
        // Presents Alert Controller for deletion options
        present(alertController, animated: true, completion: nil)
    }
    
    // Done button.
    @IBAction func doneEditing(_ sender: AnyObject) {
        // Turns off editing mode.
        tableView.setEditing(false, animated: true)
        // Updates buttons.
        navigationItem.rightBarButtonItem = editButton
        navigationItem.leftBarButtonItem = addButton
    }
    
    // Add button.
    @IBAction func newMeme(_ sender: AnyObject) {
        // Gets Meme Editor View Controller.
        let controller = storyboard?.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorViewController
        
        present(controller, animated: true, completion: nil)
    }
}



