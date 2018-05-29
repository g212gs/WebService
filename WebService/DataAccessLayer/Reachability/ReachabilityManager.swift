//
//  ReachabilityManager.swift
//  WebService
//
//  Created by Gaurang Lathiya on 9/8/17.
//  Copyright © 2017 Gaurang Lathiya. All rights reserved.
//

import UIKit
import Reachability // 1 Importing the Library

class ReachabilityManager: NSObject {
    
    static let shared = ReachabilityManager()  // 2. Shared instance
    
    // 3. Boolean to track network reachability
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .none
    }
    
    // 4. Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaWWAN)
    var reachabilityStatus: Reachability.Connection = .none
    
    // 5. Reachibility instance for Network status monitoring
    let reachability = Reachability()!
    
    
    
    
    /// Called whenever there is a change in NetworkReachibility Status
    ///
    /// — parameter notification: Notification with the Reachability instance
    @objc func reachabilityChanged(notification: Notification) {
        
        // Remove saved IP Address
        UserDefaults.standard.removeObject(forKey: Constants.kUserSavedIPAddress)
        UserDefaults.standard.synchronize()
        
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .none:
            debugPrint("Network became unreachable")
            self.showNoIntenetConnectionBanner()
        case .wifi:
            debugPrint("Network reachable through WiFi")
            self.dismissNoIntenetConnectionBanner()
            // save current IP Address
            if let currentIPAddress = Utility.getIPAddress() {
                print("Current IP Address: \(currentIPAddress)")
                UserDefaults.standard.setValue(currentIPAddress
                    , forKey: Constants.kUserSavedIPAddress)
                UserDefaults.standard.synchronize()
            }
        case .cellular:
            debugPrint("Network reachable through Cellular Data")
            self.dismissNoIntenetConnectionBanner()
            // save current IP Address
            if let currentIPAddress = Utility.getIPAddress() {
                print("Current IP Address: \(currentIPAddress)")
                UserDefaults.standard.setValue(currentIPAddress
                    , forKey: Constants.kUserSavedIPAddress)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func showNoIntenetConnectionBanner() {
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                if let rootViewController = keyWindow.rootViewController {
                    rootViewController.topMostViewController().showNoInternetAvailable()
                }
            }
        }
    }
    
    func dismissNoIntenetConnectionBanner() {
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                if let rootViewController = keyWindow.rootViewController {
                    rootViewController.topMostViewController().dismissNoInternetAvailable()
                }
            }
        }
    }
    
    
    /// Starts monitoring the network availability status
    func startMonitoring() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            debugPrint("Could not start reachability notifier")
        }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged,
                                                  object: reachability)
    }
}
