//
//  FirstViewController.swift
//  EvolveSwift
//
//  Created by Steve Schaeffer on 2/9/16.
//  Copyright © 2016 Zach Fuller. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class FirstViewController: UIViewController {


    @IBOutlet weak var mainImageView: UIImageView!

    @IBOutlet weak var tempImageView: UIImageView!

    @IBOutlet var backImageView: UIImageView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var loadLabel: UILabel!

    var lastPoint:CGPoint!
    var isSwiping:Bool!
    var red:CGFloat!
    var green:CGFloat!
    var blue:CGFloat!
    
    var inputTextField: UITextField!
    var padNum = 0
    var imgArray: [UIImage] = []
    var nameArray: [String] = []
    
    var dupCounter = Int(2)
    var finalUserName: String = ""
    
    let file = "fileNames.txt"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        red   = (51.0/255.0)
        green = (204.0/255.0)
        blue  = (255.0/255.0)
        self.roundingUIView(self.mainImageView, cornerRadiusParam: 10)
        self.roundingUIView(self.tempImageView, cornerRadiusParam: 10)
        self.tempImageView.layer.borderColor = UIColor.gray.cgColor
        self.tempImageView.layer.borderWidth = 1.0
        self.backImageView.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
        
        
        if let dir : NSString = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first! as NSString) {
            let path = dir.appendingPathComponent(self.file);
            do {
                let text = ""
                try text.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch let error as NSError {
                NSLog("Something went wrong: \(error)")
            }
        }
 


    }

    fileprivate func roundingUIView(_ aView: UIView!, cornerRadiusParam: CGFloat!) {
        aView.clipsToBounds = true
        aView.layer.cornerRadius = cornerRadiusParam
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func touchesBegan(_ touches: Set<UITouch>,
        with event: UIEvent?){
            isSwiping    = false
            if let touch = touches.first {
                lastPoint = touch.location(in: mainImageView)
            }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>,
        with event: UIEvent?){
            
            isSwiping = true;
            if let touch = touches.first {
                let currentPoint = touch.location(in: mainImageView)
                UIGraphicsBeginImageContext(self.mainImageView.frame.size)
                self.mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.mainImageView.frame.size.width, height: self.mainImageView.frame.size.height))
                UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
                UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: currentPoint.x, y: currentPoint.y))
                UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
                UIGraphicsGetCurrentContext()?.setLineWidth(9.0)
                UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
                UIGraphicsGetCurrentContext()?.strokePath()
                self.mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                lastPoint = currentPoint
            }


            
    }

    override func touchesEnded(_ touches: Set<UITouch>,
        with event: UIEvent?){
            if(!isSwiping) {
                UIGraphicsBeginImageContext(self.mainImageView.frame.size)
                self.mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.mainImageView.frame.size.width, height: self.mainImageView.frame.size.height))
                UIGraphicsGetCurrentContext()?.setLineCap(CGLineCap.round)
                UIGraphicsGetCurrentContext()?.setLineWidth(9.0)
                UIGraphicsGetCurrentContext()?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
                UIGraphicsGetCurrentContext()?.move(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
                UIGraphicsGetCurrentContext()?.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
                UIGraphicsGetCurrentContext()?.strokePath()
                self.mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
            }
        
            if let touch = touches.first {
                if mainImageView.bounds.contains(touch.location(in: mainImageView)){
                    
                    // Create the alert controller
                    let alertController = UIAlertController(title: "Finished?", message: "Is this your attempt?", preferredStyle: .alert)
                    
                    // Create the actions
                    let okAction = UIAlertAction(title: "Yes, save", style: UIAlertActionStyle.default) {
                        
                        UIAlertAction in
                        NSLog("OK Pressed")

                        if let image = self.mainImageView.image{
 
                            var userName = String(self.inputTextField.text!)
                            if self.nameArray.contains(userName!){
                                NSLog("Name Exists!")
                                
                                userName = (userName! + "-" + "\(self.dupCounter)" )
                                self.dupCounter += 1
                            }
                            self.nameArray.append(userName!)
                            let imgText = String(self.padNum) + "-" + userName!
                            NSLog("\(userName)")
                            self.finalUserName = imgText

                            UIImageWriteToSavedPhotosAlbum(image,self,#selector(FirstViewController.image(_:withPotentialError:contextInfo:)),nil)


                        }
                    }
                    let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
                        UIAlertAction in
                        NSLog("Cancel Pressed")
                        self.mainImageView.image = nil
                    }
                    
                    alertController.addTextField { (textField : UITextField!) -> Void in
                        textField.placeholder = "Enter User Name"
                        self.inputTextField = textField

                    }
                    
                    // Add the actions
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
                }
            }
    }
    
    func textToImage(_ drawText: NSString, inImage: UIImage, atPoint:CGPoint)->UIImage{
        
        let textColor: UIColor = UIColor.black
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 24)!

        UIGraphicsBeginImageContext(inImage.size)

        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        let rect: CGRect = CGRect(x: atPoint.x, y: atPoint.y, width: inImage.size.width, height: inImage.size.height)
        
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return newImage
        
    }

    func image(_ image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {

        self.nameArray.append(String(self.inputTextField.text!))
        let alertController = UIAlertController(title: "Success!", message:"Your User Name Is: \(self.finalUserName)", preferredStyle: .alert)
        
        let nextGenAction = UIAlertAction(title: "Go To The Next Generation", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.tempImageView.image = self.mainImageView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            self.tempImageView.tintColor = UIColor.gray
            self.mainImageView.image = nil
            self.imgArray.append(self.tempImageView.image!)
        }
        alertController.addAction(nextGenAction)
        
        let imgText = String(self.padNum) + "-" + String(self.inputTextField.text!)
        
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
                
                if let imageDataUnwrapped = imageData, let _ = UIImage(data: imageDataUnwrapped) {
                    
                    let urlkey = info!["PHImageFileURLKey"] as? URL
                    let output_text = String(imgText) + "\t" + String(describing: urlkey!) + "\n"
                    
                    if let dir : NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first as NSString? {
                        let path = dir.appendingPathComponent(self.file);
                        let file: FileHandle? = FileHandle(forUpdatingAtPath: path)
                        
                        if file == nil {
                            NSLog("File open failed")
                        }
                        else{
                            let data = (output_text as NSString).data(using: String.Encoding.utf8.rawValue)
                            file?.seekToEndOfFile()
                            file?.write(data!)
                            file?.closeFile()
                        }
                        
                        
                    }
                    
                }
            }
        }
        self.present(alertController, animated: true){}

    }
    
    
}



