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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEditNavBarButton()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        toggleBottomBar(hidden: false)
    }
    
    func setViewElement(meme: Meme) {
        memeViewer.image = meme.memedImage

        // show datetime if it's set in model.
        if meme.sentDate == nil {
            sentDate.hidden = true
        } else {
            sentDate.hidden = false
            sentDate.text = "Sent at: \(meme.sentAt!)"
        }
    }
    
    func setEditNavBarButton() {
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: Selector("editMeme:"))
        navigationItem.rightBarButtonItem = editButton
    }
    
    @IBAction func editMeme(sender: AnyObject) {
        super.launchMemeEditor(meme!)
    }
}
