//
//  Constants.swift
//  ConnectSocial
//
//  Created by Yogesh Padekar on 8/21/17.
//  Copyright © 2017 Gaurang Lathiya. All rights reserved.
//

import UIKit

class Constants: NSObject {
    //application constant
    static let kApplicationName =           "Web Service"
    
    static let kMashape_Key =               "UMTCH3Zf7MmshCBKuEq0263Z3PiMp1UQa2Fjsn8IAZ7caA4Pr1"

    static let SCREEN_SIZE: CGRect = UIScreen.main.bounds
    static let StatusBarHeight = 20
    static let NavBarHeight = 44 + StatusBarHeight
    static let TabBarHeight = (UIDevice.current.userInterfaceIdiom == .pad) ? 40 : 40
    static let isIpad: Bool = (UIDevice.current.userInterfaceIdiom == .pad)

    //font constant
    static let kFONT_REGULAR =              "Montserrat-Regular"
    static let kFONT_BOLD =                 "Montserrat-Bold"
    static let kFONT_LIGHT =                "Montserrat-Light"
    
    static func AppRegularFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Regular", size: size)!
    }
    static func AppBoldFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Bold", size: size)!
    }
    static func AppLightFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Light", size: size)!
    }
    
    static func GoogleMapSnapShot(forLatitude latitude: Double, Longitude longitude: Double, size: CGSize, zoomLevel: Int) -> String {
        return "https://maps.google.com/maps/api/staticmap?markers=color:red|\(latitude),\(longitude)&\("zoom=\(zoomLevel)&size=\(Int(UIScreen.main.scale) * Int(size.width))x\(Int(UIScreen.main.scale) * Int(size.height))")&sensor=true"
    }
    
    // GOOGLE MAP
    static let GOOGLE_MAP_ZOOM_LEVEL = 16
    

    // WebService constants
    static let kStatus                  =   "status"
    static let kMessage                 =   "message"
    static let kData                    =   "data"
    static let kDocsUrl                 =   "DocsUrl"
    static let kVideoAssetUrlString     =   "videoAssetUrlString"
    
    static let kUserSavedIPAddress       = "userSavedIPAddress"
    static let kUserSavedLocation        = "userSavedLocation"
    static let kUserSavedCountryList     = "userSavedCountryList"
    
    //All Alerts
    //AlertTitle Constants
    static let kAlertTypeOK =               "OK"
    static let kAlertTypeCancel =           "Cancel"
    static let kAlertTypeYES =              "YES"
    static let kAlertTypeNO =               "NO"
    static let kAlertHideDelete =           "Delete"
    static let kAlertLeave =                "Leave"
    static let kAlertRemoveLink =           "Remove Link"
    static let kAlertTypeEdit =             "Edit"
    static let kAlertOther =                "Other"
    static let kAlertClear =                "Clear"
    static let kAlertCreateEvent =          "Create Event"
    static let kAlertCopy =                 "Copy"
    static let kAlertSaveImage =            "Save Image"
    static let kAlertSaveVideo =            "Save Video"
    
    static let kAlertHideDeleteAccount =     "Delete Account"
    static let kAlertHideSignOut =           "Sign Out"
    
    static let kAlertWarning =              "Warning"
    
    static let kAlertMediaImage =           "Image"
    static let kAlertMediaVideo =           "Video"
    static let kAlertMediaContact =         "Contact"
    static let kAlertMediaLocation =        "Location"
    
    static let kNoInterNetConnection =      "No Internet Connection."
    
//    plist - Please allow location for make connect social account more secure.
//    plist - connect social will use your location
    static let kNoLocationInformation =      "Please allow location for make connect social account more secure. \n you can still enable it from settings menu"

    // Error
    static let kErrorNoGroupCoverPic         =   "Please select cover picture."
    static let kErrorWebService              =   "Please try again."
    static let kErrorWSNoData                =   "No data found."
    
    static let kErrorFailedToSaveEvent       =   "Failed to save event \n please try again or use mannually with copy event dates"
    
    static let kErrorFailedToCallNumber      =   "Device does not have call making capability"
    
    // warning
    static let kAlertWarningNoLocationFound         =   "Event location not available"
    static let kAlertWarningNoLocationIdentify      =   "Event location could not identify for map"
}
