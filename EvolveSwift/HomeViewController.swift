//
//  HomeViewController.swift
//  EvolveSwift
//
//  Created by Steve Schaeffer on 3/21/16.
//  Copyright © 2016 Zach Fuller. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let homeViewController = segue.destination as? HomePageController {
            homeViewController.homeDelegate = self
        }
    }

}

extension HomeViewController: HomePageControllerDelegate {
    
    func pageViewController(_ pageViewController: HomePageController,
        didUpdatePageCount count: Int) {
            pageControl.numberOfPages = count
            NSLog("\(count)")
    }
    
    func pageViewController(_ pageViewController: HomePageController,
        didUpdatePageIndex index: Int) {
            pageControl.currentPage = index
    }
    
}
