//
//  SentMemesCollectionVC.swift
//  MemeMe
//
//  Created by Abdullah on 10/21/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import UIKit

class SentMemesCollectionVC: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setFlowLayout()
        collectionView?.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setFlowLayout() {
        let interSpace: CGFloat = 3.0
        let lineSpace: CGFloat = 8.0
        let dimension = (view.frame.size.width - (2 * interSpace)) / 3.0

        flowLayout.minimumInteritemSpacing = interSpace
        flowLayout.minimumLineSpacing = lineSpace
        flowLayout.itemSize = CGSizeMake(dimension, dimension)

        // flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }

    // MARK: Table View Data Source
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionMemeCell", forIndexPath: indexPath) as! CustomCollectionMemeCell
        
        let meme = memes[indexPath.item]
        cell.setMeme(meme.memedImage)
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Grab the MemeDetailVC from Storyboard.
        let memeDetailVC = storyboard?.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetailVC
        
        // Populate view controller with data from the selected item.
        memeDetailVC.meme = memes[indexPath.row]
        
        // Present the view controller using navigation.
        navigationController!.pushViewController(memeDetailVC, animated: true)
    }
}