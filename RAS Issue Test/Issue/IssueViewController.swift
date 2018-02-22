//
//  TestViewController.swift
//  RAS Issue Test
//
//  Created by Anthony Beard on 2018/01/11.
//  Copyright © 2018 Anthony Beard. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class IssueViewController: UIViewController {
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    private let loadDataProperty = MutableProperty(())
    func loadData() {
        self.loadDataProperty.value = ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let count = MutableProperty(0)
        countLabel.reactive.text <~ count.producer.map(String.init)
            .throttle(0.2, on: QueueScheduler.main)

        self.loadingLabel.text = "Loading..."
        self.loadingLabel.reactive.text <~ self.loadDataProperty.signal
            .flatMap(.latest) { SignalProducer<Date, NoError>.timer(interval: .milliseconds(1), on: QueueScheduler()).scan(0) { counter, _ in counter + 1 } }
            .flatMap(.concat) { index -> SignalProducer<String, NoError> in
                return SignalProducer.zip(
                    ApiManager.shared.getDataA(), // Sometimes terminates without values
                    ApiManager.shared.getDataC(), // Sometimes terminates without values
                    ApiManager.shared.getDataB() // Sometimes terminates without values
                )
                .map { _, _, _ in
                    count.modify { $0 += 1 }
                    return "Loaded \(index)!"
                }
                .on(starting: { precondition(count.value == index - 1) })
                .prefix(value: "Loading \(index)!")
            }
            .throttle(0.2, on: QueueScheduler.main)
            .on(disposed: { self.tabBarItem.badgeValue = "1" })
    }
}
