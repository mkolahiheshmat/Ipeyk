////
//  ViewController.swift
//  PeikYab
//
//  Created by Yarima on 8/30/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: BaseViewController, GMSMapViewDelegate, CLLocationManagerDelegate,UITextFieldDelegate{
    
    //MARK: - Variables
    let tehranCenterLat = 35.707885
    let tehranCenterLong = 51.396502
    
    var markerOrigin : GMSMarker!
    var markerDestination : GMSMarker!
    var mapView : GMSMapView!
    var locationManager = CLLocationManager()
    var markerButton:UIButton!
    var firstPosition : GMSCameraPosition!
    var lastPosition : GMSCameraPosition!
    var numbeOfTappedOnMarker :Int = 0
    var originTtitleLabel:UILabel!
    var originLabel : UILabel!
    var tikForOrigin:UIImageView!
    var horizontalLineForOrigin:UIView!
    var numberOfPeykLabel : UILabel!
    var destinationTitleLabel : UILabel!
    var destinationLabel : UILabel!
    var tikForDestination:UIImageView!
    var horizontalLineForDestination:UIView!
    var bottomView : UIView!
    var bgViewforOrigin : UIView!
    var bgViewforDestination : UIView!
    var giftCodeButton : UIButton!
    var priceButton : UIButton!
    var cancelButton : UIButton!
    var requestPeikButton : UIButton!
    var markersArray = [GMSMarker]()
    var originLatitude:CLLocationDegrees = 0.0
    var originLongitude:CLLocationDegrees = 0.0
    var destLatitude:CLLocationDegrees = 0.0
    var destLongitude:CLLocationDegrees = 0.0
    var indicatorForOriginLabel:UIActivityIndicatorView!
    var indicatorForDestinationLabel:UIActivityIndicatorView!
    var indicatorForPrice: UIActivityIndicatorView!
    var shipPriceString:String?
    var totalPriceString:String?
    var tableArrayFavorites = [[String:AnyObject]]()
    
    var getMobilePopupView : UIView!
    var mobileTextField : UITextField!
    var transparentView:UIView!
    
    var verificationPopupView : UIView!
    var verificationCodeTextField : UITextField!
    var verificationTransparentView:UIView!
    
    var giftCodeTextField: UITextField!
    var giftCodeRegisterButton:UIButton!
    var giftCodeIsShow:Bool = false
    
    var favButton1:UIButton!
    var favButton2:UIButton!
    
    var searchButton:UIButton!
    var closeButtonForDestination:UIButton!
    var backButtonForOrigin:UIButton!
    var showUserLocationButton:UIButton!
    
    var isOriginSelected:Bool = false
    
    //Address Parts
    var locality:String! //CityName
    var subLocality:String!//Region
    var thoroughfare:String!//Street
    //var lastPart:[String]!//Lines
    
    override func viewDidDisappear(_ animated: Bool) {
        ARSLineProgress.hideWithCompletionBlock({ () -> Void in
        })
    }
    //MARK: -  viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        // self.tableArrayFavorites = [[String:AnyObject]]()
        
        getFavoriteAddress()
        //getLastInProgressTrip()
        
        if mapView != nil {
            mapView.settings.setAllGesturesEnabled(true)
        }
    }
    
    //MARK: -  viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        checkToShowIntroView()
        
        setupMap()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.setFavAddressAsOrigin(notification:)), name: NSNotification.Name(rawValue: "setFavAddressAsOrigin"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.setFavAddressAsDestination(notification:)), name: NSNotification.Name(rawValue: "setFavAddressAsDestination"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.showAlert(notification:)), name: NSNotification.Name(rawValue: "showAlert"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.showCancelTripAlert(notification:)), name: NSNotification.Name(rawValue: "showCancelTripAlert"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.getFavoriteAddress(notification:)), name: NSNotification.Name(rawValue: "getFavouriteAddressAfterSignin"), object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(ViewController.logoutCancel(notification:)), name: NSNotification.Name(rawValue: "cancelButton"), object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(ViewController.backButtonForMap(notification:)), name: NSNotification.Name(rawValue: "backButton"), object: nil)
        
        
        
        // NotificationCenter.default.addObserver(self, selector: #selector(ViewController.showAlert(notification:)), name: NSNotification.Name(rawValue: "event107"), object: nil)
        // NotificationCenter.default.addObserver(self, selector: #selector(ViewController.showAlert(notification:)), name: NSNotification.Name(rawValue: "event108"), object: nil)
        // NotificationCenter.default.addObserver(self, selector: #selector(ViewController.showAlert(notification:)), name: NSNotification.Name(rawValue: "event109"), object: nil)
        // NotificationCenter.default.addObserver(self, selector: #selector(ViewController.showAlert(notification:)), name: NSNotification.Name(rawValue: "event110"), object: nil)
        // NotificationCenter.default.addObserver(self, selector: #selector(ViewController.showAlert(notification:)), name: NSNotification.Name(rawValue: "event111"), object: nil)
        
        //MARK: - Display Notification Message in alert instead of پیام از سرور جایگزین شود
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.navigateToRatingVC(notification:)), name: NSNotification.Name(rawValue: "event112"), object: nil)
        
        UserDefaults.standard.set(0,forKey:"originSelected")
        
        makeTopbar(NSLocalizedString("home", comment: ""))
        backButton.isHidden = true
        
        //button like Marker to select whether origin or destination
        
        let markerImage = UIImage(named: "marker")
        markerButton = UIButton(frame: CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 22, width: 100 * 0.5, height: 88 * 0.5))
        markerButton.setBackgroundImage(markerImage, for: .normal)
        //markerButton.imageView?.clipsToBounds = true
        markerButton.imageView?.contentMode = .scaleToFill
        //markerButton.contentVerticalAlignment = UIControlContentVerticalAlignment.fill
        //markerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.fill
        // markerButton.imageEdgeInsets = UIEdgeInsetsMake(25, 25, 25, 25)
        markerButton.addTarget(self, action: #selector(ViewController.markerButtonAction), for: .touchUpInside)
        mapView.addSubview(markerButton)
        self.markerButton.isUserInteractionEnabled = false
        
        
        searchButton = makeButton(frame: CGRect(x: 20, y: 25, width: 54 * 0.4, height: 69 * 0.4), backImageName: "search", backColor: nil, title: nil, titleColor: nil, isRounded: false)
        self.view.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(ViewController.searchButtonAction), for: .touchUpInside)
        
        let menuButton = makeButton(frame: CGRect(x: screenWidth - 50, y: 30, width: 54/2,height: 39/2), backImageName: "menu", backColor: nil, title: nil, titleColor: nil, isRounded: false)
        menuButton.addTarget(self, action: #selector(ViewController.menuAction), for: .touchUpInside)
        self.view.addSubview(menuButton)
        
        //let navigationFromRating:Bool = UserDefaults.standard.object(forKey: "navigateRatingToMap") as! Bool
        
        // if  navigationFromRating == false{       //True
        
        //  self.cancelButtonAction()
        //self.backButtonForOriginAction()
        
        //UserDefaults.standard.set(false,forKey: "navigateRatingToMap")
        // }
    }
    
    //MARK: -  TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if DeviceType.IS_IPHONE_4_OR_LESS {
            if textField.tag == 14 || textField.tag == 15{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.view.frame
                    rect.origin.y -= 95
                    self.view.frame = rect
                })
            }else if textField.tag == 13{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.bottomView.frame
                    rect.origin.y -= 150
                    self.bottomView.frame = rect
                })
            }
        }else if DeviceType.IS_IPHONE_5{
            if textField.tag == 14 || textField.tag == 15{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.view.frame
                    rect.origin.y -= 80
                    self.view.frame = rect
                })
            }else if textField.tag == 13{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.bottomView.frame
                    rect.origin.y -= 210
                    self.bottomView.frame = rect
                })
            }
        }else if DeviceType.IS_IPHONE_6{
            if textField.tag == 14 || textField.tag == 15{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.view.frame
                    rect.origin.y -= 30
                    self.view.frame = rect
                })
            }else if textField.tag == 13{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.bottomView.frame
                    rect.origin.y -= 210
                    self.bottomView.frame = rect
                })
            }
        }else if DeviceType.IS_IPHONE_6P{
            if textField.tag == 14 || textField.tag == 15{
                //OK
                return
            }
            if textField.tag == 13{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.bottomView.frame
                    rect.origin.y -= 225
                    self.bottomView.frame = rect
                })
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 14 || textField.tag == 15{
            UIView.animate(withDuration: 0.3, animations: {
                var rect = self.view.frame
                rect.origin.y = 0
                self.view.frame = rect
            })
        }
        if DeviceType.IS_IPHONE_4_OR_LESS {
            /* if textField.tag == 14 || textField.tag == 15{
             UIView.animate(withDuration: 0.3, animations: {
             var rect = self.view.frame
             rect.origin.y -= 95
             self.view.frame = rect
             })
             }*/
            if textField.tag == 13 {
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.bottomView.frame
                    rect.origin.y += 150
                    self.bottomView.frame = rect
                })
            }
        }else if DeviceType.IS_IPHONE_5{
            if textField.tag == 13{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.bottomView.frame
                    rect.origin.y += 210
                    self.bottomView.frame = rect
                })
            }
        }else if DeviceType.IS_IPHONE_6{
            if textField.tag == 13 {
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.bottomView.frame
                    rect.origin.y += 210
                    self.bottomView.frame = rect
                })
            }
        }else if DeviceType.IS_IPHONE_6P{
            if textField.tag == 13 {
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.bottomView.frame
                    rect.origin.y += 225
                    self.bottomView.frame = rect
                })
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 13{
            giftCodeTextField.resignFirstResponder()
        }
        if textField.tag == 14{
            mobileTextField.resignFirstResponder()
        }
        if textField.tag == 15{
            verificationCodeTextField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: -  Custom methods
    
    //Push Notification Selector
    //Display Notification Message in alert instead of پیام از سرور جایگزین شود
    // Navigate To Rating VC
    func navigateToRatingVC(notification: Notification) {
        
        
        let tempDic:[String:AnyObject] = notification.object! as! Dictionary<String, AnyObject>
        //print(tempDic)
        //let data:[String:AnyObject] = tempDic["data"] as! [String : AnyObject]
        //let message:String = data["details"]!["message"] as! String
        
        //let alert = UIAlertController(title: NSLocalizedString("message", comment: ""), message:message , preferredStyle: UIAlertControllerStyle.alert)
        // alert.addAction(UIAlertAction(title: NSLocalizedString("accept", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        // self.present(alert, animated: true, completion: nil)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        if self.numbeOfTappedOnMarker > 1{
            self.cancelButtonAction()
            self.backButtonForOriginAction()
        }
        
        let notificationName = Notification.Name("showAlertInRating")
        NotificationCenter.default.post(name: notificationName, object: tempDic)
    }
    
    // Show Push Notification Alert
    func showAlert(notification:Notification){
        
        let tempDic:[String:AnyObject] = notification.object! as! Dictionary<String, AnyObject>
        print(tempDic)
        let data:[String:AnyObject] = tempDic["data"] as! [String : AnyObject]
        var message:String = data["details"]!["message"] as! String
        
        message = message.removingPercentEncoding!
        message = message.replacingOccurrences(of: "+", with: " ")
        
        if let tripCode1:Int = data["details"]!["tripcode"] as? Int{
            let tripCode:Int = tripCode1
            print("Trip Code:\(tripCode)")
        }
        
        
        
        //NSLocalizedString("saveThisCode", comment: "")+String(tripCode)
        let alert = UIAlertController(title: NSLocalizedString("message", comment: ""), message:message , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("accept", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        if numbeOfTappedOnMarker > 1{
            cancelButtonAction()
            backButtonForOriginAction()
        }
    }
    
    func showCancelTripAlert(notification:Notification){
        let tempmsg:String = notification.object as! String
        
        let alert = UIAlertController(title: NSLocalizedString("cancelService", comment: ""), message:tempmsg , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("accept", comment: ""), style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setFavAddressAsOrigin(notification: Notification) {
        
        self.markerButton.frame = CGRect(x: self.mapView.frame.size.width/2 - 25, y: self.mapView.frame.size.height/2-22, width: 100 * 0.5, height: 88 * 0.5)
        self.markerButton.imageView?.contentMode = .scaleAspectFill
        
        let tempDic:[String:AnyObject] = notification.object! as! Dictionary<String, AnyObject>
        print ("tempdic:\(tempDic)")
        let lat:Double = tempDic["lat"]! as! Double
        let lon = tempDic["lon"]! as! Double
        //numbeOfTappedOnMarker = numbeOfTappedOnMarker + 1
        
        //increase height of bottom view
        //updateBottomView()
        
        //markerOrigin = nil
        //markerOrigin = GMSMarker()
        
        let twoDPos = CLLocationCoordinate2D(latitude: lat,longitude: lon)
        let camera = GMSCameraPosition.camera(withLatitude: twoDPos.latitude,
                                              longitude: twoDPos.longitude, zoom: 15)
        mapView.animate(to: camera)
        /*
         markerOrigin.position = twoDPos
         let markerImage = UIImage(named: "marker")
         markerOrigin.icon = markerImage
         markerOrigin.snippet = NSLocalizedString("origin", comment: "")
         markerOrigin.appearAnimation = kGMSMarkerAnimationPop
         markerOrigin.map = mapView
         UserDefaults.standard.set(1,forKey:"originSelected")
         
         let markerImage2 = UIImage(named: "marker2")
         markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 39, width: 49, height: 78)
         markerButton.setBackgroundImage(markerImage2, for: UIControlState())
         */
        getAddressForOrigin(latitude: twoDPos.latitude, longitude: twoDPos.longitude)
    }
    
    func setFavAddressAsDestination(notification: Notification) {
        let tempDic:[String:AnyObject] = notification.object! as! Dictionary<String, AnyObject>
        print ("tempdic:\(tempDic)")
        let lat:Double = tempDic["lat"]! as! Double
        let lon = tempDic["lon"]! as! Double
        //numbeOfTappedOnMarker = numbeOfTappedOnMarker + 1
        let twoDPos = CLLocationCoordinate2D(latitude: lat,longitude: lon)
        let camera = GMSCameraPosition.camera(withLatitude: twoDPos.latitude,
                                              longitude: twoDPos.longitude, zoom: 15)
        mapView.animate(to: camera)
        /*
         markerDestination = nil
         markerDestination = GMSMarker()
         markerDestination.position = twoDPos
         let markerImage = UIImage(named: "marker2")
         markerDestination.icon = markerImage
         markerDestination.snippet = NSLocalizedString("origin", comment: "")
         markerDestination.appearAnimation = kGMSMarkerAnimationPop
         markerDestination.map = mapView
         //if self.markerButton.currentImage!.isEqual(UIImage(named: "marker2")) {
         self.markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 39, width: 49, height: 78)
         
         markerButton.isHidden = true
         let path = GMSMutablePath()
         path.add(firstPosition.target)
         path.add(twoDPos)
         originLatitude = firstPosition.target.latitude
         originLongitude = firstPosition.target.longitude
         destLatitude = lastPosition.target.latitude
         destLongitude = lastPosition.target.longitude
         
         //let rectangle = GMSPolyline(path: path)
         //rectangle.map = self.mapView
         let bounds = GMSCoordinateBounds(path: path)
         mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding:120.0))
         mapView.isUserInteractionEnabled = false
         */
        getAddressForDestination(latitude: twoDPos.latitude, longitude: twoDPos.longitude)
    }
    func setFavAddressForOrigin(tempDic:[String:AnyObject]) {
        //let tempDic:[String:AnyObject] = self.tableArrayFavorites[0]
        let lat:Double = tempDic["lat"]! as! Double
        let lon = tempDic["lon"]! as! Double
        //numbeOfTappedOnMarker = numbeOfTappedOnMarker + 1
        
        //increase height of bottom view
        //updateBottomView()
        
        //markerOrigin = nil
        //markerOrigin = GMSMarker()
        let twoDPos = CLLocationCoordinate2D(latitude: lat,longitude: lon)
        let camera = GMSCameraPosition.camera(withLatitude: twoDPos.latitude,
                                              longitude: twoDPos.longitude, zoom: 15)
        mapView.animate(to: camera)
        /*
         markerOrigin.position = twoDPos
         let markerImage = UIImage(named: "marker")
         markerOrigin.icon = markerImage
         markerOrigin.snippet = NSLocalizedString("origin", comment: "")
         markerOrigin.appearAnimation = kGMSMarkerAnimationPop
         markerOrigin.map = mapView
         UserDefaults.standard.set(1,forKey:"originSelected")
         
         let markerImage2 = UIImage(named: "marker2")
         markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 39, width: 49, height: 78)
         markerButton.setBackgroundImage(markerImage2, for: UIControlState())
         */
        getAddressForOrigin(latitude: twoDPos.latitude, longitude: twoDPos.longitude)
    }
    
    func setFavAddressForDestination(tempDic:[String:AnyObject]) {
        //let tempDic:[String:AnyObject] = self.tableArrayFavorites[1]
        let lat:Double = tempDic["lat"]! as! Double
        let lon = tempDic["lon"]! as! Double
        //numbeOfTappedOnMarker = numbeOfTappedOnMarker + 1
        let twoDPos = CLLocationCoordinate2D(latitude: lat,longitude: lon)
        let camera = GMSCameraPosition.camera(withLatitude: twoDPos.latitude,
                                              longitude: twoDPos.longitude, zoom: 15)
        mapView.animate(to: camera)
        /*
         markerDestination = nil
         markerDestination = GMSMarker()
         markerDestination.position = twoDPos
         let markerImage = UIImage(named: "marker2")
         markerDestination.icon = markerImage
         markerDestination.snippet = NSLocalizedString("origin", comment: "")
         markerDestination.appearAnimation = kGMSMarkerAnimationPop
         markerDestination.map = mapView
         //if self.markerButton.currentImage!.isEqual(UIImage(named: "marker2")) {
         self.markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 39, width: 49, height: 78)
         
         markerButton.isHidden = true
         let path = GMSMutablePath()
         path.add(firstPosition.target)
         path.add(twoDPos)
         originLatitude = firstPosition.target.latitude
         originLongitude = firstPosition.target.longitude
         destLatitude = lastPosition.target.latitude
         destLongitude = lastPosition.target.longitude
         
         //let rectangle = GMSPolyline(path: path)
         //rectangle.map = self.mapView
         let bounds = GMSCoordinateBounds(path: path)
         mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding:120.0))
         mapView.isUserInteractionEnabled = false
         */
        getAddressForDestination(latitude: twoDPos.latitude, longitude: twoDPos.longitude)
    }
    
    func getAddressForOrigin(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        self.locality = ""
        self.subLocality = ""
        self.thoroughfare = ""

        let aGMSGeocoder: GMSGeocoder = GMSGeocoder()
        
        let twoDLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        aGMSGeocoder.reverseGeocodeCoordinate(twoDLocation) { gms , error in
            if gms != nil{
                if gms?.results()?.count != 0{
                    
                    for address in (gms?.results())!{
                        let gmsAddress: GMSAddress = address
                        if address.locality != nil{
                           if address.locality!.language() == "ar" {
                                
                                self.locality = gmsAddress.locality!
                                break
                            }
                        }
                    }
                    
                    for address in (gms?.results())!{
                        let gmsAddress: GMSAddress = address
                        
                        if address.subLocality != nil{
                            if address.subLocality!.language() == "ar" {
                                
                                self.subLocality = gmsAddress.subLocality!
                                break
                            }
                        }
                    }
                    
                    for address in (gms?.results())!{
                        let gmsAddress: GMSAddress = address
                        
                        if address.thoroughfare != nil{
                            if address.thoroughfare!.language() == "ar" {
                                self.thoroughfare = gmsAddress.thoroughfare!
                                break
                            }
                        }
                    }
                    
                    var originStr = ""
                    
                    if self.locality != nil{
                        originStr = self.locality
                    }
                    if self.subLocality != nil{
                        originStr = self.locality+"، "+self.subLocality
                    }
                    if self.thoroughfare != nil{
                        originStr = self.locality+"، "+self.subLocality+"، "+self.thoroughfare
                    }
                    self.indicatorForOriginLabel.stopAnimating()
                    self.indicatorForOriginLabel.removeFromSuperview()
                    self.originLabel.text = originStr
                    self.tikForOrigin.isHidden = false
                    
                    var frame = self.originLabel.frame
                    frame.size.width = CGFloat(self.sizeOfString(myString: originStr))
                    frame.origin.x = screenWidth/2 - frame.size.width/2
                    self.originLabel.frame = frame
                    
                    if self.horizontalLineForOrigin != nil{
                        self.horizontalLineForOrigin.removeFromSuperview()
                    }
                    self.horizontalLineForOrigin = UIView(frame: CGRect(x: frame.origin.x, y: frame.origin.y+25, width: frame.size.width, height: 1))
                    self.horizontalLineForOrigin.backgroundColor = grayColor
                    self.bgViewforOrigin.addSubview(self.horizontalLineForOrigin)
                    
                    
                    frame = self.tikForOrigin.frame
                    frame.origin.x = CGFloat(self.originLabel.frame.size.width + self.originLabel.frame.origin.x)
                    self.tikForOrigin.frame = frame
                    
                }
            }
        }
    }
    
    func getAddressForDestination(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        self.locality = ""
        self.subLocality = ""
        self.thoroughfare = ""
        
        let aGMSGeocoder: GMSGeocoder = GMSGeocoder()
        
        let twoDLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        aGMSGeocoder.reverseGeocodeCoordinate(twoDLocation) { gms , error in
            if gms != nil{
                if gms?.results()?.count != 0{
                    
                    for address in (gms?.results())!{
                        let gmsAddress: GMSAddress = address
                        if address.locality != nil{
                            if address.locality!.language() == "ar" {
                                
                                self.locality = gmsAddress.locality!
                                break
                            }
                        }
                    }
                    
                    for address in (gms?.results())!{
                        let gmsAddress: GMSAddress = address
                        
                        if address.subLocality != nil{
                            if address.subLocality!.language() == "ar" {
                                
                                self.subLocality = gmsAddress.subLocality!
                                break
                            }
                        }
                    }
                    
                    for address in (gms?.results())!{
                        let gmsAddress: GMSAddress = address
                        
                        if address.thoroughfare != nil{
                            if address.thoroughfare!.language() == "ar" {
                                self.thoroughfare = gmsAddress.thoroughfare!
                                break
                            }
                        }
                    }
                    
                    var destStr = ""
                    
                    if self.locality != nil{
                        destStr = self.locality
                    }
                    if self.subLocality != nil{
                        destStr = self.locality+"، "+self.subLocality
                    }
                    if self.thoroughfare != nil{
                        destStr = self.locality+"، "+self.subLocality+"، "+self.thoroughfare
                    }
                    if self.indicatorForDestinationLabel != nil{
                        self.indicatorForDestinationLabel.stopAnimating()
                        self.indicatorForDestinationLabel.removeFromSuperview()
                    }
                    self.destinationLabel.text = destStr
                    self.tikForDestination.isHidden = false
                    
                    var frame = self.destinationLabel.frame
                    frame.size.width = CGFloat(self.sizeOfString2(myString: destStr))
                    frame.origin.x = screenWidth/2 - frame.size.width/2
                    self.destinationLabel.frame = frame
                    
                    if self.horizontalLineForDestination != nil{
                        self.horizontalLineForDestination.removeFromSuperview()
                    }
                    self.horizontalLineForDestination = UIView(frame: CGRect(x: frame.origin.x, y: frame.origin.y+25, width: frame.size.width, height: 1))
                    self.horizontalLineForDestination.backgroundColor = grayColor
                    self.bgViewforDestination.addSubview(self.horizontalLineForDestination)
                    
                    frame = self.tikForDestination.frame
                    frame.origin.x = CGFloat(self.destinationLabel.frame.size.width + self.destinationLabel.frame.origin.x)
                    self.tikForDestination.frame = frame
                    
                    //show price
                    DispatchQueue.main.async {
                        //self.updateBottomViewToShowPrice()
                    }
                }
            }
        }
    }
    
    func setupMap() -> Void {
        let camera = GMSCameraPosition.camera(withLatitude: tehranCenterLat,
                                              longitude: tehranCenterLong,
                                              zoom: 11.0)
        // mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 64), camera:camera)
        
        mapView = GMSMapView.map(withFrame:self.view.bounds,camera:camera)
        mapView.delegate = self
        self.view.addSubview(mapView)
        if CLLocationManager.locationServicesEnabled()
            && CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.isMyLocationEnabled = true
        }
        //  self.view = mapView
        
        setCurrentUserLocation()
        
        makeBottomView()
        
        showUserLocationButton = makeButton(frame: CGRect(x: screenWidth - 50, y: bottomView.frame.origin.y - 50, width:35, height:35), backImageName: "target", backColor: nil, title: nil, titleColor: nil, isRounded: false)
        showUserLocationButton.addTarget(self, action: #selector(ViewController.showUserLocationButtonAction), for: .touchUpInside)
        mapView.addSubview(showUserLocationButton)
        
        //getFavoriteAddress()
        
        // let navigationFromRating:Bool = UserDefaults.standard.object(forKey: "navigateRatingToMap") as! Bool
        
        
        //        if  navigationFromRating == true{       //True
        //
        //            self.cancelButtonAction()
        //            self.backButtonForOriginAction()
        //
        //            UserDefaults.standard.set(false,forKey: "navigateRatingToMap")
        //        }
    }
    
    func showUserLocationButtonAction() {
        let camera = GMSCameraPosition.camera(withLatitude: (mapView.myLocation?.coordinate.latitude)!,
                                              longitude: (mapView.myLocation?.coordinate.longitude)!, zoom: 15)
        self.mapView.animate(to: camera)
    }
    
    func setCurrentUserLocation(){
        //user location stuff
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func makeBottomView(){
        bottomView = UIView(frame:CGRect(x: 0, y: 5 * screenHeight / 6, width: screenWidth, height: 1 * screenHeight / 6))
        bottomView.backgroundColor = bottomColor.withAlphaComponent(0.7)
        self.view.addSubview(bottomView)
        
        numberOfPeykLabel = UILabel(frame: CGRect(x: 0, y: 10, width: screenWidth, height: 25))
        numberOfPeykLabel.textColor = UIColor.black
        numberOfPeykLabel.font = FONT_NORMAL(13)
        numberOfPeykLabel.textAlignment = .center
        numberOfPeykLabel.backgroundColor = UIColor.clear
        bottomView.addSubview(numberOfPeykLabel)
        
        
        bgViewforOrigin = UIView(frame:CGRect(x: 0, y: 30, width: screenWidth, height: bottomView.frame.size.height))
        bgViewforOrigin.backgroundColor = UIColor.clear
        bottomView.addSubview(bgViewforOrigin)
        
        let originImageView = UIImageView(frame: CGRect(x: screenWidth/2 - 6, y: 5, width: 12, height: 12))
        originImageView.image = UIImage(named: "mabda")
        originImageView.contentMode = .scaleAspectFit
        bgViewforOrigin.addSubview(originImageView)
        
        originTtitleLabel = UILabel(frame: CGRect(x: screenWidth/2 - 15, y: 17, width: 30, height: 12))
        originTtitleLabel.textColor = UIColor.blue
        originTtitleLabel.font = FONT_NORMAL(11)
        originTtitleLabel.minimumScaleFactor = 0.5
        originTtitleLabel.adjustsFontSizeToFitWidth = true
        originTtitleLabel.textAlignment = .center
        originTtitleLabel.backgroundColor = UIColor.clear
        originTtitleLabel.text = NSLocalizedString("mabda", comment: "")
        bgViewforOrigin.addSubview(originTtitleLabel)
        
        originLabel = UILabel(frame: CGRect(x: 30, y: originTtitleLabel.frame.origin.y + originTtitleLabel.frame.size.height, width: screenWidth - 60, height: 25))
        originLabel.textColor = UIColor.black
        originLabel.font = FONT_NORMAL(11)
        originLabel.minimumScaleFactor = 0.5
        originLabel.adjustsFontSizeToFitWidth = true
        originLabel.textAlignment = .center
        originLabel.backgroundColor = UIColor.clear
        bgViewforOrigin.addSubview( originLabel)
        
        //30x25
        self.tikForOrigin = UIImageView(frame: CGRect(x: self.originLabel.frame.size.width + 30, y: self.originLabel.frame.origin.y + 3, width: 30 * 0.5, height: 25 * 0.5))
        self.tikForOrigin.image = UIImage(named: "select tik")
        self.tikForOrigin.contentMode = .scaleAspectFit
        self.bgViewforOrigin.addSubview(self.tikForOrigin)
        self.tikForOrigin.isHidden = true
        
        indicatorForOriginLabel = UIActivityIndicatorView(frame: CGRect(x: screenWidth/2-10, y: self.originLabel.frame.origin.y + 3, width:20.0, height:20.0))
        indicatorForOriginLabel.activityIndicatorViewStyle = .gray
        
        if showUserLocationButton != nil{
            var rect = showUserLocationButton.frame
            rect.origin.y = bottomView.frame.origin.y - 50
            showUserLocationButton.frame = rect
        }
        
        if isOriginSelected == true{
            getNearDrivers(latitude: lastPosition.target.latitude, longitude: lastPosition.target.longitude)
            getAddressForLatLng(latitude: lastPosition.target.latitude, longitude: lastPosition.target.longitude)
        }
    }
    
    func updateBottomView() -> Void {
        
        numberOfPeykLabel.isHidden = true
        
        var rect = bgViewforOrigin.frame
        rect.origin.y = rect.origin.y - 25
        bgViewforOrigin.frame = rect
        
        rect = showUserLocationButton.frame
        rect.origin.y = rect.origin.y - 30
        showUserLocationButton.frame = rect
        
        rect = bottomView.frame
        rect.size.height = rect.size.height + 30
        rect.origin.y = rect.origin.y - 30
        
        UIView.animate(withDuration: 0.1, animations: {
            self.bottomView.frame = rect
            
            }, completion: {(completion:Bool) in
                
                self.bgViewforDestination = UIView(frame:CGRect(x: 0, y: self.bgViewforOrigin.frame.origin.y + self.bgViewforOrigin.frame.size.height - 40, width: screenWidth, height: self.bottomView.frame.size.height))
                self.bgViewforDestination.backgroundColor = UIColor.clear
                self.bottomView.addSubview(self.bgViewforDestination)
                
                let originImageView = UIImageView(frame: CGRect(x: screenWidth/2 - 6, y: 5, width: 12, height: 12))
                originImageView.image = UIImage(named: "maghsad")
                originImageView.contentMode = .scaleAspectFit
                self.bgViewforDestination.addSubview(originImageView)
                
                self.destinationTitleLabel = UILabel(frame: CGRect(x: screenWidth/2 - 15, y: 17, width: 30, height: 12))
                self.destinationTitleLabel.textColor = UIColor.blue
                self.destinationTitleLabel.font = FONT_NORMAL(11)
                self.destinationTitleLabel.minimumScaleFactor = 0.5
                self.destinationTitleLabel.adjustsFontSizeToFitWidth = true
                self.destinationTitleLabel.textAlignment = .center
                self.destinationTitleLabel.backgroundColor = UIColor.clear
                self.destinationTitleLabel.text = NSLocalizedString("magsad", comment: "")
                self.bgViewforDestination.addSubview(self.destinationTitleLabel)
                
                self.destinationLabel = UILabel(frame: CGRect(x: 30, y: self.destinationTitleLabel.frame.origin.y + self.destinationTitleLabel.frame.size.height, width: screenWidth - 60, height: 25))
                self.destinationLabel.textColor = UIColor.black
                self.destinationLabel.font = FONT_NORMAL(11)
                self.destinationLabel.minimumScaleFactor = 0.5
                self.destinationLabel.adjustsFontSizeToFitWidth = true
                self.destinationLabel.textAlignment = .center
                self.destinationLabel.backgroundColor = UIColor.clear
                self.bgViewforDestination.addSubview(self.destinationLabel)
                
                //30x25
                self.tikForDestination = UIImageView(frame: CGRect(x: self.destinationLabel.frame.size.width + 30, y: self.destinationLabel.frame.origin.y + 3, width: 30 * 0.5, height: 25 * 0.5))
                self.tikForDestination.image = UIImage(named: "select tik")
                self.tikForDestination.contentMode = .scaleAspectFit
                self.bgViewforDestination.addSubview(self.tikForDestination)
                self.tikForDestination.isHidden = true
                
                self.indicatorForDestinationLabel = UIActivityIndicatorView(frame: CGRect(x:screenWidth/2-10, y: self.destinationLabel.frame.origin.y + 3, width:20.0, height:20.0))
                self.indicatorForDestinationLabel.activityIndicatorViewStyle = .gray
        })
    }
    
    func updateBottomViewToShowPrice() -> Void {
        
        var rect = bottomView.frame
        rect.size.height = rect.size.height + 80
        rect.origin.y = rect.origin.y - 80
        
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomView.frame = rect
            
            }, completion: {(completion:Bool) in
                
                self.bottomView.isUserInteractionEnabled = true
                self.mapView.isUserInteractionEnabled = true
                self.giftCodeButton = makeButton(frame: CGRect(x: 0, y: self.bottomView.frame.size.height - 80, width: screenWidth/2, height: 40), backImageName: nil, backColor: orangeColor2, title: NSLocalizedString("giftCode", comment: ""), titleColor: whiteColor, isRounded: false)
                self.giftCodeButton.addTarget(self, action: #selector(ViewController.giftCodeButtonAction), for: .touchUpInside)
                self.giftCodeButton.titleLabel!.font = FONT_MEDIUM(13)
                self.bottomView.addSubview(self.giftCodeButton)
                
                self.priceButton = makeButton(frame: CGRect(x: screenWidth/2, y: self.bottomView.frame.size.height - 80, width: screenWidth/2, height: 40), backImageName: nil, backColor: orangeColor1, title: "", titleColor: whiteColor, isRounded: false)
                self.priceButton.titleLabel!.font = FONT_MEDIUM(13)
                self.bottomView.addSubview(self.priceButton)
                
                self.cancelButton = makeButton(frame: CGRect(x: 0, y: self.bottomView.frame.size.height - 40, width: screenWidth/2, height: 40), backImageName: nil, backColor: blueColor2, title: NSLocalizedString("cancelIT", comment: ""), titleColor: whiteColor, isRounded: false)
                self.cancelButton.addTarget(self, action: #selector(ViewController.cancelButtonAction), for: .touchUpInside)
                self.cancelButton.titleLabel!.font = FONT_MEDIUM(13)
                self.bottomView.addSubview(self.cancelButton)
                
                self.requestPeikButton = makeButton(frame: CGRect(x: screenWidth/2, y: self.bottomView.frame.size.height - 40, width: screenWidth/2, height: 40), backImageName: nil, backColor: grayColor, title: NSLocalizedString("requestPeik", comment: ""), titleColor: whiteColor, isRounded: false)
                self.requestPeikButton.addTarget(self, action: #selector(ViewController.requestPeikButtonAction), for: .touchUpInside)
                self.requestPeikButton.titleLabel?.font = FONT_MEDIUM(15)
                self.bottomView.addSubview(self.requestPeikButton)
                
                self.getPrice()
        })
    }
    func giftCodeButtonAction(){
        updateBottomViewToShowGiftCode()
    }
    
    func updateBottomViewToShowGiftCode() -> Void {
        
        if giftCodeIsShow == false{
            
            var rect = bottomView.frame
            rect.size.height = rect.size.height + 40
            rect.origin.y = rect.origin.y - 40
            
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomView.frame = rect
                
                self.bottomView.isUserInteractionEnabled = true
                self.mapView.isUserInteractionEnabled = true
                
                self.giftCodeTextField = UITextField(frame: CGRect(x: 80,y: self.requestPeikButton.frame.origin.y+self.requestPeikButton.frame.size.height,width:screenWidth-80
                    ,height: 40))
                self.giftCodeTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("giftCode", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
                //self.giftCodeTextField.placeholder = NSLocalizedString("giftCode", comment:"")
                self.giftCodeTextField.backgroundColor = orangeColor2
                self.giftCodeTextField.font = FONT_NORMAL(15)
                self.giftCodeTextField.textColor = whiteColor
                self.giftCodeTextField.borderStyle = .none
                self.giftCodeTextField.autocorrectionType = UITextAutocorrectionType.no
                self.giftCodeTextField.keyboardType = UIKeyboardType.default
                self.giftCodeTextField.returnKeyType = UIReturnKeyType.done
                self.giftCodeTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
                self.giftCodeTextField.contentVerticalAlignment = .center
                self.giftCodeTextField.contentHorizontalAlignment = .center
                self.giftCodeTextField.textAlignment = .right
                self.giftCodeTextField.delegate=self
                self.giftCodeTextField.keyboardType = .default
                self.giftCodeTextField.tag = 13
                self.bottomView.addSubview(self.giftCodeTextField)
                
                self.giftCodeRegisterButton = makeButton(frame: CGRect(x: 0, y: self.cancelButton.frame.origin.y+self.cancelButton.frame.size.height, width: 80, height: 40), backImageName: nil, backColor: orangeColor1, title: NSLocalizedString("record", comment: ""), titleColor: whiteColor, isRounded: false)
                self.giftCodeRegisterButton.addTarget(self, action: #selector(ViewController.giftCodeRegisterButtonAction), for: .touchUpInside)
                self.giftCodeRegisterButton.titleLabel!.font = FONT_NORMAL(16)
                self.bottomView.addSubview(self.giftCodeRegisterButton)
                }, completion: {(completion:Bool) in
                    //print("arash")
            })
            giftCodeIsShow = true
        }else{
            
            var rect = bottomView.frame
            rect.size.height = rect.size.height - 40
            rect.origin.y = rect.origin.y + 40
            
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomView.frame = rect
                }, completion: {(completion:Bool) in
                    self.giftCodeTextField.removeFromSuperview()
                    self.giftCodeRegisterButton.removeFromSuperview()
            })
            
            giftCodeIsShow = false
        }
    }
    
    func giftCodeRegisterButtonAction(){
        self.giftCodeTextField.resignFirstResponder()
        registerGiftCode()
    }
    
    func requestPeikButtonAction(){
        if originLabel.text != nil {
            if destinationLabel.text != nil {
                if priceButton.titleLabel?.text != nil {
                    let mobileNumber:String? = UserDefaults.standard.object(forKey: "mobileNumber") as! String?
                    // if mobile number not set before
                    if mobileNumber == nil{
                        showMobileNumberPopup()
                    }else{
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let view = storyBoard.instantiateViewController(withIdentifier: "ReceiverInfoViewController") as! ReceiverInfoViewController
                        view.originLatitude = originLatitude
                        view.originLongitude = originLongitude
                        view.destinationLatitude = destLatitude
                        view.destinationLongitude = destLongitude
                        view.originLocationName = originLabel.text!
                        view.destinationLocationName = destinationLabel.text!
                        
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .decimal
                        formatter.groupingSeparator = ","
                        let IntShipPriceString = Int(self.shipPriceString!)
                        let NSPrice:NSNumber = NSNumber(value:IntShipPriceString!)
                        let Separator = formatter.string(from: NSPrice)
                        
                        view.shipPriceString = Separator!
                        view.totalPriceString = totalPriceString!
                        print("TOTAL PRICE:\(totalPriceString!)")
                        
                        self.cancelButtonAction()
                        //self.backButtonForOriginAction()
                        
                        self.navigationController?.pushViewController(view, animated: true)
                    }
                }
            }
        }
    }
    // Show Get Mobile Number popup
    func showMobileNumberPopup(){
        transparentView = UIView(frame: CGRect(x: 0,y: 0,width: screenWidth,height: screenHeight))
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        transparentView.isUserInteractionEnabled = true
        self.view.addSubview(transparentView)
        
        getMobilePopupView = UIView(frame: CGRect(x: 30,y: screenHeight/2-125,width: screenWidth-60,height: 250))
        getMobilePopupView.backgroundColor = whiteColor
        getMobilePopupView.layer.cornerRadius = 20
        getMobilePopupView.layer.shadowColor = UIColor.gray.cgColor
        getMobilePopupView.layer.shadowOpacity = 0.5
        getMobilePopupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        getMobilePopupView.layer.shadowRadius = 20
        self.view.addSubview(getMobilePopupView)
        
        let mobileLabel = UILabel(frame: CGRect(x: 10, y: 10, width: getMobilePopupView.frame.size.width - 20, height: 60))
        mobileLabel.backgroundColor = whiteColor
        mobileLabel.textColor = UIColor.black
        mobileLabel.font = FONT_BOLD(13)
        mobileLabel.text = NSLocalizedString("enterYourMobileNumberToSendVerifyCode", comment: "")
        mobileLabel.textAlignment = .center
        mobileLabel.numberOfLines = 2
        mobileLabel.adjustsFontSizeToFitWidth = true
        getMobilePopupView.addSubview(mobileLabel)
        
        mobileTextField = UITextField(frame: CGRect(x: mobileLabel.frame.origin.x,y: mobileLabel.frame.origin.y+70, width: mobileLabel.frame.size.width, height: 40))
        mobileTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("enterYourMobile", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //mobileTextField.placeholder = NSLocalizedString("enterYourMobile", comment: "")
        //mobileTextField.font = FONT_NORMAL(13)
        mobileTextField.textColor = UIColor.black
        mobileTextField.borderStyle = .none
        mobileTextField.autocorrectionType = UITextAutocorrectionType.no
        mobileTextField.keyboardType = UIKeyboardType.numberPad
        mobileTextField.returnKeyType = UIReturnKeyType.done
        mobileTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        mobileTextField.contentVerticalAlignment = .center
        mobileTextField.contentHorizontalAlignment = .center
        mobileTextField.textAlignment = .center
        mobileTextField.delegate = self
        mobileTextField.adjustsFontSizeToFitWidth = true
        mobileTextField.autocapitalizationType = .none
        mobileTextField.tag = 14
        getMobilePopupView.addSubview(mobileTextField)
        lineView = UIView(frame: CGRect(x: mobileTextField.frame.origin.x,y: mobileTextField.frame.origin.y+mobileTextField.frame.size.height,width: mobileTextField.frame.size.width,height: 1))
        lineView.backgroundColor = greenColor
        getMobilePopupView.addSubview(lineView)
        
        //68 × 97
        let getMobileImage = UIImageView(frame: CGRect(x: mobileTextField.frame.size.width/2-10,y: mobileTextField.frame.origin.y+55,width: 20,height: 29))
        getMobileImage.image = UIImage(named: "enterMobileImage.png")
        getMobilePopupView.addSubview(getMobileImage)
        
        
        let sendButton = makeButton(frame: CGRect(x: mobileTextField.frame.origin.x+mobileTextField.frame.size.width-50,y:getMobileImage.frame.origin.y+getMobileImage.frame.size.height + 20,width: 50,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("send", comment: ""), titleColor: topViewBlue, isRounded: false)
        sendButton.addTarget(self, action: #selector(ViewController.sendButtonAction), for: .touchUpInside)
        getMobilePopupView.addSubview(sendButton)
        let closeButton = makeButton(frame: CGRect(x: mobileTextField.frame.origin.x,y: getMobileImage.frame.origin.y+getMobileImage.frame.size.height + 20,width: 50,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("close", comment: ""), titleColor: UIColor.red, isRounded: false)
        closeButton.addTarget(self, action: #selector(ViewController.closeButtonAction), for: .touchUpInside)
        getMobilePopupView.addSubview(closeButton)
    }
    
    func sendButtonAction(){
        //Call setSubscriberMobile Connection
        setSubscriberMobile()
    }
    
    // Close Get Mobile popup
    func closeButtonAction(){
        getMobilePopupView.removeFromSuperview()
        transparentView.removeFromSuperview()
    }
    
    // Show Verification Popup
    func showVerifyPopup(){
        closeButtonAction()
        if verificationPopupView != nil{
            verificationTransparentView.removeFromSuperview()
            verificationPopupView.removeFromSuperview()
        }
        verificationTransparentView = UIView(frame: CGRect(x: 0,y: 0,width: screenWidth,height: screenHeight))
        verificationTransparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        verificationTransparentView.isUserInteractionEnabled = true
        self.view.addSubview(verificationTransparentView)
        
        verificationPopupView = UIView(frame: CGRect(x: 50,y: screenHeight/2-135,width: screenWidth-100,height: 270))
        verificationPopupView.backgroundColor = whiteColor
        verificationPopupView.layer.cornerRadius = 20
        verificationPopupView.layer.shadowColor = UIColor.gray.cgColor
        verificationPopupView.layer.shadowOpacity = 0.5
        verificationPopupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        verificationPopupView.layer.shadowRadius = 20
        self.view.addSubview(verificationPopupView)
        
        let verificationCodeLabel = UILabel(frame: CGRect(x: 10, y: 10, width: verificationPopupView.frame.size.width - 20, height: 60))
        verificationCodeLabel.backgroundColor = whiteColor
        verificationCodeLabel.textColor = UIColor.black
        verificationCodeLabel.font = FONT_BOLD(13)
        verificationCodeLabel.text = NSLocalizedString("enterVerificationCode", comment: "")
        verificationCodeLabel.textAlignment = .center
        verificationCodeLabel.adjustsFontSizeToFitWidth = true
        verificationCodeLabel.numberOfLines = 2
        
        verificationPopupView.addSubview(verificationCodeLabel)
        
        verificationCodeTextField = UITextField(frame: CGRect(x: verificationCodeLabel.frame.origin.x,y: verificationCodeLabel.frame.origin.y+70, width: verificationCodeLabel.frame.size.width, height: 40))
        verificationCodeTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("verificationCode", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //verificationCodeTextField.placeholder = NSLocalizedString("verificationCode", comment: "")
        //verificationCodeTextField.font = FONT_NORMAL(20)
        verificationCodeTextField.textColor = UIColor.black
        verificationCodeTextField.borderStyle = .none
        verificationCodeTextField.autocorrectionType = UITextAutocorrectionType.no
        verificationCodeTextField.keyboardType = UIKeyboardType.numberPad
        verificationCodeTextField.returnKeyType = UIReturnKeyType.done
        verificationCodeTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        verificationCodeTextField.contentVerticalAlignment = .center
        verificationCodeTextField.contentHorizontalAlignment = .center
        verificationCodeTextField.textAlignment = .center
        verificationCodeTextField.delegate = self
        verificationCodeTextField.adjustsFontSizeToFitWidth = true
        verificationCodeTextField.autocapitalizationType = .none
        verificationCodeTextField.tag = 15
        verificationPopupView.addSubview(verificationCodeTextField)
        lineView = UIView(frame: CGRect(x: verificationCodeTextField.frame.origin.x,y: verificationCodeTextField.frame.origin.y+45,width: verificationCodeTextField.frame.size.width,height: 1))
        lineView.backgroundColor = greenColor
        verificationPopupView.addSubview(lineView)
        
        let resendCodeButton = UIButton(frame: CGRect(x: verificationCodeTextField.frame.origin.x,y: verificationCodeTextField.frame.origin.y+80,width: verificationCodeTextField.frame.size.width,height: 50))
        resendCodeButton.backgroundColor = UIColor.white
        resendCodeButton.titleLabel?.font = FONT_MEDIUM(15)
        resendCodeButton.setTitle(NSLocalizedString("resendVerificationCode", comment: ""), for:UIControlState())
        resendCodeButton.setTitleColor(buttonColor1,for: UIControlState())
        resendCodeButton.addTarget(self, action: #selector(ViewController.resendCodeAction), for: .touchUpInside)
        verificationPopupView.addSubview(resendCodeButton)
        
        let verificationSendButton = makeButton(frame: CGRect(x: verificationCodeTextField.frame.origin.x+verificationCodeTextField.frame.size.width-50,y: verificationCodeTextField.frame.origin.y+verificationCodeTextField.frame.size.height+80,width: 50,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("record", comment: ""), titleColor: topViewBlue, isRounded: false)
        verificationSendButton.addTarget(self, action: #selector(ViewController.verificationSendButtonAction), for: .touchUpInside)
        verificationPopupView.addSubview(verificationSendButton)
        let verificationCloseButton = makeButton(frame: CGRect(x: verificationCodeTextField.frame.origin.x,y: verificationCodeTextField.frame.origin.y+verificationCodeTextField.frame.size.height+80,width: 50,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("close", comment: ""), titleColor: UIColor.red, isRounded: false)
        verificationCloseButton.addTarget(self, action: #selector(ViewController.verificationCloseButtonAction), for: .touchUpInside)
        verificationPopupView.addSubview(verificationCloseButton)
    }
    
    func verificationSendButtonAction(){
        verifySubscriberMobile()
    }
    
    // Close Verification Popup View
    func verificationCloseButtonAction(){
        verificationPopupView.removeFromSuperview()
        verificationTransparentView.removeFromSuperview()
    }
    
    // Resend Verification Code
    func resendCodeAction(){
        setSubscriberMobile()
        //resendVerificationCode()
    }
    
    // Cancel Trip
    func cancelButtonAction() {
        mapView.settings.setAllGesturesEnabled(true)
        markerButton.isUserInteractionEnabled = false
        if favButton1 != nil{
            favButton1.isHidden = false
        }
        
        if closeButtonForDestination != nil{
            backButtonForOrigin.isHidden = false
            closeButtonForDestination.removeFromSuperview()
        }
        
        giftCodeIsShow = false
        
        if favButton1 != nil{
            favButton1.isUserInteractionEnabled = true
        }
        if favButton2 != nil{
            favButton2.isUserInteractionEnabled = true
        }
        
        //reset markers
        mapView.isUserInteractionEnabled = true
        numbeOfTappedOnMarker = 1
        //self.markerOrigin.map = nil
        if self.markerDestination != nil{
            self.markerDestination.map = nil
        }
        
        
        if self.markerButton != nil{
            self.markerButton.isHidden = false
        }
        
        //        let markerImage3 = UIImage(named: "marker2")
        //        markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 39, width: 49, height: 78)
        //        markerButton.setBackgroundImage(markerImage3, for: UIControlState())
        //originLabel.text = ""
        //destinationLabel.text = ""
        if bottomView != nil{
            var rect = bottomView.frame
            rect.size.height = rect.size.height - 80
            rect.origin.y = rect.origin.y + 80
            bottomView.frame = rect
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            //   self.bottomView.frame = rect
            }, completion: {(completion:Bool) in
                if self.giftCodeButton != nil{
                    self.giftCodeButton.removeFromSuperview()
                    self.priceButton.removeFromSuperview()
                    self.cancelButton.removeFromSuperview()
                    self.requestPeikButton.removeFromSuperview()
                }
        })
        
        //clear for favorite address
        UserDefaults.standard.set(1,forKey:"originSelected")
        
        getAddressForLatLng(latitude: lastPosition.target.latitude, longitude: lastPosition.target.longitude)
    }
    
    /*
     //observer Call from Menu VC when user logout work  same as CancelButtonAction() Method
     func logoutCancel(notification:Notification) {
     mapView.settings.setAllGesturesEnabled(true)
     markerButton.isUserInteractionEnabled = false
     if favButton1 != nil{
     favButton1.isHidden = false
     }
     
     if closeButtonForDestination != nil{
     backButtonForOrigin.isHidden = false
     closeButtonForDestination.removeFromSuperview()
     }
     
     giftCodeIsShow = false
     
     if favButton1 != nil{
     favButton1.isUserInteractionEnabled = true
     }
     if favButton2 != nil{
     favButton2.isUserInteractionEnabled = true
     }
     
     //reset markers
     mapView.isUserInteractionEnabled = true
     numbeOfTappedOnMarker = 1
     //self.markerOrigin.map = nil
     if self.markerDestination != nil{
     self.markerDestination.map = nil
     }
     
     
     if self.markerButton != nil{
     self.markerButton.isHidden = false
     }
     
     //        let markerImage3 = UIImage(named: "marker2")
     //        markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 39, width: 49, height: 78)
     //        markerButton.setBackgroundImage(markerImage3, for: UIControlState())
     //originLabel.text = ""
     //destinationLabel.text = ""
     if bottomView != nil{
     var rect = bottomView.frame
     rect.size.height = rect.size.height - 80
     rect.origin.y = rect.origin.y + 80
     bottomView.frame = rect
     }
     
     UIView.animate(withDuration: 0.5, animations: {
     //   self.bottomView.frame = rect
     }, completion: {(completion:Bool) in
     if self.giftCodeButton != nil{
     self.giftCodeButton.removeFromSuperview()
     self.priceButton.removeFromSuperview()
     self.cancelButton.removeFromSuperview()
     self.requestPeikButton.removeFromSuperview()
     }
     })
     
     //clear for favorite address
     UserDefaults.standard.set(1,forKey:"originSelected")
     
     getAddressForLatLng(latitude: lastPosition.target.latitude, longitude: lastPosition.target.longitude)
     }
     */
    func markerButtonAction(){
        markerButton.isUserInteractionEnabled = false
        numbeOfTappedOnMarker = numbeOfTappedOnMarker + 1
        
        if numbeOfTappedOnMarker == 1 {
            //increase height of bottom view
            updateBottomView()
            
            markerOrigin = nil
            markerOrigin = GMSMarker()
            markerOrigin.position = firstPosition.target
            let markerImage = UIImage(named: "marker")
            
            markerOrigin.icon = markerImage
            markerOrigin.snippet = NSLocalizedString("origin", comment: "")
            markerOrigin.appearAnimation = kGMSMarkerAnimationPop
            markerOrigin.map = mapView
            UserDefaults.standard.set(1,forKey:"originSelected")
            
            updateTopbarElements()
            
            UIView.animate(withDuration: 0.3, animations: {
                //                let twoDLocation2 = CLLocationCoordinate2D(latitude: self.lastPosition.target.latitude, longitude: self.lastPosition.target.longitude)
                //                let camera = GMSCameraPosition.camera(withLatitude: twoDLocation2.latitude+0.000003,
                //                                                      longitude: twoDLocation2.longitude, zoom: 15)
                //                self.mapView.animate(to: camera)
                let location:CLLocationCoordinate2D = self.mapView.projection.coordinate(for: CGPoint(x: screenWidth/2, y:screenHeight/2 - 160))
                let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15)
                self.mapView.animate(to: camera)
                let markerImage2 = UIImage(named: "marker2")
                self.markerButton.frame = CGRect(x: self.mapView.frame.size.width/2 - 25, y: self.mapView.frame.size.height/2-40, width: 100 * 0.5, height: 159 * 0.5)
                self.markerButton.imageView?.contentMode = .scaleAspectFill
                self.markerButton.setBackgroundImage(markerImage2, for: .normal)
                //self.getAddressForLatLng(latitude:location.latitude, longitude: location.longitude)
            })
            
        }
        if numbeOfTappedOnMarker == 2 {
            
            markerDestination = nil
            markerDestination = GMSMarker()
            markerDestination.position = lastPosition.target
            let markerImage = UIImage(named: "marker2")
            markerDestination.icon = markerImage
            markerDestination.snippet = NSLocalizedString("origin", comment: "")
            markerDestination.appearAnimation = kGMSMarkerAnimationPop
            markerDestination.map = mapView
            //if self.markerButton.currentImage!.isEqual(UIImage(named: "marker2")) {
            self.markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 40, width: 100 * 0.5, height: 159 * 0.5)
            
            markerButton.isHidden = true
            let path = GMSMutablePath()
            path.add(firstPosition.target)
            path.add(lastPosition.target)
            originLatitude = firstPosition.target.latitude
            originLongitude = firstPosition.target.longitude
            destLatitude = lastPosition.target.latitude
            destLongitude = lastPosition.target.longitude
            //let rectangle = GMSPolyline(path: path)
            //rectangle.map = self.mapView
            let bounds = GMSCoordinateBounds(path: path)
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding:120.0))
            mapView.isUserInteractionEnabled = false
            mapView.settings.setAllGesturesEnabled(false)
            //show price
            // self.getAddressForLatLng(latitude:destLatitude, longitude: destLongitude)
            updateBottomViewToShowPrice()
            
            updateTopbarElements()
        }
    }
    
    func updateTopbarElements(){
        if numbeOfTappedOnMarker == 1{
            var frame = searchButton.frame
            frame.origin.x = 60
            searchButton.frame = frame
            
            backButtonForOrigin = makeButton(frame: CGRect(x: 10, y: 20, width: 40, height: 40), backImageName: "TopViewBack", backColor: nil, title: nil, titleColor: nil, isRounded: false)
            backButtonForOrigin.addTarget(self, action: #selector(ViewController.backButtonForOriginAction), for: .touchUpInside)
            topView.addSubview(backButtonForOrigin)
        }else if numbeOfTappedOnMarker == 2{
            backButtonForOrigin.isHidden = true
            if closeButtonForDestination != nil{
                closeButtonForDestination.removeFromSuperview()
            }
            closeButtonForDestination = makeButton(frame: CGRect(x: 10, y: 25, width: 30, height: 30), backImageName: "menu_back", backColor: nil, title: nil, titleColor: nil, isRounded: false)
            closeButtonForDestination.addTarget(self, action: #selector(ViewController.closeButtonForDestinationAction), for: .touchUpInside)
            topView.addSubview(closeButtonForDestination)
        }
    }
    
    func backButtonForOriginAction(){
        mapView.settings.setAllGesturesEnabled(true)
        isOriginSelected = true
        markerButton.isUserInteractionEnabled = false
        if favButton1 != nil{
            favButton1.isHidden = false
        }
        numbeOfTappedOnMarker = 0
        self.markerOrigin.map = nil
        backButtonForOrigin.removeFromSuperview()
        var frame = searchButton.frame
        frame.origin.x = 20
        searchButton.frame = frame
        bottomView.removeFromSuperview()
        makeBottomView()
        
        let markerImage2 = UIImage(named: "marker")
        
        markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 22, width: 100 * 0.5, height:88 * 0.5)
        markerButton.setBackgroundImage(markerImage2, for: .normal)
        
        getNearDrivers(latitude: lastPosition.target.latitude, longitude: lastPosition.target.longitude)
        getAddressForLatLng(latitude: lastPosition.target.latitude, longitude: lastPosition.target.longitude)
        
        UserDefaults.standard.set(0,forKey:"originSelected")
    }
    /*
     //observer Call from Menu VC when user logout work  same as backButtonForOriginAction() Method
     func backButtonForMap(notification:Notification){
     mapView.settings.setAllGesturesEnabled(true)
     isOriginSelected = true
     markerButton.isUserInteractionEnabled = false
     if favButton1 != nil{
     favButton1.isHidden = false
     }
     numbeOfTappedOnMarker = 0
     self.markerOrigin.map = nil
     backButtonForOrigin.removeFromSuperview()
     var frame = searchButton.frame
     frame.origin.x = 20
     searchButton.frame = frame
     bottomView.removeFromSuperview()
     makeBottomView()
     
     let markerImage2 = UIImage(named: "marker")
     
     markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 22, width: 100 * 0.5, height:88 * 0.5)
     markerButton.setBackgroundImage(markerImage2, for: .normal)
     
     getNearDrivers(latitude: lastPosition.target.latitude, longitude: lastPosition.target.longitude)
     getAddressForLatLng(latitude: lastPosition.target.latitude, longitude: lastPosition.target.longitude)
     
     UserDefaults.standard.set(0,forKey:"originSelected")
     }
     */
    
    func closeButtonForDestinationAction(){
        if favButton1 != nil{
            favButton1.isHidden = false
        }
        numbeOfTappedOnMarker = 1
        self.markerDestination.map = nil
        closeButtonForDestination.removeFromSuperview()
        backButtonForOrigin.isHidden = false
        
        //        bottomView.removeFromSuperview()
        //        makeBottomView()
        //        updateBottomView()
        
        //markerButton.removeFromSuperview()
        self.markerButton.isHidden = false
        let markerImage2 = UIImage(named: "marker2")
        
        markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 40, width: 100 * 0.5, height: 159 * 0.5)
        markerButton.setBackgroundImage(markerImage2, for: .normal)
        
        cancelButtonAction()
        
        UserDefaults.standard.set(1,forKey:"originSelected")
        
        //getNearDrivers(latitude: lastPosition.target.latitude, longitude: lastPosition.target.longitude)
        //getAddressForLatLng(latitude: lastPosition.target.latitude, longitude: lastPosition.target.longitude)
    }
    
    override func menuAction(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        //self.presentViewController(nextViewController, animated:true, completion:nil)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    // Check to Show Intro View Controller
    func checkToShowIntroView(){
        if(!UserDefaults.standard.bool(forKey: "firstlaunch1.0")){
            //Put any code here and it will be executed only once.
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "IntroViewController") as! IntroViewController
            self.present(nextViewController, animated: true, completion: nil)
            UserDefaults.standard.set(false, forKey: "firstlaunch1.0")
            //NSUserDefaults.standardUserDefaults().synchronize();
        }
        else{
            //TODO:UnComment this later
            getLastInProgressTrip()
        }
    }
    // Draw Near Drivers Pin On Map
    func drawPinOnMap(twoDLocation:CLLocationCoordinate2D, rotation:Int?){
        DispatchQueue.main.async {
            let marker = GMSMarker(position: twoDLocation)
            marker.position = twoDLocation//CLLocationCoordinate2D(latitude: 35.753467, longitude:51.694948)
            let markerImage = UIImage(named: "motor")
            marker.icon = markerImage
            marker.snippet = NSLocalizedString("origin", comment: "")
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = self.mapView
            // marker.rotation = CLLocationDegrees(rotation!)
            self.markersArray.append(marker)
        }
    }
    
    func removeMarkers(mapView: GMSMapView){
        for object in self.markersArray {
            object.map = nil
        }
    }
    
    func sizeOfString(myString:String) -> Float {
        //CGSize expectedLabelSize = [yourString sizeWithFont:yourLabel.font
        //  constrainedToSize:maximumLabelSize
        // lineBreakMode:yourLabel.lineBreakMode];
        let width:Float =  Float(originLabel.intrinsicContentSize.width)
        return width
        
    }
    
    func sizeOfString2(myString:String) -> Float {
        //CGSize expectedLabelSize = [yourString sizeWithFont:yourLabel.font
        //  constrainedToSize:maximumLabelSize
        // lineBreakMode:yourLabel.lineBreakMode];
        let width:Float =  Float(destinationLabel.intrinsicContentSize.width)
        return width
        
    }
    
    func favButton1Action(){
        //favButton1.isHidden = true
        let originSelected:Int! = UserDefaults.standard.object(forKey: "originSelected") as? Int
        let tempDic:[String:AnyObject] = self.tableArrayFavorites[0]
        if originSelected != nil{
            if originSelected == 0 {
                setFavAddressForOrigin(tempDic: tempDic)
            }else if originSelected == 1{
                setFavAddressForDestination(tempDic: tempDic)
            }
        }
    }
    
    func favButton2Action(){
        let originSelected:Int! = UserDefaults.standard.object(forKey: "originSelected") as? Int
        let tempDic:[String:AnyObject] = self.tableArrayFavorites[1]
        if originSelected != nil{
            if originSelected == 0 {
                setFavAddressForOrigin(tempDic: tempDic)
            }else if originSelected == 1{
                setFavAddressForDestination(tempDic: tempDic)
            }
        }
    }
    
    func threeDotButtonAction(){
        //navigate to fav list view
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SelectedAddressViewController") as! SelectedAddressViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //Search button tapped
    func searchButtonAction(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    //MARK: -  google map delegate
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.markerButton.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            self.removeMarkers(mapView: mapView)
        }
        
        if numbeOfTappedOnMarker == 0 {
            //show spinner on Price button
            indicatorForOriginLabel.startAnimating()
            self.bgViewforOrigin.addSubview(indicatorForOriginLabel)
            self.tikForOrigin.isHidden = true
            
            var frame = self.originLabel.frame
            frame.size.width = CGFloat(self.sizeOfString(myString: ""))
            frame.origin.x = screenWidth/2 - frame.size.width/2
            self.originLabel.frame = frame
            
            frame = self.indicatorForOriginLabel.frame
            frame.origin.x = CGFloat(self.originLabel.frame.size.width + self.originLabel.frame.origin.x)
            self.indicatorForOriginLabel.frame = frame
            
            UIView.animate(withDuration: 0.3, animations: {
                self.markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 13, y: mapView.frame.size.height/2 - 11, width: 50 * 0.5, height: 44 * 0.5)
            })
            firstPosition = position
        }else if numbeOfTappedOnMarker == 1{
            //show spinner on Price button
            if indicatorForDestinationLabel != nil {
                indicatorForDestinationLabel.startAnimating()
                self.bgViewforDestination.addSubview(indicatorForDestinationLabel)
                
                self.tikForDestination.isHidden = true
                
                var frame = self.destinationLabel.frame
                frame.size.width = CGFloat(self.sizeOfString2(myString: ""))
                frame.origin.x = screenWidth/2 - frame.size.width/2
                self.destinationLabel.frame = frame
                
                frame = self.indicatorForDestinationLabel.frame
                frame.origin.x = CGFloat(self.destinationLabel.frame.size.width + self.destinationLabel.frame.origin.x)
                self.indicatorForDestinationLabel.frame = frame
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 13, y: mapView.frame.size.height/2 - 20, width: 50 * 0.5, height: 80 * 0.5)
                })
                lastPosition = position
            }
        }
    }
    func getAddressForLatLng(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        self.locality = ""
        self.subLocality = ""
        self.thoroughfare = ""
        
        let aGMSGeocoder: GMSGeocoder = GMSGeocoder()
        
        let twoDLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        aGMSGeocoder.reverseGeocodeCoordinate(twoDLocation) { gms , error in
            if gms != nil{
                if gms?.results()?.count != 0{
                    
                    for address in (gms?.results())!{
                        let gmsAddress: GMSAddress = address
                        if address.locality != nil{
                            //                            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
                            //                            if address.locality!.rangeOfCharacter(from: characterset.inverted) != nil {
                            // //                               print("string contains special characters")
                            ////                                //self.locality = gmsAddress.locality!
                            //                                //print("locality=\(gmsAddress.locality!)")
                            // //                               break
                            if address.locality!.language() == "ar" {
                                
                                self.locality = gmsAddress.locality!
                                break
                            }
                        }
                    }
                    
                    for address in (gms?.results())!{
                        let gmsAddress: GMSAddress = address
                        
                        if address.subLocality != nil{
                            //let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
                            if address.subLocality!.language() == "ar" {
                                
                                self.subLocality = gmsAddress.subLocality!
                                break
                            }
                        }
                    }
                    
                    for address in (gms?.results())!{
                        let gmsAddress: GMSAddress = address
                        
                        if address.thoroughfare != nil{
                            //let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
                            if address.thoroughfare!.language() == "ar" {
                                //print("Language:=\(address.thoroughfare!.language())")
                                self.thoroughfare = gmsAddress.thoroughfare!
                                break
                            }else{
                                //                                self.thoroughfare = gmsAddress.thoroughfare!
                                //                                break
                            }
                        }
                    }
                    
//                    for address in (gms?.results())!{
//                        let gmsAddress: GMSAddress = address
//                        
//                        if address.lines != nil{
//                            //let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
//                            //if gmsAddress.lines.language() == "ar" {
//                                //print("Language:=\(address.thoroughfare!.language())")
//                                self.lastPart = gmsAddress.lines
//                                break
//                            //}else{
//                                //                                self.thoroughfare = gmsAddress.thoroughfare!
//                                //                                break
//                           // }
//                        }
//                    }

                    
                    //                     print("\ncoordinate.latitude=\(gmsAddress.coordinate.latitude)")
                    //                     print("coordinate.longitude=\(gmsAddress.coordinate.longitude)")
                    //                     print("thoroughfare=\(gmsAddress.thoroughfare)")
                    //                     print("locality=\(gmsAddress.locality)")
                    //                     print("subLocality=\(gmsAddress.subLocality)")
                    //                     print("administrativeArea=\(gmsAddress.administrativeArea)")
                    //                     print("postalCode=\(gmsAddress.postalCode)")
                    //                     print("country=\(gmsAddress.country)")
                    //                     print("lines=\(gmsAddress.lines)")
                    //                     print("lines=\(gmsAddress.description)")
                    //}
                    
                    self.markerButton.isUserInteractionEnabled = true
                    
                    if self.numbeOfTappedOnMarker == 0 {
                        var originStr = ""
                        
                        if self.locality != nil{
                            originStr = self.locality
                        }
                        if self.subLocality != nil{
                            originStr = self.locality+"، "+self.subLocality
                        }
                        if self.thoroughfare != nil{
                            originStr = self.locality+"، "+self.subLocality+"، "+self.thoroughfare
                        }
                        
//                        if self.lastPart != nil{
//                            originStr = self.locality+"."+self.subLocality+"."+self.thoroughfare
//                            originStr = originStr+"."+self.lastPart[0]
//                        }
                        
                        //originStr = self.locality+"٫"+self.subLocality+"٫"+self.thoroughfare
                        // if gmsAddress.locality != nil{
                        //                            originStr = gmsAddress.locality!
                        //                        }
                        //                        if gmsAddress.subLocality != nil{
                        //                            originStr = originStr + " " + gmsAddress.subLocality!
                        //                        }
                        //                        if gmsAddress.thoroughfare != nil{
                        //                            originStr = originStr + " " + gmsAddress.thoroughfare!
                        //                        }
                        
                        if originStr.characters.count == 0{
                            self.markerButton.isUserInteractionEnabled = false
                        } else{
                            
                            self.indicatorForOriginLabel.stopAnimating()
                            self.indicatorForOriginLabel.removeFromSuperview()
                            self.originLabel.text = originStr
                            self.tikForOrigin.isHidden = false
                            
                            var frame = self.originLabel.frame
                            frame.size.width = CGFloat(self.sizeOfString(myString: originStr))
                            frame.origin.x = screenWidth/2 - frame.size.width/2
                            self.originLabel.frame = frame
                            
                            if self.horizontalLineForOrigin != nil{
                                self.horizontalLineForOrigin.removeFromSuperview()
                            }
                            self.horizontalLineForOrigin = UIView(frame: CGRect(x: frame.origin.x, y: frame.origin.y+25, width: frame.size.width, height: 1))
                            self.horizontalLineForOrigin.backgroundColor = grayColor
                            self.bgViewforOrigin.addSubview(self.horizontalLineForOrigin)
                            
                            
                            frame = self.tikForOrigin.frame
                            frame.origin.x = CGFloat(self.originLabel.frame.size.width + self.originLabel.frame.origin.x)
                            self.tikForOrigin.frame = frame
                        }
                        
                    }else if self.numbeOfTappedOnMarker == 1{
                        var destStr = ""
                        
                        if self.locality != nil{
                            destStr = self.locality
                        }
                        if self.subLocality != nil{
                            destStr = self.locality+"، "+self.subLocality
                        }
                        if self.thoroughfare != nil{
                            destStr = self.locality+"، "+self.subLocality+"، "+self.thoroughfare
                        }
                        
                        //destStr = self.locality+"."+self.subLocality+"."+self.thoroughfare
                        
                        //                        if gmsAddress.locality != nil{
                        //                            destStr = gmsAddress.locality!
                        //                        }
                        //                        if gmsAddress.subLocality != nil{
                        //                            destStr = destStr + " " + gmsAddress.subLocality!
                        //                        }
                        //                        if gmsAddress.thoroughfare != nil{
                        //                            destStr = destStr + " " + gmsAddress.thoroughfare!
                        //                        }
                        
                        if destStr.characters.count < 5{
                            self.markerButton.isUserInteractionEnabled = false
                        }else{
                            if self.indicatorForDestinationLabel != nil{
                                self.indicatorForDestinationLabel.stopAnimating()
                                self.indicatorForDestinationLabel.removeFromSuperview()
                            }
                            self.destinationLabel.text = destStr
                            self.tikForDestination.isHidden = false
                            
                            var frame = self.destinationLabel.frame
                            frame.size.width = CGFloat(self.sizeOfString2(myString: destStr))
                            frame.origin.x = screenWidth/2 - frame.size.width/2
                            self.destinationLabel.frame = frame
                            
                            if self.horizontalLineForDestination != nil{
                                self.horizontalLineForDestination.removeFromSuperview()
                            }
                            self.horizontalLineForDestination = UIView(frame: CGRect(x: frame.origin.x, y: frame.origin.y+25, width: frame.size.width, height: 1))
                            self.horizontalLineForDestination.backgroundColor = grayColor
                            self.bgViewforDestination.addSubview(self.horizontalLineForDestination)
                            
                            frame = self.tikForDestination.frame
                            frame.origin.x = CGFloat(self.destinationLabel.frame.size.width + self.destinationLabel.frame.origin.x)
                            self.tikForDestination.frame = frame
                        }
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if numbeOfTappedOnMarker == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 22, width: 100 * 0.5, height: 88 * 0.5)
            })
            
            getNearDrivers(latitude: position.target.latitude, longitude: position.target.longitude)
            
        }else if numbeOfTappedOnMarker == 1{
            UIView.animate(withDuration: 0.3, animations: {
                self.markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 39, width: 100 * 0.5, height: 159 * 0.5)
            })
        }
        
        //update last position
        lastPosition = position
        getAddressForLatLng(latitude: lastPosition.target.latitude, longitude: lastPosition.target.longitude)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        UIView.animate(withDuration: 0.5, animations: {
            mapView.animate(toLocation: marker.position)
        })
        
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        //let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 15)
        mapView.animate(to: camera)
        //let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.isMyLocationEnabled = true
        //self.view = mapView
        
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: -  Connection
    func getPrice(){
        
        //set to 2 to avoid multiple selection in SearcViewController and SelectedAddressViewController
        UserDefaults.standard.set(2,forKey:"originSelected")
        
        if favButton1 != nil{
            favButton1.isUserInteractionEnabled = false
        }
        if favButton2 != nil{
            favButton2.isUserInteractionEnabled = false
        }
        //show spinner on Price button
        if indicatorForPrice != nil{
            indicatorForPrice.removeFromSuperview()
        }
        indicatorForPrice = UIActivityIndicatorView(frame: CGRect(x:self.priceButton.frame.size.width/2 - 20.0, y:0.0, width:40.0, height:40.0))
        indicatorForPrice.activityIndicatorViewStyle = .white
        //indicator.center = view.center
        indicatorForPrice.startAnimating()
        self.priceButton.addSubview(indicatorForPrice)
        
        
        let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
        if sessionID != nil {
            let hasReturn:Int = 2
            
            let params :Dictionary<String,AnyObject> =
                ["sessionid": sessionID! as AnyObject,
                 "origlatitude": originLatitude as AnyObject,
                 "origlongitude": originLongitude as AnyObject,
                 "destlatitude": destLatitude as AnyObject,
                 "destlongitude": destLongitude as AnyObject,
                 "hasreturn": hasReturn as AnyObject
                    //"discountcode": messageTextView.text! as AnyObject
            ]
            
            getPriceWithCallBack(apiName: "trip/getprice", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        let shipprice:Int? = responseDic.object(forKey: "shipprice") as? Int
                        let totalPrice:Int? = responseDic.object(forKey: "totalprice") as? Int
                        DispatchQueue.main.async {
                            self.indicatorForPrice.stopAnimating()
                            if shipprice != nil{
                                self.shipPriceString = "\(shipprice!)"
                                
                                let formatter = NumberFormatter()
                                formatter.numberStyle = .decimal
                                formatter.groupingSeparator = ","
                                let IntShipPriceString = Int(shipprice!)
                                let NSPrice:NSNumber = NSNumber(value:IntShipPriceString)
                                let Separator = formatter.string(from: NSPrice)
                                self.requestPeikButton.backgroundColor = blueColor1
                                self.priceButton.setTitle("\(Separator!)"+NSLocalizedString("rial", comment: ""), for: .normal)
                            }
                            
                            if totalPrice != nil{
                                
                                let formatter = NumberFormatter()
                                formatter.numberStyle = .decimal
                                formatter.groupingSeparator = ","
                                let IntTotalPrice = Int(totalPrice!)
                                let NSPrice:NSNumber = NSNumber(value:IntTotalPrice)
                                let SeparatedNumber = formatter.string(from: NSPrice)
                                
                                self.totalPriceString = "\(SeparatedNumber!)"
                            }
                            
                            
                            if shipprice == nil && totalPrice == nil{
                                DispatchQueue.main.async {
                                    self.getPrice()
                                    /*
                                     let msg:String = NSLocalizedString("NOPrice", comment: "")
                                     let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:msg , preferredStyle: UIAlertControllerStyle.alert)
                                     alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                                     self.present(alert, animated: true, completion: nil)
                                     */
                                }
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
                    DispatchQueue.main.async {
                        self.indicatorForPrice.stopAnimating()
                    }
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
    // Get Near Drivers Connection
    func getNearDrivers(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
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
        
        //        if ARSLineProgress.shown { return }
        //
        //        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        //            print("Showed with completion block")
        //        }
        let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
        if sessionID != nil {
            let params :Dictionary<String,String> = ["sessionid": sessionID! as String,
                                                     "latitude":"\(latitude)" as String,
                                                     "longitude":"\(longitude)" as String
            ]
            getNearDriversWithCallBack(apiName: "location/getneardriver", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                if let responseDic = resDic{
                    
                    if (resDic?.object(forKey: "status") as! Int) == 1{
                        
                        if let motorsArray = responseDic["data"] as? NSArray {
                            for motor in motorsArray {
                                let motorCount:Int = motorsArray.count
                                DispatchQueue.main.async {
                                    self.numberOfPeykLabel.text =  "\(motorCount)" + "پیک موتوری موجود است"
                                }
                                
                                let motorObject = motor as! Dictionary<String,AnyObject>
                                //if ((motor["latitude"])as? [String : String])?["Type"] != nil){
                                //if motor["longitude"] != nil{
                                let motorLatitude:CLLocationDegrees = (motorObject["latitude"])! as! CLLocationDegrees
                                let motorLongitude:CLLocationDegrees = (motorObject["longitude"])! as! CLLocationDegrees
                                let twoDLocation2 = CLLocationCoordinate2D(latitude: motorLatitude, longitude: motorLongitude)
                                if let degree = motorObject["degree"]{
                                    let roation:Int? = degree as? Int//(motorObject["degree"] as! Int)
                                    DispatchQueue.main.async {
                                        self.drawPinOnMap(twoDLocation: twoDLocation2, rotation:roation!)
                                    }
                                }
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
    
    // Set Subscriber Mobile Number Connection
    func setSubscriberMobile(){
        if (mobileTextField.text?.characters.count) != 11 {
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("mobileNotCorrect", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            // disable button
            
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
            ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
            }
            //ProgressHUD.show("")
            let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
            
            //convert persian number to english number
            let NumberStr: String = mobileTextField.text!
            let Formatter: NumberFormatter = NumberFormatter()
            Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
            let final = Formatter.number(from: NumberStr)
            if final != 0 {
                print("\(final!)")
            }
            let mobileNumber = "0" + ("\(final!)")
            print (mobileNumber)
            
            if sessionID != nil {
                let params :Dictionary<String,String> = ["sessionid": sessionID! as String,
                                                         "mobile":mobileNumber as String
                ]
                print(params)
                setSubscriberMobileWithCallBack(apiName: "setsubscriberphone", params: params as NSDictionary?){ (resDic:NSDictionary?, error:NSError?) in
                    
                    ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                    })
                    
                    if let responseDic = resDic{
                        
                        print("SessionID=\(sessionID)!")
                        if (responseDic.object(forKey: "status") as! Int) == 1{
                            
                            DispatchQueue.main.async{
                                let msg:String = responseDic.object(forKey: "msg") as! String
                                let alert = UIAlertController(title: NSLocalizedString("message", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                self.showVerifyPopup()
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
    
    // Verify Subscriber Mobile Number Connection
    func verifySubscriberMobile(){
        // if ARSLineProgress.shown { return }
        if verificationCodeTextField.text?.characters.count==0{
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterVerificationCode", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
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
            
            //convert persian number to english number
            let NumberStr: String = verificationCodeTextField.text!
            let Formatter: NumberFormatter = NumberFormatter()
            Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
            let final = Formatter.number(from: NumberStr)
            if final != 0 {
                print("\(final!)")
            }
            let verifyCode:String? = String(describing: final!)
            print (verifyCode!)
            
            
            let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
            if sessionID != nil {
                
                ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
                }
                let params :Dictionary<String,String> = ["sessionid": sessionID! as String,
                                                         "verifycode":verifyCode! as String
                ]
                print(params)
                verifySubscriberMobileWithCallBack(apiName: "verifysubscriberphone", params: params as NSDictionary?){ (resDic:NSDictionary?, error:NSError?) in
                    
                    ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                    })
                    
                    if let responseDic = resDic{
                        if (responseDic.object(forKey: "status") as! Int) == 1{
                            
                            DispatchQueue.main.async {
                                let msg:String = responseDic.object(forKey: "msg") as! String
                                let alert = UIAlertController(title: NSLocalizedString("message", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                self.verificationCloseButtonAction()
                                UserDefaults.standard.set(self.mobileTextField.text,forKey:"mobileNumber")
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
    
    // Resend Verification Code Connection
    func resendVerificationCode(){
        
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
        
        
        let userNameString = UserDefaults.standard.object(forKey: "userName")
        //connect to server
        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
        let params :Dictionary<String,AnyObject> = ["username":userNameString! as AnyObject,
                                                    "mobile":mobileTextField.text! as AnyObject,
                                                    "activate_type":2 as AnyObject
        ]
        resendVerificationCodeWithCallBack(apiName: "resendactivatelink", params: params as NSDictionary?){ (resDic:NSDictionary?, error:NSError?) in
            
            ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
            
            if let responseDic = resDic{
                
                if (responseDic.object(forKey: "status") as! Int) == 1{
                    
                    DispatchQueue.main.async{
                        
                        let msg:String = responseDic.object(forKey: "msg") as! String
                        let alert = UIAlertController(title: NSLocalizedString("message", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
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
    
    // Get Last InProgress Trip Connection
    func getLastInProgressTrip(){
        
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
        /////progress 1
        //        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        //        }
        /////progress 2
        //ProgressHUD.show("")
        let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
        if sessionID != nil {
            let params :Dictionary<String,String> = ["sessionid": sessionID! as String]
            
            getLastInProgressTripWithCallBack(apiName: "trip/getlastinprogresstrip", params: params as NSDictionary?){ (resDic:NSDictionary?, error:NSError?) in
                
                //                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                //                })
                
                if let responseDic = resDic{
                    
                    print("SessionID=\(sessionID)!")
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        
                        let tripid:Int = responseDic.object(forKey: "tripid") as! Int
                        print ("TripID = \(tripid)")
                        let tripstatus:Int = responseDic.object(forKey: "tripstatus") as! Int
                        print ("TripStatus = \(tripstatus)")
                        DispatchQueue.main.async {
                            
                            if tripstatus == 4{
                                UserDefaults.standard.set(tripid, forKey: "tripID")
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RequestServiceViewController") as! RequestServiceViewController
                                nextViewController.tripID = tripid
                                
                                //self.cancelButtonAction()
                                //self.backButtonForOriginAction()
                                
                                self.navigationController?.pushViewController(nextViewController, animated: true)
                                
                            }else if tripstatus == 5{
                                
                                UserDefaults.standard.set(tripid, forKey: "tripID")
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DriverInfoViewController") as! DriverInfoViewController
                                //nextViewController.originLatitude = self.originLatitude
                                // print("originLat:\(self.originLatitude)")
                                // nextViewController.originLongitude = self.originLongitude
                                //print ("originLong:\(self.originLongitude)")
                                
                                //self.cancelButtonAction()
                                //self.backButtonForOriginAction()
                                
                                self.navigationController?.pushViewController(nextViewController, animated: true)
                                
                            }else if tripstatus == 14{
                                
                                UserDefaults.standard.set(tripid, forKey: "tripID")
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PeikArrivedAtOriginViewController") as! PeikArrivedAtOriginViewController
                                
                                //self.cancelButtonAction()
                                //self.backButtonForOriginAction()
                                
                                self.navigationController?.pushViewController(nextViewController, animated: true)
                                
                            }
                        }
                        
                        //                        DispatchQueue.main.async{
                        //                            let msg:String = responseDic.object(forKey: "msg") as! String
                        //                            let alert = UIAlertController(title: NSLocalizedString("message", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
                        //                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                        //                            self.present(alert, animated: true, completion: nil)
                        //                            self.showVerifyPopup()
                        //                        }
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
    
    func getFavoriteAddress() {
        let pageNumber = 1
        
        //Check Internet Connection
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
            
            //ProgressHUD.show("")
            
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        "page":pageNumber as AnyObject
            ]
            print("sessionID:\(sessionID)")
            print("status:\(status)")
            print("page:\(pageNumber)")
            getFavouritAddressListWithCallBack(apiName: "location/getfavoriteaddresslist", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                //                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                //                })
                
                if let responseDic = resDic{
                    print(responseDic)
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        
                        self.tableArrayFavorites = [[String:AnyObject]]()
                        if let locationArray = responseDic["data"] as? NSArray {
                            for location in locationArray {
                                self.tableArrayFavorites.append(location as! [String : AnyObject])
                            }
                            print(self.tableArrayFavorites.count)
                            DispatchQueue.main.async {
                                if self.tableArrayFavorites.count == 1{
                                    if let firstItem:String = self.tableArrayFavorites[0]["name"] as? String{
                                        if self.favButton1 != nil{
                                            self.favButton1.removeFromSuperview()
                                        }
                                        if self.favButton2 != nil{
                                            self.favButton2.removeFromSuperview()
                                        }
                                        self.favButton1 = makeButton2(frame: CGRect(x: 0, y: self.topView.frame.origin.y + self.topView.frame.size.height, width: screenWidth, height: 30), backColor: favButtonBlue, title: firstItem, titleColor: UIColor.white, isRounded: false)
                                        self.favButton1.addTarget(self, action: #selector(ViewController.favButton1Action), for: .touchUpInside)
                                        self.view.addSubview(self.favButton1)
                                        
                                        let starImageView = UIImageView(frame: CGRect(x: screenWidth-20,y: 5, width: 15, height: 15))
                                        starImageView.image = UIImage(named: "favStarImage")
                                        self.favButton1.addSubview(starImageView)
                                        
                                        let threeDotButton = makeButton(frame: CGRect(x: 0, y: 0, width: 40, height: 35), backImageName: "threeDot", backColor:nil, title: nil, titleColor: whiteColor, isRounded: false)
                                        threeDotButton.addTarget(self, action: #selector(ViewController.threeDotButtonAction), for: .touchUpInside)
                                        self.favButton1.addSubview(threeDotButton)
                                    }
                                }else if self.tableArrayFavorites.count >= 2{
                                    
                                    if let firstItem:String = self.tableArrayFavorites[0]["name"] as? String{
                                        if self.favButton1 != nil{
                                            self.favButton1.removeFromSuperview()
                                        }
                                        if self.favButton2 != nil{
                                            self.favButton2.removeFromSuperview()
                                        }
                                        self.favButton1 = makeButton2(frame: CGRect(x: 0, y: self.topView.frame.origin.y + self.topView.frame.size.height, width: screenWidth/2, height: 30), backColor: favButtonBlue, title: firstItem, titleColor: UIColor.white, isRounded: false)
                                        self.favButton1.addTarget(self, action: #selector(ViewController.favButton1Action), for: .touchUpInside)
                                        self.view.addSubview(self.favButton1)
                                        
                                        let starImageView = UIImageView(frame: CGRect(x: screenWidth/2-20,y: 5, width: 15, height: 15))
                                        starImageView.image = UIImage(named: "favStarImage")
                                        self.favButton1.addSubview(starImageView)
                                        
                                        let threeDotButton = makeButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30), backImageName: "threeDot", backColor:nil, title: nil, titleColor: whiteColor, isRounded: false)
                                        threeDotButton.addTarget(self, action: #selector(ViewController.threeDotButtonAction), for: .touchUpInside)
                                        self.favButton1.addSubview(threeDotButton)
                                    }
                                    if let secondItem:String = self.tableArrayFavorites[1]["name"] as? String{
                                        if self.favButton2 != nil{
                                            self.favButton2.removeFromSuperview()
                                        }
                                        self.favButton2 = makeButton2(frame: CGRect(x: screenWidth/2, y: self.topView.frame.origin.y + self.topView.frame.size.height, width: screenWidth/2, height: 30), backColor: favButtonBlue, title: secondItem, titleColor: UIColor.white, isRounded: false)
                                        self.favButton2.addTarget(self, action: #selector(ViewController.favButton2Action), for: .touchUpInside)
                                        self.view.addSubview(self.favButton2)
                                        
                                        let starImageView2 = UIImageView(frame: CGRect(x: self.favButton2.frame.size.width-20,y: 5, width: 15, height: 15))
                                        starImageView2.image = UIImage(named: "favStarImage")
                                        self.favButton2.addSubview(starImageView2)
                                        
                                        // let threeDotButton = makeButton(frame: CGRect(x: 10, y: 0, width: 40, height: 30), backImageName: "threeDot", backColor:nil, title: nil, titleColor: whiteColor, isRounded: false)
                                        // threeDotButton.addTarget(self, action: #selector(ViewController.threeDotButtonAction), for: .touchUpInside)
                                        //self.favButton2.addSubview(threeDotButton)
                                    }
                                }
                            }
                            
                        }else{ ////favourite address List is Empty
                            DispatchQueue.main.async {
                                if self.favButton1 != nil{
                                    self.favButton1.removeFromSuperview()
                                    if self.favButton2 != nil{
                                        self.favButton2.removeFromSuperview()
                                    }
                                }
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
    
    // Call From "getFavouriteAddressAfterSignin" observer from LoginVC to show current user fav address not last user that sign out.
    func getFavoriteAddress(notification:Notification) {
        let pageNumber = 1
        
        if favButton1 != nil{
            favButton1.removeFromSuperview()
        }
        if favButton2 != nil{
            favButton2.removeFromSuperview()
        }
        
        
        //Check Internet Connection
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
            
            //ProgressHUD.show("")
            
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        "page":pageNumber as AnyObject
            ]
            print("sessionID:\(sessionID)")
            print("status:\(status)")
            print("page:\(pageNumber)")
            getFavouritAddressListWithCallBack(apiName: "location/getfavoriteaddresslist", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                //                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                //                })
                
                if let responseDic = resDic{
                    print(responseDic)
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        
                        self.tableArrayFavorites = [[String:AnyObject]]()
                        if let locationArray = responseDic["data"] as? NSArray {
                            for location in locationArray {
                                self.tableArrayFavorites.append(location as! [String : AnyObject])
                            }
                            print(self.tableArrayFavorites.count)
                            DispatchQueue.main.async {
                                if self.tableArrayFavorites.count == 1{
                                    if let firstItem:String = self.tableArrayFavorites[0]["name"] as? String{
                                        if self.favButton1 != nil{
                                            self.favButton1.removeFromSuperview()
                                        }
                                        if self.favButton2 != nil{
                                            self.favButton2.removeFromSuperview()
                                        }
                                        self.favButton1 = makeButton2(frame: CGRect(x: 0, y: self.topView.frame.origin.y + self.topView.frame.size.height, width: screenWidth, height: 30), backColor: favButtonBlue, title: firstItem, titleColor: UIColor.white, isRounded: false)
                                        self.favButton1.addTarget(self, action: #selector(ViewController.favButton1Action), for: .touchUpInside)
                                        self.view.addSubview(self.favButton1)
                                        
                                        let starImageView = UIImageView(frame: CGRect(x: screenWidth-20,y: 5, width: 15, height: 15))
                                        starImageView.image = UIImage(named: "favStarImage")
                                        self.favButton1.addSubview(starImageView)
                                        
                                        let threeDotButton = makeButton(frame: CGRect(x: 0, y: 0, width: 40, height: 35), backImageName: "threeDot", backColor:nil, title: nil, titleColor: whiteColor, isRounded: false)
                                        threeDotButton.addTarget(self, action: #selector(ViewController.threeDotButtonAction), for: .touchUpInside)
                                        self.favButton1.addSubview(threeDotButton)
                                    }
                                }else if self.tableArrayFavorites.count >= 2{
                                    
                                    if let firstItem:String = self.tableArrayFavorites[0]["name"] as? String{
                                        if self.favButton1 != nil{
                                            self.favButton1.removeFromSuperview()
                                        }
                                        if self.favButton2 != nil{
                                            self.favButton2.removeFromSuperview()
                                        }
                                        self.favButton1 = makeButton2(frame: CGRect(x: 0, y: self.topView.frame.origin.y + self.topView.frame.size.height, width: screenWidth/2, height: 30), backColor: favButtonBlue, title: firstItem, titleColor: UIColor.white, isRounded: false)
                                        self.favButton1.addTarget(self, action: #selector(ViewController.favButton1Action), for: .touchUpInside)
                                        self.view.addSubview(self.favButton1)
                                        
                                        let starImageView = UIImageView(frame: CGRect(x: screenWidth/2-20,y: 5, width: 15, height: 15))
                                        starImageView.image = UIImage(named: "favStarImage")
                                        self.favButton1.addSubview(starImageView)
                                        
                                        let threeDotButton = makeButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30), backImageName: "threeDot", backColor:nil, title: nil, titleColor: whiteColor, isRounded: false)
                                        threeDotButton.addTarget(self, action: #selector(ViewController.threeDotButtonAction), for: .touchUpInside)
                                        self.favButton1.addSubview(threeDotButton)
                                    }
                                    if let secondItem:String = self.tableArrayFavorites[1]["name"] as? String{
                                        if self.favButton2 != nil{
                                            self.favButton2.removeFromSuperview()
                                        }
                                        self.favButton2 = makeButton2(frame: CGRect(x: screenWidth/2, y: self.topView.frame.origin.y + self.topView.frame.size.height, width: screenWidth/2, height: 30), backColor: favButtonBlue, title: secondItem, titleColor: UIColor.white, isRounded: false)
                                        self.favButton2.addTarget(self, action: #selector(ViewController.favButton2Action), for: .touchUpInside)
                                        self.view.addSubview(self.favButton2)
                                        
                                        let starImageView2 = UIImageView(frame: CGRect(x: self.favButton2.frame.size.width-20,y: 5, width: 15, height: 15))
                                        starImageView2.image = UIImage(named: "favStarImage")
                                        self.favButton2.addSubview(starImageView2)
                                        
                                        // let threeDotButton = makeButton(frame: CGRect(x: 10, y: 0, width: 40, height: 30), backImageName: "threeDot", backColor:nil, title: nil, titleColor: whiteColor, isRounded: false)
                                        // threeDotButton.addTarget(self, action: #selector(ViewController.threeDotButtonAction), for: .touchUpInside)
                                        //self.favButton2.addSubview(threeDotButton)
                                    }
                                }
                            }
                            
                        }else{ ////favourite address List is Empty
                            DispatchQueue.main.async {
                                if self.favButton1 != nil{
                                    self.favButton1.removeFromSuperview()
                                    if self.favButton2 != nil{
                                        self.favButton2.removeFromSuperview()
                                    }
                                }
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
    
    
    func registerGiftCode(){
        if (giftCodeTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterGiftCode", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        //Check Internet Connection
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
            
            ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
            }
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        "chargecardcode":giftCodeTextField.text! as AnyObject
            ]
            setChargeCardWithCallBack(apiName: "billing/setchargecard", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                })
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        
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
