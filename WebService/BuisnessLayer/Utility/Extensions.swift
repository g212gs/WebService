//
//  Extensions.swift
//  WebService
//
//  Created by Gaurang Lathiya on 8/22/17.
//  Copyright © 2017 Gaurang Lathiya. All rights reserved.
//

import Foundation
import UIKit
import Photos
import AVFoundation
import Contacts

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension UIAlertAction {
    convenience init(title: String?, style: UIAlertAction.Style, image: UIImage, handler: ((UIAlertAction) -> Void)? = nil) {
        self.init(title: title, style: style, handler: handler)
        self.actionImage = image
    }
    
    convenience init?(title: String?, style: UIAlertAction.Style, imageNamed imageName: String, handler: ((UIAlertAction) -> Void)? = nil) {
        if let image = UIImage(named: imageName) {
            self.init(title: title, style: style, image: image, handler: handler)
        } else {
            return nil
        }
    }
    
    var actionImage: UIImage {
        get {
            return self.value(forKey: "image") as? UIImage ?? UIImage()
        }
        set(image) {
            self.setValue(image, forKey: "image")
        }
    }
}

extension UIViewController {
    func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let uiAlertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle:.alert)
            
            uiAlertController.addAction(
                UIAlertAction.init(title: "OK", style: .default, handler: { (UIAlertAction) in
                    uiAlertController.dismiss(animated: true, completion: nil)
                }))
            self.topMostViewController().present(uiAlertController, animated: true, completion: nil)
        }
    }

    func disableSwipeLeftToBack() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(true, animated: false)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    func enableSwipeLeftToBack() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(false, animated: true)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    func tapToDissmissKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))

        self.view.addGestureRecognizer(tap)
    }
    
    func showNoInternetAvailable() {
        // Status Bar Warning Notification
        self.showAlert(withTitle: Constants.kApplicationName, message: Constants.kNoInterNetConnection)
    }
    
    func dismissNoInternetAvailable() {
        
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func addViewOnWindow(view: UIView) {
        let window = UIApplication.shared.keyWindow!
        window.addSubview(view)
    }
    
    func topMostViewController() -> UIViewController {
        // Handling Modal views
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
            // Handling UIViewController's added as subviews to some other views.
        else {
            for view in self.view.subviews
            {
                // Key property which most of us are unaware of / rarely use.
                if let subViewController = view.next {
                    if subViewController is UIViewController {
                        let viewController = subViewController as! UIViewController
                        return viewController.topMostViewController()
                    }
                }
            }
            return self
        }
    }
    
    func addScreenTapGesture(onView view: UIView, target: UIViewController, selector: Selector) {
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: target, action: selector)
        view.addGestureRecognizer(tapGesture)
    }
    
    func shareOnActivityViewController(shareText: String?, shareImage: UIImage?, shareURL: URL?) {
        var shareItems: [Any] = [Any]()
        if let txt = shareText {
            shareItems.append(txt)
        }
        if let img = shareImage {
            shareItems.append(img)
        }
        if let url = shareURL {
            shareItems.append(url)
        }
        
        if shareItems.count == 0 {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
//        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.topMostViewController().present(activityViewController, animated: true, completion: nil)
    }
    
}

extension UIScrollView {
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        setContentOffset(bottomOffset, animated: animated)
    }
}

extension UIButton {
    
    func setRoundCorner() {
        self.layer.cornerRadius =  self.frame.size.height/2
        self.layer.masksToBounds = true
    }
}

extension UIImage {
    func getBase64() -> String? {
//        let imageData = UIImagePNGRepresentation(self)
        let imageData = self.jpegData(compressionQuality: 0.8)
        return (imageData?.base64EncodedString(options: .lineLength64Characters))
    }
}

extension Data {
    func getBase64String() -> String? {
        return (self.base64EncodedString(options: .lineLength64Characters))
    }
}

extension UILabel {
    func shadow(shadowColor: UIColor) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = true
    }
    
    func removeShadow() {
        self.layer.shadowColor = UIColor.clear.cgColor
    }
}

extension UIView {
    
    func dropShadow() {
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.clipsToBounds = false

        self.layer.shadowColor = UIColor(white: 0.0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 50.0
        self.layer.masksToBounds = false
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func addLongPressGesture(target: UIView, selector: Selector) {
        self.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: target, action: selector)
        self.addGestureRecognizer(longPress)
    }
    
    func addTapGesture(target: UIView, selector: Selector) {
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: target, action: selector)
        self.addGestureRecognizer(tapGesture)
    }
    
    func addLightBoarder() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        self.layer.masksToBounds = true
    }
    
    func addGradient() {
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.name = "Gradient"
        
        let colorLight: UIColor = UIColor.clear
        let colorDark: UIColor = UIColor.black.withAlphaComponent(0.6)
        
        gradientLayer.colors = [colorLight.cgColor, colorDark.cgColor]
        gradientLayer.locations = [0.4, 0.9]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        self.layer.addSublayer(gradientLayer)
    }
    
    func removeGradient() {
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    func addDashedLine(color: UIColor = .lightGray) {
//        layer.sublayers?.filter({ $0.name == "DashedTopLine" }).map({ $0.removeFromSuperlayer() })
        if let arrLayers = layer.sublayers?.filter({ $0.name == "DashedTopLine" }) {
            for layer in arrLayers {
                layer.removeFromSuperlayer()
            }
        }
        backgroundColor = .clear
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [4, 4]
        
        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        shapeLayer.path = path
        
        layer.addSublayer(shapeLayer)
    }
}

extension CALayer {
    func roundCorners(corners: UIRectCorner, radius: CGFloat, viewBounds: CGRect) {
        
        let maskPath = UIBezierPath(roundedRect: viewBounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        mask = shape
    }
}


extension UIColor {

    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    static func RGB(redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
}

extension String {
    
    func trimWhiteAndNewLine() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isValidURL() -> Bool {
        guard let url = URL(string: self) else {
                return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    func isPasswordValid() -> Bool{
        
//        (?=.[a-z]) for Character.
//        (?=.[$@$#!%?&]) for special character.
//        {8,} for length which you want to prefer.
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: self)
    }
    
    // for make user name first name and last name capital
    func polishUserName() -> String {
        return self.capitalized
    }
    
    func getWebUrlList() -> [URL] {
        
        var arrURL: [URL] = [URL]()
        let types: NSTextCheckingResult.CheckingType = [.link]
        do {
            let detector = try NSDataDetector(types: types.rawValue)
            let matches = detector.matches(in: self, options: .reportCompletion, range: NSMakeRange(0, self.count))
            
            for matcheee in matches {
                if let urlMatch = matcheee.url {
                    arrURL.append(urlMatch)
                }
            }
            return arrURL
        } catch {
            return arrURL
        }
    }
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter() // 2017-12-01T13:32:10.877+00:00
        //Specify Format of String to Parse -- 2017-09-15T06:58:23.537+00:00, 2017-09-26T08:51:35+0000
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ" //or you can use "yyyy-MM-dd'T'HH:mm:ssX"
        //Parse into Date
        return dateFormatter.date(from: self)
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(startIndex, offsetBy: value.upperBound)]
        }
    }

}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text:String) -> NSMutableAttributedString {
        let attrs:[NSAttributedString.Key : Any] = [.font : Constants.AppBoldFontWithSize(size: 14),
                                        .foregroundColor : UIColor.black]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text:String)->NSMutableAttributedString {
        let attrs:[NSAttributedString.Key : Any] = [.font : Constants.AppLightFontWithSize(size: 14),
                                        .foregroundColor : UIColor.darkGray]
        let normal = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(normal)
        return self
    }
}

public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}

extension Date {
    init?(jsonDate: String) {
        
        let prefix = "/Date("
        let suffix = ")/"
        
        // Check for correct format:
        guard jsonDate.hasPrefix(prefix) && jsonDate.hasSuffix(suffix) else { return nil }
        
        // Extract the number as a string:
        let from = jsonDate.index(jsonDate.startIndex, offsetBy: prefix.characters.count)
        let to = jsonDate.index(jsonDate.endIndex, offsetBy: -suffix.characters.count)
        
        // Convert milliseconds to double
        guard let milliSeconds = Double(jsonDate[from ..< to]) else { return nil }
        
        // Create NSDate with this UNIX timestamp
        self.init(timeIntervalSince1970: milliSeconds/1000.0)
    }

    func localDateStringWithFormat(dateFormat: String) -> String {
        // change to a readable time format and change to local time zone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: self)
        
        return timeStamp
    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        
        guard var timeString = formatter.string(from: self, to: Date()) else {
            return nil
        }
        
        timeString = timeString.replacingOccurrences(of: "-", with: "")
        
        let formatString = NSLocalizedString("%@ ago", comment: "")
        return String(format: formatString, timeString)
    }
    
}

extension PHAsset {
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}

extension AVURLAsset {
    var fileSize: Int? {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)
        
        return resourceValues?.fileSize ?? resourceValues?.totalFileSize
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return self.rate != 0 && self.error == nil
    }
}

extension URL {
    
    func getThumbnail() -> UIImage {
        do {
            let asset = AVURLAsset(url: self , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error thumbnail: \(error.localizedDescription)")
            return UIImage.init(named: "")!
        }
    }
    
    func getVideoThumbnail(completion: @escaping (UIImage) -> Void) {
        
//        if let videoThumbnail = Utility.sharedInstance.cache.object(forKey: self as AnyObject) as? UIImage {
//            completion(videoThumbnail)
//        } else {
            var cgImage: CGImage? = nil
            DispatchQueue.global().async {
                do {
                    let asset = AVURLAsset(url: self , options: nil)
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    imgGenerator.appliesPreferredTrackTransform = true
                    try cgImage = imgGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 1), actualTime: nil)
                } catch {
                    print("Failed")
                }
                DispatchQueue.main.async(execute: {
                    if let cgImageObj = cgImage {
                        let thumbnail = UIImage(cgImage: cgImageObj)
                        Utility.sharedInstance.cache.setObject(thumbnail, forKey: self as AnyObject)
                        completion(thumbnail)
                    }
                })
            }
//        }
    }
    
}
