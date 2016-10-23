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
    
    // MARK: Table View Data Source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableMemeCell") as! CustomTableMemeCell
        let meme = memes[indexPath.row]

        // Set meme's titles and image.
        cell.setTexts(meme.topText, bottom: meme.bottomText)
        cell.setMeme(meme.memedImage)
        
        return cell
    }
        
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.launchMemeViewer(memes[indexPath.row])
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            tableView.beginUpdates()
            deleteMeme(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            tableView.endUpdates()
        }
    }
    
    func deleteMeme(index: Int) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.removeAtIndex(index)
    }
}
