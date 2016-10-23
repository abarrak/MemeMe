//
//  Meme.swift
//  MemeMe
//
//  Created by Abdullah on 10/14/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import Foundation
import UIKit

struct Meme {    
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
    let sentDate: NSDate?
    
    // Property for string representation of the sentDate value, if any.
    var sentAt: String? {
        if let date = sentDate {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM dd, yyyy h:mm a"
            formatter.AMSymbol = "AM"
            formatter.PMSymbol = "PM"
            return formatter.stringFromDate(date)
        } else {
            return nil
        }
    }
}