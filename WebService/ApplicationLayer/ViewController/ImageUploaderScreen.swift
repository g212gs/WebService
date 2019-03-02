//
//  ImageUploaderScreen.swift
//  WebService
//
//  Created by Gaurang Lathiya on 02/03/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import UIKit

class ImageUploaderScreen: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnSelectImage: UIButton!
    
    var assetURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    func setNavigationBar() {
        self.title = "Upload Image"
        
        self.navigationItem.setRightBarButtonItems([], animated: true)
        
        let rightBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(btnUploadClicked))
        rightBarButton.tintColor = UIColor.black
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    // MARK: - Bar Button item click events
    @objc func btnUploadClicked() {
        print("Camera clicked...")
        self.callWebAPI_Image_Upload()
    }
    
    @IBAction func btnSelectImageClicked(_ sender: UIButton) {
         print("Select image clicked...")
        
        DispatchQueue.main.async {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType =
                UIImagePickerController.SourceType.photoLibrary
            self.present(myPickerController, animated: true)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        self.imgView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
        if #available(iOS 11.0, *) {
            if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
//                let imgName = imgUrl.lastPathComponent
//                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
//                let localPath = documentDirectory?.appending(imgName)
//
//                let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//                let data = image.pngData()! as NSData
//                data.write(toFile: localPath!, atomically: true)
//                //let imageData = NSData(contentsOfFile: localPath!)!
//                let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
//                print("photo URL: \(photoURL)")
                
                let imgName = imgUrl.lastPathComponent
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)
                
                let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                let data = image.jpegData(compressionQuality: 0.8)! as NSData
                data.write(toFile: localPath, atomically: true)
                let photoURL = URL.init(fileURLWithPath: localPath)
                print("photo URL: \(photoURL)")
                self.assetURL =  localPath //try! String(contentsOf: photoURL)
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Progress HUD Handler
    func startProgessHUD() {
        self.navigationItem.setRightBarButtonItems([], animated: true)
        
        let activityIndicatorView = UIActivityIndicatorView(style: .white)
        activityIndicatorView.color = UIColor.black
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
        
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopProgessHUD() {
        self.setNavigationBar()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    // MARK: - API CALL
    func callWebAPI_Image_Upload() {
        
        guard let image = self.imgView.image else {
            print("Please select image")
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert to Jpeg data...")
            return
        }
        
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        let dummmyStr = UUID.init().uuidString
        
        let dictParameter: [String: Any] = [
            "image": strBase64,
            "title": "Image title - \(dummmyStr)",
            "description": "This is description - \(dummmyStr)"
        ]
        
//        let dictParameter: [String: Any] = [
//            "image": self.assetURL,
//            "title": "Image title - \(dummmyStr)",
//            "description": "This is description - \(dummmyStr)"
//        ]
//
//        print("dictParameter: \(dictParameter)")
        
        DispatchQueue.main.async {
            self.startProgessHUD()
        }
        
        let webAPIsessionObj: WebAPISession = WebAPISession()
        webAPIsessionObj.callWebAPI(wsType: .POST, bodyType: .multipart, filePathKey: nil, webURLString: kWserviceUrl_Image_Upload
        , parameter: dictParameter) { (response, error) in
            
            DispatchQueue.main.async {
                self.stopProgessHUD()
            }
            
            if error != nil{
                print("Error: \(String(describing: error))")
                DispatchQueue.main.async {
                    self.topMostViewController().showAlert(withTitle: Constants.kApplicationName, message: error!)
                }
            } else {
                print("Response: \(String(describing: response))")
            }
            
        }
    }
}
