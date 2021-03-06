//
//  CollectionViewController.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 5/3/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
// MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!

// MARK: - Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        // Set up buttons.
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = editButton
        navigationItem.leftBarButtonItem = addButton
        updateDeleteButtonTitle()
    }

// MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh sent meme data.
        collectionView.reloadData()
    }
    
// MARK: - Collection View Methods
    // Collection View data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    // Collection View cell information
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Assigns custom cell.
        let CellID = "CollectionMeme"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath) as! CollectionViewCell
        let meme = appDelegate.memes[indexPath.item]
        
        // Sets cell image from Meme struct.
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
        cell.backgroundView?.contentMode = .scaleAspectFit
        
        return cell
    }
    
    // Allows for editing collectionView cells.
    func collectionView(_ collectionView: UICollectionView, canEditItemAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Meme selection options
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Gets Detail View Controller if not editing.
        if navigationItem.rightBarButtonItem == editButton {
            let detailController = storyboard!.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
                detailController.sentMemes = appDelegate.memes[indexPath.row]
            navigationController!.pushViewController(detailController, animated: true)
        // Makes selections visible if editing.
        } else if navigationItem.rightBarButtonItem == deleteButton {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.alpha = 0.75
            updateDeleteButtonTitle()
        }
    }
    
    // Changes cell opacity and updates delete button title when deselected.
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.alpha = 1.0
        updateDeleteButtonTitle()
    }
    
// MARK: - Additional methods
    // Delete memes.
    func deleteSelection() {
        print("Starting delete")
        // Get selected items paths from collectionView.
        if let selectedItems = collectionView.indexPathsForSelectedItems as [IndexPath]? {
            // Check if items are selected.
            if selectedItems.isEmpty {
                print("No selections")
                // Delete everything, delete the objects from data model.
                appDelegate.memes.removeAll(keepingCapacity: false)
                collectionView?.reloadSections(IndexSet(integer: 0))
            } else if selectedItems.count == appDelegate.memes.count {
                print("Deleting all")
                // Delete everything, delete the objects from data model.
                appDelegate.memes.removeAll(keepingCapacity: false)
                collectionView?.reloadSections(IndexSet(integer: 0))
            } else {
                print("Some selections")
                var selectedMemes = [Meme]()
                // Create temporary array of selected items.
                for selectedItem in selectedItems{
                    selectedMemes.append(appDelegate.memes[selectedItem.row])
                    print(selectedMemes.count)
                }
                // Find objects from temporary array in data source and delete them.
                for object in selectedMemes {
                    if let index = appDelegate.memes.index(of: object) {
                        appDelegate.memes.remove(at: index)
                        print(appDelegate.memes.count)
                        collectionView?.reloadSections(IndexSet(integer: 0))
                    }
                }
            }
            updateDeleteButtonTitle()
        }
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
    
    // Updates delete button title depending on number of items selected.
    func updateDeleteButtonTitle() {
        let selectedItems = collectionView.indexPathsForSelectedItems! as [IndexPath]
        let allItemsSelected = selectedItems.count == appDelegate.memes.count
        let noItemsSelected = selectedItems.isEmpty
        
        if noItemsSelected {
            deleteButton.title = "Delete All"
        } else if allItemsSelected {
            deleteButton.title = "Delete All"
        } else {
            deleteButton.title = "Delete (\(selectedItems.count))"
        }
    }
    
// MARK: - Actions
    // Edit button
    @IBAction func editMemes(_ sender: AnyObject) {
        // Hides and reveals necessary toolbars and buttons.
        tabBarController?.tabBar.isHidden = true
        navigationItem.leftBarButtonItem = doneButton
        navigationItem.rightBarButtonItem = deleteButton
        // Allows user to select multiple memes.
        collectionView.allowsMultipleSelection = true
    }
    
    // Done button
    @IBAction func doneEditing(_ sender: AnyObject) {
        // Hides and reveals necessary toolbars and buttons.
        tabBarController?.tabBar.isHidden = false
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = editButton
        // Changes all selected cells' opacity back to original value.
        for indexPath in collectionView.indexPathsForSelectedItems! {
            let cell = collectionView.cellForItem(at: (indexPath as NSIndexPath) as IndexPath)
            cell?.alpha = 1.0
        }
        // Disables selection of multiple memes.
        collectionView.allowsMultipleSelection = false
    }
    
    // Delete button
    @IBAction func deleteMemes(_ sender: AnyObject) {
        // UIAlertController titles
        var alertTitle = "Remove Memes"
        var actionTitle = "Are you sure you want to remove these items?"
        // UIAlertController titles if only one meme is selected
        if let indexPaths = collectionView?.indexPathsForSelectedItems {
            if indexPaths.count == 1 {
                alertTitle = "Remove Meme"
                actionTitle = "Are you sure you want to remove this item?"
            }
        }
        // UIAlertController actions
        let alertController = UIAlertController(title: alertTitle, message: actionTitle, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) {action in self.dismiss(animated: true, completion: nil)})
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {action in self.deleteSelection()})
        // Presents Alert Controller for deletion options.
        present(alertController, animated: true, completion: nil)
    }
    
    // Add button
    @IBAction func newMeme(_ sender: AnyObject) {
        //Gets Meme Editor View Controller
        let controller = storyboard?.instantiateViewController(withIdentifier: "MemeEditorVC") as! MemeEditorViewController
        
        present(controller, animated: true, completion: nil)
    }
}
