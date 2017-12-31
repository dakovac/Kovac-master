//
//  PhotoUploadViewController.swift
//  KovacAdvisory
//
//  Created by Shivam on 18/05/17.
//  Copyright © 2017 Shivam Singh. All rights reserved.
//

import UIKit
import MediaPlayer
import CoreMedia
import SCLAlertView

class PhotoUploadViewController: UIViewController, UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UINavigationControllerDelegate{
    var transferDict = NSMutableDictionary()
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var takePhotoBtn: UIButton!
    
    var picker = UIImagePickerController()
    
    @IBAction func backAction(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func takePhotoAction(_ sender: UIButton) {
        if sender.currentTitle == "TAKE PHOTO" {
            let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            
            if authStatus == AVAuthorizationStatus.denied {
                let dialog = UIAlertController(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app.", preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                
                dialog.addAction(okAction)
                self.present(dialog, animated:true, completion:nil)
                
            } else if authStatus == AVAuthorizationStatus.notDetermined {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (grantd) in
                    if grantd {
                        self.showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType.camera)
                    }
                })
            } else {
                self.showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType.camera)
            }
        } else {
            let imageData = UIImageJPEGRepresentation(self.imageView.image!,0.01)
            let imageStr = imageData?.base64EncodedString()
            
            transferDict.setValue(imageStr, forKey:"emp_identification")
            
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alertView = SCLAlertView(appearance: appearance)
            
            alertView.showWait("Kovac Smart Super", subTitle: "Please wait while we submit your details", duration: 9)
            
            transferDict.setValue("Yes", forKey:"emp_disclaimer")
            transferDict.setValue("1", forKey:"new")
            
            let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
            
            activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            activityIndicatorView.startAnimating()
            self.view.addSubview(activityIndicatorView)
            
            do {
                
                let dataStr = try JSONSerialization.data(withJSONObject: transferDict, options:  JSONSerialization.WritingOptions(rawValue: 0))
                
                var verifyStr = NSString.init(data: dataStr, encoding: String.Encoding.utf8.rawValue)
                verifyStr = verifyStr!.replacingOccurrences(of: ":", with: "=") as NSString?
                verifyStr = verifyStr!.replacingOccurrences(of: ",", with: "&") as NSString?
                verifyStr = verifyStr!.replacingOccurrences(of: "\"", with: "") as NSString?
                verifyStr = verifyStr!.replacingOccurrences(of: "{", with: "") as NSString?
                verifyStr = verifyStr!.replacingOccurrences(of: "}", with: "") as NSString?
                verifyStr = verifyStr!.replacingOccurrences(of: "/", with: "%2F") as NSString?
                verifyStr = verifyStr!.replacingOccurrences(of: " ", with: "%20") as NSString?
                
                var request = URLRequest(url: URL(string: "https://kovacadvisory.com.au/api/rest/user")!)
                request.httpMethod = "POST"
                let postData = verifyStr!.data(using: String.Encoding.nonLossyASCII.rawValue, allowLossyConversion: false)!
                let postLength = "\(postData.count)"
                request.setValue(postLength, forHTTPHeaderField: "Content-Length")
                request.httpBody = postData
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print("error=\(error)")
                        return
                    }
                    activityIndicatorView.stopAnimating()
                    activityIndicatorView.isHidden = true
                    activityIndicatorView.removeFromSuperview()
                    
                    if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                    }
                    
                    let responseString = String(data: data, encoding: .utf8)
                    print("responseString = \(responseString!)")
                    
                    DispatchQueue.main.async {
                        print(self.transferDict)
                        
                        UserDefaults.standard.removeObject(forKey: "halfForm")
                        UserDefaults.standard.removeObject(forKey: "transferDict")
                        
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let personalViewController = mainStoryboard.instantiateViewController(withIdentifier: "SubmittedViewController") as! SubmittedViewController
                        personalViewController.userID = String(describing: self.transferDict["userid"]!)
                        
                        self.navigationController?.pushViewController(personalViewController, animated: true)
                    }
                    
                }
                task.resume()
                
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = sourceType
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = chosenImage
        takePhotoBtn.setTitle("SUBMIT", for: UIControlState.normal)
        deleteBtn.isHidden = false
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        self.imageView.image = UIImage(named:"placeholder")!
        self.takePhotoBtn.setTitle("TAKE PHOTO", for: UIControlState.normal)
        deleteBtn.isHidden = true
    }
}
