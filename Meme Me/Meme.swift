//  Meme.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 4/30/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import Foundation
import UIKit


struct Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage

    
    init (topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}