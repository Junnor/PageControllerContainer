//
//  PageContainerController.swift
//  PageControllerContainer
//
//  Created by nyato on 2017/8/3.
//  Copyright © 2017年 nyato. All rights reserved.
//

import UIKit

protocol PageContainerControllerDelegate: class {
    func pageContainerController(_ controller: PageContainerController, didSelectedAt page: Int)
}

class PageContainerController: UIViewController {
    
    
    // MARK: - Public
    var allowedRecursive = true
    var useTimerAnimation = true
    var hidePageController = false

    var imagesName: [String] = []
    var pagesTitle: [String] = []
    
    weak var delegate: PageContainerControllerDelegate?

    // MARK: Private
    
    private var pageViewController: PageViewController!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = PageViewController()
        pageViewController.delegate = self
        
        pageViewController.allowedRecursive = self.allowedRecursive
        pageViewController.hidePageController = self.hidePageController
        pageViewController.useTimerAnimation = self.useTimerAnimation
        
        pageViewController.setData((imagesName, pagesTitle))

        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
    }
        
}

// MARK: - pageView delegate

extension PageContainerController: PageViewControllerDelegate {
    func pageViewController(_ pageViewController: PageViewController, didSelectedAt page: Int) {
        delegate?.pageContainerController(self, didSelectedAt: page)
    }
}
