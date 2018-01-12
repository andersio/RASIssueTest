//
//  IssueCoordinator.swift
//  RAS Issue Test
//
//  Created by Anthony Beard on 2018/01/11.
//  Copyright © 2018 Anthony Beard. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class IssueCoordinator {
    var containerViewCon: UIViewController! = nil
    let rootTabBarCon: UITabBarController
    init() {
        self.rootTabBarCon = UIStoryboard(name: "Issue", bundle: nil).instantiateInitialViewController() as! UITabBarController
        
        let issueViewCon = self.rootTabBarCon.viewControllers!.first! as! IssueViewController
        
        issueViewCon.reactive.signal(for: #selector(UIViewController.viewDidAppear(_:)))
            .take(first: 1)
            .observe(on: QueueScheduler.main)
            .observeValues { _ in
                issueViewCon.loadData()
        }
    }
    
    func start() {
        self.containerViewCon.present(self.rootTabBarCon, animated: false, completion: nil)
    }
}
