//
//  Utility.swift
//  WebService
//
//  Created by Gaurang Lathiya on 8/21/17.
//  Copyright © 2017 Gaurang Lathiya. All rights reserved.
//

import UIKit
import AVFoundation
import MapKit

class Utility: NSObject {

    var cache = NSCache<AnyObject, AnyObject>()
    class var sharedInstance: Utility
    {
        //creating Shared Instance
        struct Static
        {
            static let instance: Utility = Utility()
        }
        return Static.instance
    }
    
    static func muteAVPlayer() {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        }
        catch  let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    static func saveImageToPhotoGallery(image: UIImage?) {
        if let imgToBeSaved = image {
            UIImageWriteToSavedPhotosAlbum(imgToBeSaved, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc static func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            print("Error while save image to photo gallery: \(error.localizedDescription)")
        } else {
            print("Image saved successfully")
        }
    }

    /// function returns the stroyboard object
    static func getMainStroryBoard() -> UIStoryboard{
        let stroyboard = UIStoryboard(name: "Main", bundle: nil)
        return stroyboard
    }

    ///saves the image to the document directory with image name. funaction returns full image path including document directory
    static func saveImage(imagetoConvert image: UIImage, name imageName :String) -> String{
        let imageData: Data? = image.jpegData(compressionQuality: 1.0)
        let fileManager = FileManager.default
        var paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory: String? = (paths[0] as? String)
        let imagePath = documentsDirectory?.appending("/\(imageName)")
        fileManager.createFile(atPath: imagePath!, contents: imageData, attributes: nil)
        return imagePath!
    }

    //retrive data from custom object
    static func loadCustomObject(withKey key: String) -> Any {
        let prefs = UserDefaults.standard
        let myEncodedObject: Data? = prefs.object(forKey: key) as? Data
        var obj: Any? = NSKeyedUnarchiver.unarchiveObject(with: myEncodedObject ?? "".data(using: String.Encoding.utf16)!)
        if (obj == nil) {
            obj = ""
        }
        return obj!
    }

    static func loadCustomBoolObject(withKey key: String) -> Any {
        let prefs = UserDefaults.standard
        let myEncodedObject: Data? = prefs.object(forKey: key) as? Data
        var obj: Any? = NSKeyedUnarchiver.unarchiveObject(with: myEncodedObject ?? "".data(using: String.Encoding.utf16)!)
        if (obj == nil) {
            obj = false
        }
        return obj!
    }

    /// Save Custom Object in User Default
    class func saveCustomObject(_ object: Any, forKey strKey: String) {
        let prefs = UserDefaults.standard
        let myEncodedObject = NSKeyedArchiver.archivedData(withRootObject: object)
        prefs.set(myEncodedObject, forKey: strKey)
        UserDefaults.standard.synchronize()
    }

    class func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    class func getResizedImageWithImage(image:UIImage, scaledToSize newSize:CGSize ) -> UIImage {

        let sizeFact:CGFloat = newSize.width * 0.3

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: sizeFact/2, y: sizeFact/2, width: newSize.width-sizeFact, height: newSize.width-sizeFact))
        let newImage : UIImage  = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();

        return newImage;

    }
    
    // MARK: - Helper methods
    static func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    
    func getCLLocationCoordinate2D(forLatitude lat: String, long: String) -> CLLocationCoordinate2D? {
        guard let latVal = Double(lat), let longVal = Double(long) else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latVal, longitude: longVal)
    }
    
    func openMap(withLocation location: CLLocationCoordinate2D, placeName: String) {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location, addressDictionary:nil))
        mapItem.name = placeName
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    func tapCall(forContactNumber contactNumber: String) {
        let callNumber = contactNumber.trimWhiteAndNewLine().components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        guard let number = URL(string: "tel://" + callNumber) else { return }
        if UIApplication.shared.canOpenURL(number) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(number)
            } else {
                // Fallback on earlier versions
                if let url = URL(string: "tel://\(contactNumber.trimWhiteAndNewLine())") {
                    UIApplication.shared.openURL(url)
                }
            }
        } else {
            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                topController.topMostViewController().showAlert(withTitle: Constants.kApplicationName, message: Constants.kErrorFailedToCallNumber)
            }
        }
    }

    static func getCurrentJsonDate() -> String {
        // For getting current time in UTC
        let currentDateTime = Date()
        let getCurrentJsonDate = (currentDateTime.timeIntervalSince1970*1000).rounded().description
        let arrChar = getCurrentJsonDate.components(separatedBy: ".")
        if arrChar.count == 0 {
            return getCurrentJsonDate
        } else {
            return arrChar[0]
        }
    }
    
    class func getIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    if let ifaName  = interface?.ifa_name {
                        let name: String = String(cString: ifaName)
                        if name == "en0" {
                            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                            address = String(cString: hostname)
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
}
