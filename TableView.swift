//
//  TableView.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 5/3/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import UIKit

class TableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
        
    // Outlets
    @IBOutlet weak var addMeme: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // Global variable
    var sentMemes: [Meme]!
        
//    override func viewDidLoad() {
//        if sentMemes.count == 0 {
//            let storyboard = self.storyboard
//            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorVC") as! ViewController
//            
//            self.presentViewController(controller, animated: true, completion: nil)
//        }
//    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        sentMemes = appDelegate.memes
        
        self.tableView.reloadData()
    }
    
    // Table View data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentMemes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
        let CellID = "SentMeme"
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID, forIndexPath: indexPath) as! TableViewCell
        let meme = self.sentMemes[indexPath.row]
            
        // Sets cell label and image from Meme struct.
        cell.previewText?.text = meme.topText
        cell.memeImageView?.image = meme.memedImage
        cell.memeImageView.contentMode = .ScaleAspectFit
            
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailVC") as! DetailViewController
        detailController.sentMemes = self.sentMemes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    // Gets Meme Editor View Controller.
    @IBAction func newMeme(sender: UIBarButtonItem) {
        let storyboard = self.storyboard
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorVC") as! ViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
        
        
}

