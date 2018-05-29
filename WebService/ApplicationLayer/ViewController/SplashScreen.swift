//
//  SplashScreen.swift
//  WebService
//
//  Created by Gaurang Lathiya on 21/05/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import UIKit

class SplashScreen: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.disableSwipeLeftToBack()
       
        self.perform(#selector(moveToLoginScreen), with: nil, afterDelay: 2.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func moveToLoginScreen() {
        activityIndicator.stopAnimating()
        if let homeScreenObj: HomeScreen = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreen") as? HomeScreen {
            self.navigationController?.pushViewController(homeScreenObj, animated: true)
        }
    }

}
