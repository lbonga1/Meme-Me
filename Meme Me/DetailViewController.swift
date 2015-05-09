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
    
    // Global variable
    var sentMemes: Meme!
    
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
    
        
    
    
}
