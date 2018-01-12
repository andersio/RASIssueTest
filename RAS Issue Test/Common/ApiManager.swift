//
//  ApiManager.swift
//  RAS Issue Test
//
//  Created by Anthony Beard on 2018/01/11.
//  Copyright © 2018 Anthony Beard. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class ApiManager {
    static let shared = ApiManager()
    private init() {}
    
    private let scheduler = QueueScheduler(qos: .utility, name: "MyProject.ApiManager")
    
    func getDataA() -> SignalProducer<[MyData], NoError> {
        return self.mockGetData(count: 1, delay: 0)
    }
    func getDataB() -> SignalProducer<[MyData], NoError> {
        return self.mockGetData(count: 2, delay: 0)
    }
    func getDataC() -> SignalProducer<[MyData], NoError> {
        return self.mockGetData(count: 3, delay: 0)
    }
    
    private func mockGetData(count: Int, delay: TimeInterval) -> SignalProducer<[MyData], NoError> {
        return SignalProducer<[MyData], NoError> { observer, lifetime in
            var dataItems = [MyData]()
            
            for _ in 1 ... count {
                let myData = DataCache.shared.randomDataItem()
                dataItems.append(myData)
            }
            
            observer.send(value: dataItems)
            observer.sendCompleted()
            }
            .delay(delay, on: self.scheduler)
    }
}
