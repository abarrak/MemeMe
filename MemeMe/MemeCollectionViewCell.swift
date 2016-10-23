//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Abdullah on 10/21/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memeImage: UIImageView!

    func setMeme(image: UIImage) {
        memeImage.image = image
    }
}
