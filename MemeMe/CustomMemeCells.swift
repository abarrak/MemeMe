//
//  CustomMemeCells.swift
//  MemeMe
//
//  Created by Abdullah on 10/21/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import UIKit

class CustomCollectionMemeCell: UICollectionViewCell {
    
    func setText(labelText: String) {
        
    }
}


class CustomTableMemeCell : UITableViewCell {
    
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    func setTexts(top: String, bottom: String) {
        topLabel.text = top
        bottomLabel.text = bottom
    }
    
    func setMeme(image: UIImage) {
        memeImage.image = image
    }
}