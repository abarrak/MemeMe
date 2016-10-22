//
//  SentMemesTableVC.swift
//  MemeMe
//
//  Created by Abdullah on 10/21/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import UIKit

class SentMemesTableVC: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: Table View Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")!
        let meme = memes[indexPath.row]
        
        // Set memes title and image.
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        
        // If the cell has a detail label, we will set it to bottom text.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.bottomText
        }

        return cell
    }
        
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Grab the MemeDetailVC from Storyboard.
        let memeDetailVC = storyboard?.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetailVC
        
        // Populate view controller with data from the selected item.
        memeDetailVC.meme = memes[indexPath.row]
        
        // Present the view controller using navigation.
        navigationController!.pushViewController(memeDetailVC, animated: true)
    }
}