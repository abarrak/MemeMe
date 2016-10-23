//
//  MemeMeTests.swift
//  MemeMeTests
//
//  Created by Abdullah on 10/12/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import XCTest
@testable import MemeMe

class MemeMeTests: XCTestCase {
    
    func testMemeSentAtWorksOnlyWhenSentDatePresent() {
        let dummy = UIImage(named: "TableIcon")!

        var meme = Meme(topText: "1", bottomText: "2", originalImage: dummy, memedImage: dummy, sentDate: nil)
        assert(meme.sentAt() == nil)
        
        meme = Meme(topText: "1", bottomText: "2", originalImage: dummy, memedImage: dummy, sentDate: NSDate())
        assert(meme.sentAt() != nil)
    }
}
