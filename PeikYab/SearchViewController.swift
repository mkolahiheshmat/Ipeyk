//
//  SearchViewController.swift
//  PeikYab
//
//  Created by Developer on 10/9/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces

class SearchViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UISearchControllerDelegate,UISearchResultsUpdating,CLLocationManagerDelegate,UIScrollViewDelegate{
    
    //MARK: - Variables
    var searchController:UISearchController!
    var tableView:UITableView!
    var tableArray = [[String:AnyObject]]()
    let cellReuseIdendifier = "searchCell"
    var dataArray = [String]()
    var filteredArray = [String]()
    var shouldShowSearchResults = false
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var pageNumber:Int = 1
    var scrollView:UIScrollView!
    var placesClient : GMSPlacesClient = GMSPlacesClient()
    var originSelected:Int! = 0
    var searchIsBegining: Bool = false
    
    //MARK: -  view WillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        pageNumber = 1
        tableArray = [[String:AnyObject]]()
        getFavouritAddressList()
    }
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originSelected = UserDefaults.standard.object(forKey: "originSelected") as? Int
        
        makeTopbar(NSLocalizedString("search", comment: ""))
        backButton.addTarget(self, action: #selector(SearchViewController.backAction), for: .touchUpInside)
        self.view.isUserInteractionEnabled = true
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight-64))
        
        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight-64))
        tableView.dataSource = self
        tableView.delegate = self
        scrollView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.allowsSelection = true
        tableView.separatorColor = topViewBlue
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        configureSearchController()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    //MARK: -  TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = SearchCustomCell(style: .default, reuseIdentifier: "searchCell")
        
        if searchIsBegining == false{
            let tempDic:Dictionary = tableArray[indexPath.row] as Dictionary
            cell.favAddressNameLabel.text = tempDic["name"] as! String?
            cell.favAddressLabel.text = tempDic["address"] as! String?
            cell.searchAddressNameLabel.isHidden = true
            cell.searchAddressLabel.isHidden = true
            
        }else{
            let tempDic:Dictionary = tableArray[indexPath.row] as Dictionary
            cell.favAddressNameLabel.isHidden = true
            cell.favAddressLabel.isHidden = true
            cell.starImageView.isHidden = true
            cell.searchMarkerImageView.isHidden = true
            cell.searchAddressNameLabel.text = tempDic["name"] as! String?
            cell.searchAddressLabel.text = tempDic["address"] as! String?
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        self.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
        
        let tempDic:Dictionary = tableArray[indexPath.row] as Dictionary
        print(tempDic)
        
        var myDic:Dictionary<String, AnyObject> = [String: AnyObject]()
        if searchIsBegining == false{
            myDic = ["name":(tempDic["name"])! as AnyObject, "lat":(tempDic["lat"])! as AnyObject, "lon":(tempDic["lon"])! as AnyObject]
        }else{
            myDic = ["name":(tempDic["name"])! as AnyObject, "lat":(tempDic["latitude"])! as AnyObject, "lon":(tempDic["longitude"])! as AnyObject]
        }
        if originSelected != nil{
            if originSelected == 0 {
                print(originSelected)
                _ = self.navigationController?.popToRootViewController(animated: true)
                let notificationName = Notification.Name("setFavAddressAsOrigin")
                NotificationCenter.default.post(name: notificationName, object: myDic)
            }else if originSelected == 1{
                print(originSelected)
                _ = self.navigationController?.popToRootViewController(animated: true)
                let notificationName = Notification.Name("setFavAddressAsDestination")
                NotificationCenter.default.post(name: notificationName, object: myDic)
            }
        }
    }
    //MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController){
        /*  let searchString = searchController.searchBar.text
         
         Filter the data array and get only those countries that match the search text.
         filteredArray = dataArray.filter({ (country) -> Bool in
         let countryText: NSString = country as NSString
         
         return (countryText.rangeOfString(searchString, options: NSStringCompareOptions})
         
         Reload the tableview.
         tableView.reloadData()*/
    }
    //MARK: -  Custom Methods
    func backAction(){
        //_ = self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func configureSearchController() {
        //  // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        // //searchController.searchBar.frame = CGRect(x: 0, y: 64, width: screenWidth, height: 50)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("search", comment: "")
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        //Place the search bar view to the tableview headerview.
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        placeAutocomplete(searchText: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        //beginSearching(searchText: searchBar.text!)
        //tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        searchIsBegining = false
        cancelSearch()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        searchController.searchBar.resignFirstResponder()
    }
    func cancelSearch(){
        
        pageNumber = 1
        tableArray = [[String:AnyObject]]()
        getFavouritAddressList()
    }
    
    func placeAutocomplete(searchText:String) {
        if searchText.characters.count > 2{
            let filter = GMSAutocompleteFilter()
            //filter.type = .establishment
            let firstLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 35.618408, longitude: 51.501623)
            let secondLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 35.746826, longitude: 51.113669)
            let bounds:GMSCoordinateBounds = GMSCoordinateBounds(coordinate: firstLocation, coordinate: secondLocation)
            placesClient.autocompleteQuery(searchText, bounds: bounds, filter: filter) { (results, error) in
                guard error == nil else {
                    print("Autocomplete error \(error)")
                    return
                }
                
                self.tableArray = [[String:AnyObject]]()
                
                for result in results! {
                    self.searchIsBegining = true
                    let placeID:String = result.placeID! as String
                    self.placesClient.lookUpPlaceID(placeID, callback: { (myplace, error) in
                        if myplace?.coordinate != nil{
                            print("palce: \(myplace!.coordinate)")
                            let tempDic:Dictionary<String, AnyObject> = ["name":result.attributedPrimaryText.string as AnyObject,"address":result.attributedFullText.string as AnyObject, "latitude":myplace!.coordinate.latitude as AnyObject, "longitude":myplace!.coordinate.longitude as AnyObject]
                            if (tempDic["address"]?.contains("تهران"))!{
                                self.tableArray.append(tempDic)
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                    //print("Result \(result.attributedFullText) with placeID \(result.placeID)")
                    //print(result.attributedPrimaryText.string)
                    
                }
            }
        }
    }
    
    //MARK: - ScrollView Delegate
    //Paging
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            //reach bottom
            print("reach bottom")
            self.pageNumber = self.pageNumber+1
            getFavouritAddressList()
        }
        
        if (scrollView.contentOffset.y < 0){
            //reach top
            print("reach top")
        }
        
        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
            //searchController.searchBar.resignFirstResponder()
            print("scroll to top")
        }
        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
            //searchController.searchBar.resignFirstResponder()
            print("scroll to bottom")
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
    
    //MARK: -  Connections
    func getFavouritAddressList(){
        
        // Check Internet Connection
        let isConnectionAvailable:Bool = isInternetAvailable()
        if isConnectionAvailable == false{
            DispatchQueue.main.async {
                let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("checkInternetConnection", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
        if sessionID != nil {
            //35.748428
            //51.285110
            let status:Int = 0
            //let page:Int = 0
            ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
            }
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        "page":pageNumber as AnyObject
            ]
            print("sessionID:\(sessionID)")
            print("status:\(status)")
            print("page:\(pageNumber)")
            getFavouritAddressListWithCallBack(apiName: "location/getfavoriteaddresslist", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                })
                
                if let responseDic = resDic{
                    print(responseDic)
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        // self.tableArray = [[String:AnyObject]]()
                        
                        if let locationArray = responseDic["data"] as? NSArray {
                            for location in locationArray {
                                print(location)
                                self.tableArray.append(location as! [String : AnyObject])
                            }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }else/*status>1*/{
                        //Session Expired
                        if (resDic?.object(forKey: "code") as! Int) == 403 && (resDic?.object(forKey: "status") as! Int) == 0{
                            
                            DispatchQueue.main.async {
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                nextViewController.showBackButton = false
                                self.present(nextViewController, animated: true, completion: nil)
                                
                                //                                let msg:String = responseDic.object(forKey: "msg") as! String
                                //                                let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:msg , preferredStyle: UIAlertControllerStyle.alert)
                                //                                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                                //                                self.present(alert, animated: true, completion: nil)
                            }
                        }else/*code!=403 and status!=0(Session Not Expired)*/{
                            DispatchQueue.main.async {
                                let msg:String = responseDic.object(forKey: "msg") as! String
                                let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:msg , preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
                //Error
                if let responseError = error{
                    print(responseError.localizedDescription)
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:responseError.localizedDescription as String , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
