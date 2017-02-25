//  Meme.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 4/30/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import Foundation
import UIKit

// Overload == function to utilize .find method
func == (lhs: Meme, rhs: Meme) -> Bool {
    if lhs.topText == rhs.topText &&
        lhs.bottomText == rhs.bottomText &&
        lhs.originalImage == rhs.originalImage &&
        lhs.memedImage == rhs.memedImage {
            return true
    }
    return false
}

// Make Meme struct equatable to utilize .find method
struct Meme: Equatable {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
}
