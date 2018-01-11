//
//  ViewController.swift
//  RAS Issue Test
//
//  Created by Anthony Beard on 2018/01/11.
//  Copyright © 2018 Anthony Beard. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class ViewController: UIViewController {
    @IBOutlet weak var loadingLabel: UILabel!
    
    private let loadData = MutableProperty(())
    override func viewDidLoad() {
        self.loadingLabel.text = "Loading..."
        self.loadingLabel.reactive.text <~ self.loadData.signal
            .flatMap(.latest) { () -> SignalProducer<([MyData], [MyData], [MyData]), NoError> in
                return SignalProducer.zip(
                    ApiManager.shared.getDataA(), // Sometimes terminates without values
                    ApiManager.shared.getDataB(), // Sometimes terminates without values
                    ApiManager.shared.getDataC() // Sometimes terminates without values
                )
            }
            .map { _, _, _ in
                return "Loaded!"
        }
        
        self.loadData.value = ()
    }
}

