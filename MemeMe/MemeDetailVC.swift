//
//  MemeDetailVC.swift
//  MemeMe
//
//  Created by Abdullah on 10/21/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import UIKit

class MemeDetailVC: UIViewController {
    
    var meme: Meme?
    
    @IBOutlet weak var sentDate: UILabel!
    @IBOutlet weak var memeViewer: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let m = meme {
            setViewElement(m)
        }
        toggleBottomBar(hidden: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        toggleBottomBar(hidden: false)
    }
    
    func setViewElement(meme: Meme) {
        sentDate.text = "Sent at: \(1 + 1)"
        memeViewer.image = meme.memedImage
    }
}
