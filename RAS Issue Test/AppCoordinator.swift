//
//  AppCoordinator.swift
//  RAS Issue Test
//
//  Created by Anthony Beard on 2018/01/11.
//  Copyright © 2018 Anthony Beard. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class AppCoordinator {
    let rootViewCon: UIViewController
    private let startProperty = MutableProperty(())
    private var issueCoordinator: IssueCoordinator!
    init(withRootViewCon rootViewCon: UIViewController) {
        self.rootViewCon = rootViewCon
        
        let rootViewConReadySignal = rootViewCon.reactive.signal(for: #selector(UIViewController.viewDidAppear(_:)))
            .take(first: 1)
            .map { _ in () }
        
        Signal.zip(
            rootViewConReadySignal,
            self.startProperty.signal
        )
            .take(first: 1)
            .map { _, _ in () }
            .observeValues { [unowned self] _ in
                self.openIssueScreen()
        }
    }
    
    func start() {
        self.startProperty.value = ()
    }
    
    private func openIssueScreen() {
        self.issueCoordinator = IssueCoordinator()
        self.issueCoordinator.containerViewCon = self.rootViewCon
        self.issueCoordinator.start()
    }
}
