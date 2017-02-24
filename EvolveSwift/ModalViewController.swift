//
//  ModalViewController.swift
//  EvolveSwift
//
//  Created by Steve Schaeffer on 3/25/16.
//  Copyright © 2016 Zach Fuller. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import Photos

class ModalViewController: UIViewController{
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var mainImage: UIImageView!
    var imgArray: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popupView.layer.cornerRadius = 10
        self.popupView.clipsToBounds = true
        popupView.layer.borderColor = UIColor.black.cgColor
        popupView.layer.borderWidth = 0.25
        popupView.layer.shadowColor = UIColor.black.cgColor
        //popupView.layer.shadowOpacity = 0.6
        popupView.layer.shadowRadius = 15
        popupView.layer.shadowOffset = CGSize(width: 5, height: 5)
        popupView.layer.masksToBounds = false
        
        let arrayCount = Double(imgArray.count)
        let animDuration = arrayCount * 0.25
        mainImage.image = UIImage.animatedImage(with: imgArray, duration: animDuration)
        
    }
}
