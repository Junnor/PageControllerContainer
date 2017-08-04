//
//  ViewController.swift
//  PageControllerContainer
//
//  Created by nyato on 2017/8/3.
//  Copyright © 2017年 nyato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var containerController: PageContainerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        containerController = PageContainerController()
        containerController.imagesName = ["login0", "login1", "login2"]
        containerController.pagesTitle = ["Page 0", "Page 1", "Page 2"]
        
        containerController.delegate = self
                
        addChildViewController(containerController)
        var frame = UIScreen.main.bounds
        frame.origin.y = 64
        frame.size.height = 300
        containerController.view.frame = frame
        view.addSubview(containerController.view)
        containerController.didMove(toParentViewController: self)
    }
    
}

// MARK: - pageContainer delegate

extension ViewController: PageContainerControllerDelegate {
    
    func pageContainerController(_ controller: PageContainerController, didSelectedAt page: Int) {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.white
        vc.title = "\(page)"
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

