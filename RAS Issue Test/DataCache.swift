//
//  DataCache.swift
//  RAS Issue Test
//
//  Created by Anthony Beard on 2018/01/11.
//  Copyright © 2018 Anthony Beard. All rights reserved.
//

import UIKit

class DataCache {
    static let shared = DataCache()
    private var myDataCache = [MyData]()
    private init() {
        for _ in 1 ... 10 {
            self.myDataCache.append(MyData())
        }
    }
    
    func randomDataItem() -> MyData {
        let maxIndex = self.myDataCache.count - 1
        return self.myDataCache[Int.randomIntFrom(start: 0, to: maxIndex)]
    }
}

// https://supereasyapps.com/blog/2016/3/11/how-to-create-a-random-int-number-in-swift-2-swift-tips-7
fileprivate extension Int {
    static func randomIntFrom(start: Int, to end: Int) -> Int {
        var a = start
        var b = end
        
        if a > b {
            swap(&a, &b)
        }
        return Int(arc4random_uniform(UInt32(b - a + 1))) + a
    }
}
