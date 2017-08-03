//
//  PageViewController.swift
//  PageControllerContainer
//
//  Created by nyato on 2017/8/3.
//  Copyright © 2017年 nyato. All rights reserved.
//

import UIKit

protocol PageViewControllerDelegate: class {
    func pageViewController(_ pageViewController: PageViewController, didSelectedAt page: Int)
}

class PageViewController: UIViewController {
    
    // MARK: Public
    weak var delegate: PageViewControllerDelegate?

    var allowedRecursive = true
    var hidePageController = true
    var useTimerAnimation = true
    
    func setData(_ data: (imagesName: [String], pagesTitle: [String])) {  
        
        self.imagesName = data.imagesName
        self.pagesTitle = data.pagesTitle
    }
    
    // MARK: Private
    fileprivate var imagesName: [String] = []
    fileprivate var pagesTitle: [String] = []
    
    private var pageViewController: UIPageViewController!
    fileprivate var pageController: UIPageControl!
    
    private var pageControllerHeight: CGFloat = 50
    private var lastPageIndex = 0
    fileprivate var numberOfPage = 0
        
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("PageViewController viewDidLoad\n")
        
        
        pageControllerHeight = 50
        lastPageIndex = 0
    }
    
    
    private var addedSubView = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !addedSubView {
            
            print("PageViewController viewDidAppear\n")

            addedSubView = true
            
            
            setPageViewController()
            setPageController()
            
            if useTimerAnimation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    Timer.scheduledTimer(timeInterval: 3.0,
                                         target: self,
                                         selector: #selector(self.scrollToNextController),
                                         userInfo: nil,
                                         repeats: true)
                })
            }
        }
        
    }

    
    // MARK: Helper
    
    private func setPageViewController() {
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        numberOfPage = imagesName.count
        
        let startingContentViewController = contentViewController(at: 0)
        let viewControllers = [startingContentViewController!]

        pageViewController.setViewControllers(viewControllers,
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
        
        pageViewController.view.frame = view.bounds
        
        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
    }
    
    private func setPageController() {
        
        var frame = view.bounds
        frame.origin.y = frame.height - 50
        frame.size.height = 50
        pageController = UIPageControl(frame: frame)
        pageController.numberOfPages = imagesName.count

        pageController.pageIndicatorTintColor = UIColor.lightGray
        pageController.currentPageIndicatorTintColor = UIColor.black
        
        pageController.addTarget(self, action: #selector(valueChangeAction), for: .valueChanged)
        
        view.addSubview(pageController)
        view.bringSubview(toFront: pageController)
    }
    
    @objc private func scrollToNextController() {

        var index = pageController.currentPage
        let num = numberOfPage
        
        if index >= (num - 1) {
            index = 0
        } else {
            index += 1
        }
        
        pageController.currentPage = index
        lastPageIndex = index
        
        let vc = [contentViewController(at: index)!]
        pageViewController.setViewControllers(vc,
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
    }

    
    @objc private func valueChangeAction() {
        let vc = contentViewController(at: pageController.currentPage)
        let viewControllers = [vc!]
        let direction: UIPageViewControllerNavigationDirection = pageController.currentPage > lastPageIndex ? .forward : .reverse
        
        lastPageIndex = pageController.currentPage
        
        pageViewController.setViewControllers(viewControllers,
                                              direction: direction,
                                              animated: true,
                                              completion: nil)
    }
    
    func contentViewController(at index: Int) -> UIViewController? {
        if numberOfPage == 0 || index >= numberOfPage {
            return nil
        }
        
        let contentViewControllr = PageContentViewController() // TODO: replace init
        contentViewControllr.delegate = self
        
        contentViewControllr.pageIndex = index
        contentViewControllr.imageFile = imagesName[index]
        contentViewControllr.pageTitle = pagesTitle[index]
        
        // TODO: set data someday
        
        return contentViewControllr
    }

}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let vc = viewController as? PageContentViewController {
            var index = vc.pageIndex
            
            if index == NSNotFound { return nil }
            
            if allowedRecursive {
                if index <= 0 {
                    index = numberOfPage - 1
                } else {
                    index -= 1
                }
            } else {
                if index <= 0 {
                    return nil
                } else {
                    index -= 1
                }
            }
            
            return contentViewController(at: index)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let vc = viewController as? PageContentViewController {
            var index = vc.pageIndex
            
            if index == NSNotFound { return nil }
            
            
            // TODO: replce
            if (self.allowedRecursive) {
                if index >= self.numberOfPage - 1 {
                    index = 0
                } else {
                    index += 1
                }
                return contentViewController(at: index)
            } else {
                if index >= self.numberOfPage - 1 {
                    // MARK: TO-DO [Add action, if you want]
                    return nil
                } else {
                    index += 1
                }
                
                return contentViewController(at: index)
            }

        }
        
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        let firstPageContentViewController = pendingViewControllers.first as? PageContentViewController
        
        if firstPageContentViewController != nil {
            let index = firstPageContentViewController!.pageIndex
            pageController.currentPage = index
        }
        
    }
}

extension PageViewController: PageContentViewControllerDelegate {
    func pageContentViewController(_ controller: PageContentViewController, didSelectedAt page: Int) {
        delegate?.pageViewController(self, didSelectedAt: page)
    }
}
