//  Meme.swift
//  Meme Me
//
//  Created by Lauren Bongartz on 4/30/15.
//  Copyright (c) 2015 Lauren Bongartz. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@objc(Meme)

class Meme: NSManagedObject {
    
    struct Meme {
        static let TopText = "top_text"
        static let bottomText = "bottom_text"
        static let originalImage = "original_image"
        static let memedImage = "memed_image"
    }
    
    @NSManaged var topText: String
    @NSManaged var bottomText: String
    @NSManaged var originalImage: UIImage
    @NSManaged var memedImage: UIImage
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        // Core Data
        let entity =  NSEntityDescription.entityForName("Meme", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Dictionary
        topText = dictionary[Meme.TopText] as! String
        bottomText = dictionary[Meme.bottomText] as! String
        originalImage = dictionary[Meme.originalImage] as! UIImage
        memedImage = dictionary[Meme.memedImage] as! UIImage
    }
}

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