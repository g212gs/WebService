//
//  CountrySelectionScreen.swift
//  WebService
//
//  Created by Gaurang Lathiya on 21/05/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol CountrySelectionScreenDelegate {
    func countrySelectionSuccessfull(withCountryName countryName: String?, countryId: Int?)
}

extension CountrySelectionScreen: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // If we haven't typed anything into the search bar then do not filter the results
        if self.searchBar?.text! == "" {
            arrFilteredCountryInfo = arrCountryInfo
        } else {
            // Filter the results
            if let searchText = self.searchBar?.text {
                arrFilteredCountryInfo = arrCountryInfo.filter { ($0.name?.lowercased().contains(searchText.lowercased()))! }
            }
        }
        
        print("textDidChange")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: UISearchBarDelegate functions
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        print("searchBarTextDidBeginEditing")
        
        // If we haven't typed anything into the search bar then do not filter the results
        if self.searchBar?.text! == "" {
            arrFilteredCountryInfo = arrCountryInfo
        } else {
            // Filter the results
            if let searchText = self.searchBar?.text {
                arrFilteredCountryInfo = arrCountryInfo.filter { ($0.name?.lowercased().contains(searchText.lowercased()))! }
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        shouldShowSearchResults = false
        self.tableView.reloadData()
        print("searchBarCancelButtonClicked")
        
        self.searchBar?.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tableView.reloadData()
        }
        
        self.searchBar?.resignFirstResponder()
        print("searchBarSearchButtonClicked")
    }
}

class CountrySelectionScreen: UITableViewController {
    
    var arrCountryInfo: [CountryInfo] = [CountryInfo]()
    var selectedCountryId: Int?
    
    var selectedCountryName: String?
    
    // Search required
    var searchBar: UISearchBar?
    var shouldShowSearchResults = false
    var arrFilteredCountryInfo: [CountryInfo] = [CountryInfo]()
    
    var delegate: CountrySelectionScreenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigationBar()
        
        let def = UserDefaults.standard
        let data: Data? = def.object(forKey: Constants.kUserSavedCountryList) as! Data?
        if let dataUser = data {
            let services:[CountryInfo] = NSKeyedUnarchiver.unarchiveObject(with: dataUser) as! [CountryInfo]
            self.arrCountryInfo = services
            
            // to set the check mark
            self.setSelectedIndexPath()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            self.callWebAPI_GetAllCountries()
        }
    }
    
    func setNavigationBar() {
        self.title = "Select country"
        
        self.navigationItem.setLeftBarButtonItems([], animated: true)
        self.navigationItem.setRightBarButtonItems([], animated: true)
        
        let leftBarButton: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel
            , target: self, action: #selector(self.btnCancelClicked))
        leftBarButton.setTitleTextAttributes([
            .font: Constants.AppLightFontWithSize(size: 15),
            .foregroundColor: UIColor.black
            ], for: .normal)
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
        
        let rightBarButton: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done
            , target: self, action: #selector(self.btnDoneClicked))
        rightBarButton.setTitleTextAttributes([
            .font: Constants.AppLightFontWithSize(size: 15),
            .foregroundColor: UIColor.black
            ], for: .normal)
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Bar Button item click events
    @objc func btnCancelClicked() {
        print("Cancel clicked...")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnDoneClicked() {
        print("Done clicked...")
        if let countryId = self.selectedCountryId {
            let arrFiltered = self.arrCountryInfo.filter { (Int($0.numericCode ?? "0") ?? 0 ==  countryId)}
            if arrFiltered.count > 0 {
                let countryInfoObj = arrFiltered[0]
                self.delegate?.countrySelectionSuccessfull(withCountryName: countryInfoObj.name, countryId: Int(countryInfoObj.numericCode ?? "0"))
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper method
    func initUI()  {
        
        DispatchQueue.main.async {
            
            // For set the tick color
            self.tableView.tintColor = UIColor.black
            
            self.view.backgroundColor = UIColor.white
            
            self.configureSearchBar()
            
            if let tblHeaderView = self.tableView.tableHeaderView {
                var contentOffset: CGPoint = self.tableView.contentOffset
                contentOffset.y += tblHeaderView.frame.height
                self.tableView.contentOffset = contentOffset
            }
        }
    }
    
    func configureSearchBar() {
        
        if searchBar != nil {
            return
        }
        
        // Initialize and perform a minimum configuration to the search bar.
        searchBar = UISearchBar.init()
        searchBar?.placeholder = "Search..."
        searchBar?.tintColor = UIColor.black
        searchBar?.setTextColor(color: UIColor.black)
        searchBar?.delegate = self
        searchBar?.showsCancelButton = true
        searchBar?.sizeToFit()
        searchBar?.searchBarStyle = .minimal
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        
        //        definesPresentationContext = true
        // Place the search bar view in table header
        self.tableView.tableHeaderView = searchBar
    }
    
    func setSelectedIndexPath() {
        
        if let countryName = self.selectedCountryName {
            let arrFiltered = self.arrCountryInfo.filter { ($0.name?.lowercased() ==  countryName.lowercased())}
            if arrFiltered.count > 0 {
                let countryInfoObj = arrFiltered[0]
                self.selectedCountryId = Int(countryInfoObj.numericCode ?? "0")
                //                self.selectedIndexPath = IndexPath(row: self.arrCountryInfo.index(of: countryInfoObj)!, section: 0)
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return self.arrFilteredCountryInfo.count
        }
        return self.arrCountryInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListCell", for: indexPath)
        
        // Configure the cell...
        var countryInfoObj: CountryInfo = self.arrCountryInfo[indexPath.row]
        if shouldShowSearchResults {
            countryInfoObj = self.arrFilteredCountryInfo[indexPath.row]
        }
        cell.textLabel?.text = countryInfoObj.name
        cell.textLabel?.font = Constants.AppLightFontWithSize(size: 13)
        
        cell.detailTextLabel?.text = countryInfoObj.capital ?? ""
        cell.detailTextLabel?.font = Constants.AppLightFontWithSize(size: 11)
        
        // Show selected indexPath
        cell.accessoryType = (Int(countryInfoObj.numericCode ?? "0") == self.selectedCountryId) ? .checkmark : .none
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var countryInfoObj: CountryInfo = self.arrCountryInfo[indexPath.row]
        if shouldShowSearchResults {
            countryInfoObj = self.arrFilteredCountryInfo[indexPath.row]
        }
        self.selectedCountryId =  Int(countryInfoObj.numericCode ?? "0")
        self.tableView.reloadSections(IndexSet(integersIn: 0...0)
            , with: UITableViewRowAnimation.none)
    }
    
    
    // MARK: - Progress HUD Handler
    func startProgessHUD() {
        self.navigationItem.setRightBarButtonItems([], animated: true)
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
        
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopProgessHUD() {
        self.setNavigationBar()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func callWebAPI_GetAllCountries() {
        
        let dictParameter: [String: Any] = [String: Any]()
        
        print("dictParameter: \(dictParameter)")
        
        DispatchQueue.main.async {
            self.startProgessHUD()
        }
        
        let webAPIsessionObj: WebAPISession = WebAPISession()
        webAPIsessionObj.callWebAPI(wsType: .GET, webURLString: kWserviceUrl_GetAllCountries
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
                
                if let dataArr = response?.array {
                    
                    if dataArr.count == 0 {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        for jsonObj in dataArr {
                            //                            arrCountryInfo: [CountryInfo]
                            let countryInfoObj = CountryInfo.init(json: jsonObj)
                            self.arrCountryInfo.append(countryInfoObj)
                        }
                        
                        // Save for next time..
//                        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: self.arrCountryInfo), forKey: Constants.kUserSavedCountryList)
//                        UserDefaults.standard.synchronize()
                        
                        // to set the check mark
                        self.setSelectedIndexPath()
                        
                        self.tableView.reloadData()
                    }
                } else {
                    if let responseJson = response {
                        DispatchQueue.main.async {
                            var message = Constants.kErrorWebService
                            if let wsMessage = responseJson[Constants.kMessage].rawString() {
                                message = wsMessage
                            }
                            print("message : \(message)")
                            self.topMostViewController().showAlert(withTitle: Constants.kApplicationName, message: message)
                        }
                    }
                    
                }
            }
            
        }
    }
    
}
