//
//  SecondViewController.swift
//  EvolveSwift
//
//  Created by Steve Schaeffer on 2/9/16.
//  Copyright © 2016 Zach Fuller. All rights reserved.
//

import UIKit
import Photos
import CoreGraphics

class SecondViewController: UIViewController, Dimmable {
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        dim(.in, alpha: dimLevel, speed: dimSpeed)
        let barViewControllers = self.tabBarController?.viewControllers
        let svc = barViewControllers![0] as! FirstViewController
        let imgs = svc.imgArray
        let itemToAdd = segue.destination as! ModalViewController
        itemToAdd.imgArray = imgs
        
    }
    
    @IBAction func unwindFromSecondary(_ segue: UIStoryboardSegue) {
        dim(.out, speed: dimSpeed)
    }

    //weak var svc: UIViewController!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var splitButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        startButton.setBackgroundImage(Color.imageWithColor(UIColorFromRGB(0x96bee6)), for: .highlighted)
        splitButton.setBackgroundImage(Color.imageWithColor(UIColorFromRGB(0x96bee6)), for: .highlighted)
        loadButton.setBackgroundImage(Color.imageWithColor(UIColorFromRGB(0x96bee6)), for: .highlighted)
        playButton.setBackgroundImage(Color.imageWithColor(UIColorFromRGB(0x96bee6)), for: .highlighted)
        
        startButton.layer.borderWidth = 0.75
        startButton.layer.borderColor = UIColor.gray.cgColor
    
        splitButton.layer.borderWidth = 0.75
        splitButton.layer.borderColor = UIColor.gray.cgColor
        
        loadButton.layer.borderWidth = 0.75
        loadButton.layer.borderColor = UIColor.gray.cgColor
        
        playButton.layer.borderWidth = 0.75
        playButton.layer.borderColor = UIColor.gray.cgColor
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var menuView: UIView!
    @IBAction func startButton(_ sender: AnyObject) {
        
        let barViewControllers = self.tabBarController?.viewControllers
        let svc = barViewControllers![0] as! FirstViewController
        
        svc.view.isUserInteractionEnabled = true
        svc.loadLabel.text = ""
        
        let padNum = 1
        svc.padNum = padNum
        svc.tempImageView.image = UIImage(named:"loadImage_EV-01.png")
        svc.numLabel.text = "iPad No.: \(1)"
        
        svc.imgArray = []
        
    }

    @IBAction func splitButton(_ sender: AnyObject) {

        let barViewControllers = self.tabBarController?.viewControllers
        let svc = barViewControllers![0] as! FirstViewController
        if let currentImage = svc.tempImageView.image{
            let controller: UIActivityViewController = UIActivityViewController(activityItems: [currentImage], applicationActivities: nil)
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
                self.present(controller, animated: true, completion: nil)
            }
            else {
                controller.popoverPresentationController?.sourceView = self.menuView
                controller.popoverPresentationController?.sourceRect = self.menuView.bounds
                controller.modalPresentationStyle = UIModalPresentationStyle.popover
                self.present(controller, animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func playButton(_ sender: UIButton) {


    }


    @IBAction func loadButton(_ sender: AnyObject) {

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        if let lastAsset: PHAsset = fetchResult.lastObject{
            let manager = PHImageManager.default()
            let imageRequestOptions = PHImageRequestOptions()
            
            manager.requestImageData(for: lastAsset, options: imageRequestOptions) {
                (imageData: Data?, dataUTI: String?,
                orientation: UIImageOrientation,
                info: [AnyHashable: Any]?) -> Void in
                
                if let imageDataUnwrapped = imageData, let lastImageRetrieved = UIImage(data: imageDataUnwrapped) {
                    let barViewControllers = self.tabBarController?.viewControllers
                    let svc = barViewControllers![0] as! FirstViewController
                    
                    svc.view.isUserInteractionEnabled = true
                    svc.loadLabel.text = ""
                    
                    let lastImageRetrieved = self.convertToGrayScale(UIImage(data: UIImageJPEGRepresentation(lastImageRetrieved, 1.0)!)!)
                    let rawImageRef: CGImage = lastImageRetrieved.cgImage!
                    
                    let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
                    UIGraphicsBeginImageContext(lastImageRetrieved.size);
                    let maskedImageRef=rawImageRef.copy(maskingColorComponents: colorMasking);
                    UIGraphicsGetCurrentContext()?.translateBy(x: 0.0, y: lastImageRetrieved.size.height);
                    UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0);
                    UIGraphicsGetCurrentContext()?.draw(maskedImageRef!, in: CGRect(x: 0, y: 0, width: lastImageRetrieved.size.width, height: lastImageRetrieved.size.height));
                    let result = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();

                    svc.tempImageView.image = result
                    let alert = UIAlertController(title: "Load an Image", message: "Enter the number for this iPad", preferredStyle: .alert)
                    alert.addTextField(configurationHandler: { (textField) -> Void in textField.text = ""})
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                        UIAlertAction in
                        NSLog("Cancel Pressed")
                    })
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        let textField = alert.textFields![0] as UITextField
                        let padNum = Int(textField.text!)!
                        svc.padNum = padNum
                        svc.numLabel.text = "iPad No.: \(padNum)"
                        print("Text field: \(padNum)")
                        let file = svc.file
                        let output_text = "LoadImage"
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }
    
    func convertToGrayScale(_ image: UIImage) -> UIImage {
        let imageRect:CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.draw(image.cgImage!, in: imageRect)
        let imageRef = context?.makeImage()
        let newImage = UIImage(cgImage: imageRef!)
        
        return newImage
    }
    func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

class Color {
    class func imageWithColor(_ color: UIColor, size: CGSize = CGSize(width: 60, height: 60)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor);
        context?.fill(rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        return image!;
    }
    

}


