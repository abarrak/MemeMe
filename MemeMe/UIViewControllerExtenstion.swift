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
        self.tabBarController!.tabBar.hidden = hidden
    }
}
