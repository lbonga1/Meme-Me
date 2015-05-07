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
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    // Global variable
    var sentMemes: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.topLabel.text = self.sentMemes.topText
        self.bottomLabel.text = self.sentMemes.bottomText
        
        self.tabBarController?.tabBar.hidden = true
        
        self.memeImageDetail!.image = self.sentMemes.memedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
        
    
    
}
