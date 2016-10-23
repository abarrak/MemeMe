//
//  UIViewControllerExtenstion.swift
//  MemeMe
//
//  Created by Abdullah on 10/22/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func toggleBottomBar(hidden hidden: Bool) {
        tabBarController!.tabBar.hidden = hidden
    }
    
    func launchMemeViewer(meme: Meme) {
        // Grab MemeDetailVC from Storyboard.
        let memeDetailVC = storyboard?.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetailVC
        
        // Populate view controller with data.
        memeDetailVC.meme = meme
        
        // Present the view controller using navigation.
        navigationController!.pushViewController(memeDetailVC, animated: true)
    }
    
    func launchMemeEditor(meme: Meme) {
        // Get MemeEditorVC from Storyboard, set modal appearance.
        let memeEditorVC = storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as! MemeEditorVC
        memeEditorVC.modalPresentationStyle = .OverCurrentContext
        
        // Set model for view controller.
        memeEditorVC.memeModel = meme
        
        // Present view controller modally.
        navigationController?.presentViewController(memeEditorVC, animated: true, completion: nil)
    }
}
