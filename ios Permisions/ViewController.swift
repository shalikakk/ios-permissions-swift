//
//  ViewController.swift
//  ios Permisions
//
//  Created by shalika lahiru on 8/28/19.
//  Copyright © 2019 shalika lahiru. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var showImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnPicImageClicked(_ sender: Any) {
        chooseAction()
    }
    
    
    func chooseAction(){
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let firstAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            let cameraMediaType = AVMediaType.video
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
            
            switch cameraAuthorizationStatus {
            case .denied:
                self.permitionAlert(message: "Please enable permission from device settings")
                break
                
            case .authorized:
                self.pickImage(pickerSource: "Camera")
                break
                
            case .restricted:break
                
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                    if granted {
                        self.pickImage(pickerSource: "Camera")
                    }
                }
            @unknown default:
                fatalError()
            }
        }
        let secondAction: UIAlertAction = UIAlertAction(title: "Gallery", style: .default) { action -> Void in
            let photosLibrayStatus = PHPhotoLibrary.authorizationStatus()
            print(photosLibrayStatus)
            switch photosLibrayStatus {
            case .denied:
                self.permitionAlert(message: "Please enable permission from device settings")
                break
            case .authorized:
                self.pickImage(pickerSource: "Gallery")
                break
            case .restricted:
                
                break
                
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        self.pickImage(pickerSource: "Gallery")
                    }
                })
            @unknown default:
                fatalError()
            }
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
    }
    
    func pickImage(pickerSource:String){
        let imagerPickerController = UIImagePickerController()
        imagerPickerController.delegate = self
        if pickerSource == "Camera"{
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagerPickerController.sourceType = .camera
                self.present(imagerPickerController, animated: true, completion: nil)
            }
            else{
                Alert(message: "Camera not available")
            }
        }else{
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                imagerPickerController.sourceType = .photoLibrary
                self.present(imagerPickerController, animated: true, completion: nil)
            }
            else{
                Alert(message: "photo Library not available")
            }
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let picImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        showImage.image = picImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func permitionAlert(message:String){
        let alertController = UIAlertController (title: "Alert", message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func Alert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default){
            UIAlertAction in
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

