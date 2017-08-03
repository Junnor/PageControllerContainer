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
        
        print("ViewController viewDidLoad\n")
        automaticallyAdjustsScrollViewInsets = false
        
        containerController = PageContainerController()
        containerController.imagesName = ["login0", "login1", "login2"]
        containerController.pagesTitle = ["Page 0", "Page 1", "Page 2"]
        
        containerController.delegate = self
        
//        containerController.useTimerAnimation = false
        
        addChildViewController(containerController)
        let bounds = UIScreen.main.bounds
        containerController.view.frame = CGRect(x: 0, y: 100, width: bounds.width, height: 300)
        view.addSubview(containerController.view)
        containerController.didMove(toParentViewController: self)
    }
    
}

extension ViewController: PageContainerControllerDelegate {
    
    func pageContainerController(_ controller: PageContainerController, didSelectedAt page: Int) {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.white
        vc.title = "\(page)"
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

