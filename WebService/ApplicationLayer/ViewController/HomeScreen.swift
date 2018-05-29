//
//  HomeScreen.swift
//  WebService
//
//  Created by Gaurang Lathiya on 21/05/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import UIKit

class HomeScreen: UIViewController, CountrySelectionScreenDelegate {

    @IBOutlet weak var lblCountryName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Your Country"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getCountry(_ sender: UIButton) {
        if let countrySelectionScreenObj: CountrySelectionScreen = self.storyboard?.instantiateViewController(withIdentifier: "CountrySelectionScreen") as? CountrySelectionScreen {
            countrySelectionScreenObj.selectedCountryName = lblCountryName.text
            countrySelectionScreenObj.delegate = self
            self.navigationController?.pushViewController(countrySelectionScreenObj, animated: true)
        }
    }
    
    // MARK: - CountrySelectionScreenDelegate
    func countrySelectionSuccessfull(withCountryName countryName: String?, countryId: Int?) {
        lblCountryName.text = countryName ?? "N/A"
    }
}
