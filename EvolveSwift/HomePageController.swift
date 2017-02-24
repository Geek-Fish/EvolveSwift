//
//  HomePageController.swift
//  EvolveSwift
//
//  Created by Steve Schaeffer on 3/21/16.
//  Copyright © 2016 Zach Fuller. All rights reserved.
//

import UIKit

class HomePageController: UIPageViewController {
    
    weak var homeDelegate: HomePageControllerDelegate?
    
    fileprivate(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController("1"),
            self.newColoredViewController("2")
            ]
    }()
    
    fileprivate func newColoredViewController(_ number: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "HomeScreen\(number)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        homeDelegate?.pageViewController(self, didUpdatePageCount: orderedViewControllers.count)
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                direction: .forward,
                animated: true,
                completion: nil)
        }
    }
    
}

// MARK: UIPageViewControllerDataSource

extension HomePageController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
                return nil
            }
            NSLog("\(viewControllerIndex)")
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }
            
            return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = orderedViewControllers.count
            
            guard orderedViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
            
            return orderedViewControllers[nextIndex]
    }

    
}

extension HomePageController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
            if let firstViewController = viewControllers?.first,
                let index = orderedViewControllers.index(of: firstViewController) {
                    homeDelegate?.pageViewController(self,
                        didUpdatePageIndex: index)
            }
    }
    
}

protocol HomePageControllerDelegate: class {
    
    /**
     Called when the number of pages is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func pageViewController(_ pageViewController: HomePageController,
        didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     
     - parameter tutorialPageViewController: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func pageViewController(_ pageViewController: HomePageController,
        didUpdatePageIndex index: Int)
    
}
