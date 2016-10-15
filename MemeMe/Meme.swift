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
    
    var topText: String
    var bottomText: String
    var original: UIImage
    var memed: UIImage
    
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.original = image
        self.memed = memedImage
    }
}