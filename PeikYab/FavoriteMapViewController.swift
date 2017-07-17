//
//  FavoriteMapViewController.swift
//  PeikYab
//
//  Created by Yarima on 8/30/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import UIKit
import GoogleMaps

class FavoriteMapViewController: BaseViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate{
    
    //MARK: - Variables
    let tehranCenterLat = 35.707885
    let tehranCenterLong = 51.396502
    
    var markerOrigin : GMSMarker!
    var mapView : GMSMapView!
    var locationManager = CLLocationManager()
    var markerButton:UIButton!
    var firstPosition : GMSCameraPosition!
    var lastPosition : GMSCameraPosition!
    var numbeOfTappedOnMarker :Int = 0
    var originLabel : UILabel!
    var numberOfPeykLabel : UILabel!
    
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
    
    var popupView : UIView!
    var favouritAddressLabel:UILabel!
    var favouritAddressTextField : UITextField!
    //    var addressForDriverLabel:UILabel!
    var addressForDriverTextField : UITextField!
    //    var saveButton :UIButton!
    //    var deleteButton:UIButton!
    var transparentView:UIView!
    
    //Address Parts
    var locality:String! //CityName
    var subLocality:String!//Region
    var thoroughfare:String!//Street
    
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        
        makeTopbar(NSLocalizedString("selectedAddress", comment: ""))
        backButton.isHidden = false
        backButton.addTarget(self, action: #selector(FavoriteMapViewController.backButtonAction), for: .touchUpInside)
        //button like Marker to select whether origin or destination
        
        let markerImage = UIImage(named: "marker")
        markerButton = UIButton(frame: CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 22, width: 100 * 0.5, height: 88 * 0.5))
        markerButton.setBackgroundImage(markerImage, for: UIControlState())
        markerButton.addTarget(self, action: #selector(ViewController.markerButtonAction), for: .touchUpInside)
        mapView.addSubview(markerButton)
        
        //let searchButton = makeButton(frame: CGRect(x: 20, y: 25, width: 54 * 0.4, height: 69 * 0.4), backImageName: "search", backColor: nil, title: nil, titleColor: nil, isRounded: false)
        //self.view.addSubview(searchButton)
        
        //        let menuButton = makeButton(frame: CGRect(x: screenWidth - 50, y: 30, width: 54/2,height: 39/2), backImageName: "menu", backColor: nil, title: nil, titleColor: nil, isRounded: false)
        //        menuButton.addTarget(self, action: #selector(ViewController.menuAction), for: .touchUpInside)
        //        self.view.addSubview(menuButton)
    }
    
    //MARK: -  TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if DeviceType.IS_IPHONE_4_OR_LESS {
            if textField.tag == 13 {
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.view.frame
                    rect.origin.y -= 95
                    self.view.frame = rect
                })
                
            }
        }else if DeviceType.IS_IPHONE_5{
            if textField.tag == 13 || textField.tag == 14{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.view.frame
                    rect.origin.y -= 110
                    self.view.frame = rect
                })
            }
        }else if DeviceType.IS_IPHONE_6{
            if textField.tag == 13 || textField.tag == 14{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.view.frame
                    rect.origin.y -= 100
                    self.view.frame = rect
                })
            }
        }else if DeviceType.IS_IPHONE_6P{
            if textField.tag == 13 || textField.tag == 14{
                UIView.animate(withDuration: 0.3, animations: {
                    var rect = self.view.frame
                    rect.origin.y -= 100
                    self.view.frame = rect
                })
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            var rect = self.view.frame
            rect.origin.y = 0
            self.view.frame = rect
        })
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    //MARK: - google map delegate
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if numbeOfTappedOnMarker == 0 {
            //show spinner on Price button
            indicatorForOriginLabel.startAnimating()
            self.originLabel.addSubview(indicatorForOriginLabel)
            self.originLabel.text = ""
            self.markerButton.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.3, animations: {
                self.markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 13, y: mapView.frame.size.height/2 - 11, width: 50 * 0.5, height: 44 * 0.5)
            })
            firstPosition = position
        }else if numbeOfTappedOnMarker == 1{
            //show spinner on Price button
            UIView.animate(withDuration: 0.3, animations: {
                self.markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 22, width: 50 * 0.5, height: 44 * 0.5)
            })
        }
    }
    
    func getAddressForLatLng(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let aGMSGeocoder: GMSGeocoder = GMSGeocoder()
        
        let twoDLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        aGMSGeocoder.reverseGeocodeCoordinate(twoDLocation) { gms , error in
            
            if gms != nil{
                if gms?.results()?.count != 0{
                    
                    for address in (gms?.results())!{
                        let gmsAddress: GMSAddress = address
                        if address.locality != nil{
                            self.locality = gmsAddress.locality!
                            break
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
                                print("Language:=\(address.thoroughfare!.language())")
                                self.thoroughfare = gmsAddress.thoroughfare!
                            }
                        }
                    }
                    if self.lastPosition.target.latitude != 0 && self.lastPosition.target.longitude != 0{
                    self.markerButton.isUserInteractionEnabled = true
                    }
                    
                    var originStr = ""
                    
                    if self.locality != nil{
                        originStr = self.locality
                    }
                    if self.subLocality != nil{
                        originStr = self.locality+"،"+self.subLocality
                    }
                    if self.thoroughfare != nil{
                        originStr = self.locality+"،"+self.subLocality+"،"+self.thoroughfare
                    }
                    self.indicatorForOriginLabel.stopAnimating()
                    self.indicatorForOriginLabel.removeFromSuperview()
                    self.originLabel.text = originStr
                    self.markerButton.isUserInteractionEnabled = true
                    
                }
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if numbeOfTappedOnMarker == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 22, width: 50, height: 44)
            })
            
        }else if numbeOfTappedOnMarker == 1{
            UIView.animate(withDuration: 0.3, animations: {
                self.markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 39, width: 49, height: 78)
            })
        }
        
        //update last position
        lastPosition = position
        getAddressForLatLng(latitude: lastPosition.target.latitude, longitude: lastPosition.target.longitude)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.animate(toLocation: marker.position)
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 15)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: -  Custom methods
    func setupMap() -> Void {
        let camera = GMSCameraPosition.camera(withLatitude: tehranCenterLat,
                                              longitude: tehranCenterLong,
                                              zoom: 11.0)
        
        mapView = GMSMapView.map(withFrame:self.view.bounds,camera:camera)
        //  mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 64), camera:camera)
        mapView.delegate = self
        self.view.addSubview(mapView)
        if CLLocationManager.locationServicesEnabled()
            && CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.isMyLocationEnabled = true
        }
        //self.view = mapView
        
        setCurrentUserLocation()
        
        makeBottomView()
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
        if bottomView != nil{
            bottomView.removeFromSuperview()
        }
        bottomView = UIView(frame:CGRect(x: 0, y: 5 * screenHeight / 6, width: screenWidth, height: 1 * screenHeight / 6))
        bottomView.backgroundColor = bottomColor
        mapView.addSubview(bottomView)
        
        numberOfPeykLabel = UILabel(frame: CGRect(x: 0, y: 10, width: screenWidth, height: 25))
        numberOfPeykLabel.textColor = UIColor.black
        numberOfPeykLabel.font = FONT_NORMAL(13)
        numberOfPeykLabel.textAlignment = .center
        numberOfPeykLabel.backgroundColor = UIColor.clear
        bottomView.addSubview(numberOfPeykLabel)
        
        
        bgViewforOrigin = UIView(frame:CGRect(x: 0, y: 30, width: screenWidth, height: bottomView.frame.size.height))
        bgViewforOrigin.backgroundColor = UIColor.clear
        bottomView.addSubview(bgViewforOrigin)
        
        let originImageView = UIImageView(frame: CGRect(x: screenWidth/2 - 15, y: 5, width: 30, height: 30))
        originImageView.image = UIImage(named: "mabda")
        originImageView.contentMode = .scaleAspectFit
        bgViewforOrigin.addSubview(originImageView)
        
        originLabel = UILabel(frame: CGRect(x: 0, y: originImageView.frame.origin.y + originImageView.frame.size.height, width: screenWidth, height: 25))
        originLabel.textColor = UIColor.black
        originLabel.font = FONT_NORMAL(13)
        originLabel.minimumScaleFactor = 0.5
        originLabel.adjustsFontSizeToFitWidth = true
        originLabel.textAlignment = .center
        originLabel.backgroundColor = UIColor.clear
        bgViewforOrigin.addSubview( originLabel)
        
        indicatorForOriginLabel = UIActivityIndicatorView(frame: CGRect(x:self.originLabel.frame.size.width/2 - 20.0, y:0.0, width:40.0, height:40.0))
        indicatorForOriginLabel.activityIndicatorViewStyle = .gray
    }
    
    func markerButtonAction(){
        numbeOfTappedOnMarker = numbeOfTappedOnMarker + 1
        
        if numbeOfTappedOnMarker == 1 {
            //increase height of bottom view
            
            markerOrigin = GMSMarker()
            markerOrigin.position = firstPosition.target
            let markerImage = UIImage(named: "marker")
            markerOrigin.icon = markerImage
            markerOrigin.snippet = NSLocalizedString("origin", comment: "")
            markerOrigin.appearAnimation = kGMSMarkerAnimationPop
            markerOrigin.map = mapView
            
            markerButton.isHidden = true
            
            //show pop up dialog
            popupButtonAction()
        }
    }
    
    func cancelButtonAction() {
        
        //reset markers
        mapView.isUserInteractionEnabled = true
        numbeOfTappedOnMarker = 0
        self.markerOrigin.map = nil
        self.markerButton.isHidden = false
        let markerImage3 = UIImage(named: "marker")
        markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 22, width: 49, height: 43)
        markerButton.setBackgroundImage(markerImage3, for: UIControlState())
    }
    
    //Hide Popup
    func closeButtonAction(){
        popupView.removeFromSuperview()
        transparentView.removeFromSuperview()
        cancelButtonAction()
    }
    //Back To Selected Address VC
    func backButtonAction() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    //Show Popup
    func popupButtonAction(){
        
        transparentView = UIView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight - 64))
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        transparentView.isUserInteractionEnabled = true
        self.view.addSubview(transparentView)
        
        popupView = UIView(frame: CGRect(x: 20,y: screenHeight/2-172,width: screenWidth-40,height: 280))
        popupView.backgroundColor = whiteColor
        popupView.layer.cornerRadius = 20
        popupView.layer.shadowColor = UIColor.gray.cgColor
        popupView.layer.shadowOpacity = 0.5
        popupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        popupView.layer.shadowRadius = 20
        popupView.isUserInteractionEnabled = true
        transparentView.addSubview(popupView)
        
        let favouritAddressLabel = UILabel(frame: CGRect(x: 10, y: 10, width: popupView.frame.size.width - 20, height: 50))
        favouritAddressLabel.backgroundColor = whiteColor
        favouritAddressLabel.textColor = UIColor.black
        favouritAddressLabel.font = FONT_NORMAL(13)
        favouritAddressLabel.text = NSLocalizedString("favouritAddress", comment: "")
        favouritAddressLabel.textAlignment = .right
        favouritAddressLabel.adjustsFontSizeToFitWidth = true
        popupView.addSubview(favouritAddressLabel)
        
        favouritAddressTextField = UITextField(frame: CGRect(x: favouritAddressLabel.frame.origin.x,y: favouritAddressLabel.frame.origin.y+favouritAddressLabel.frame.size.height, width: favouritAddressLabel.frame.size.width, height: 40))
        //favouritAddressTextField.font = FONT_NORMAL(13)
        favouritAddressTextField.textColor = UIColor.black
        favouritAddressTextField.borderStyle = .roundedRect
        favouritAddressTextField.autocorrectionType = UITextAutocorrectionType.no
        favouritAddressTextField.keyboardType = UIKeyboardType.default
        favouritAddressTextField.returnKeyType = UIReturnKeyType.done
        favouritAddressTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        favouritAddressTextField.contentVerticalAlignment = .center
        favouritAddressTextField.contentHorizontalAlignment = .center
        favouritAddressTextField.textAlignment = .right
        favouritAddressTextField.delegate = self
        favouritAddressTextField.adjustsFontSizeToFitWidth = true
        favouritAddressTextField.autocapitalizationType = .none
        favouritAddressTextField.backgroundColor = lightBlue
        favouritAddressTextField.clipsToBounds = true
        favouritAddressTextField.layer.borderWidth = 0.8
        favouritAddressTextField.layer.borderColor = textFieldBorderBlue.cgColor
        favouritAddressTextField.tag = 13
        popupView.addSubview(favouritAddressTextField)
        
        let addressForDriverLabel = UILabel(frame: CGRect(x: 10, y: favouritAddressTextField.frame.origin.y+favouritAddressTextField.frame.size.height, width: popupView.frame.size.width - 20, height: 50))
        addressForDriverLabel.backgroundColor = whiteColor
        addressForDriverLabel.textColor = UIColor.black
        addressForDriverLabel.font = FONT_NORMAL(13)
        addressForDriverLabel.text = NSLocalizedString("addressForDriver", comment: "")
        addressForDriverLabel.textAlignment = .right
        addressForDriverLabel.adjustsFontSizeToFitWidth = true
        popupView.addSubview(addressForDriverLabel)
        
        addressForDriverTextField = UITextField(frame: CGRect(x: addressForDriverLabel.frame.origin.x,y: addressForDriverLabel.frame.origin.y+addressForDriverLabel.frame.size.height, width: addressForDriverLabel.frame.size.width, height: 40))
        //addressForDriverTextField.font = FONT_NORMAL(13)
        addressForDriverTextField.textColor = UIColor.black
        addressForDriverTextField.borderStyle = .roundedRect
        addressForDriverTextField.autocorrectionType = UITextAutocorrectionType.no
        addressForDriverTextField.keyboardType = UIKeyboardType.default
        addressForDriverTextField.returnKeyType = UIReturnKeyType.done
        addressForDriverTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        addressForDriverTextField.contentVerticalAlignment = .center
        addressForDriverTextField.contentHorizontalAlignment = .center
        addressForDriverTextField.textAlignment = .right
        addressForDriverTextField.delegate = self
        addressForDriverTextField.adjustsFontSizeToFitWidth = true
        addressForDriverTextField.autocapitalizationType = .none
        addressForDriverTextField.backgroundColor = lightBlue
        addressForDriverTextField.clipsToBounds = true
        addressForDriverTextField.layer.borderWidth = 0.8
        addressForDriverTextField.layer.borderColor = textFieldBorderBlue.cgColor
        addressForDriverTextField.tag = 14
        addressForDriverTextField.isUserInteractionEnabled = true
        popupView.addSubview(addressForDriverTextField)
        
        let saveButton = makeButton(frame: CGRect(x: addressForDriverTextField.frame.origin.x+addressForDriverTextField.frame.size.width-50,y: addressForDriverTextField.frame.origin.y+addressForDriverTextField.frame.size.height+20,width: 50,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("save", comment: ""), titleColor: topViewBlue, isRounded: false)
        saveButton.addTarget(self, action: #selector(SelectedAddressViewController.saveButtonAction), for: .touchUpInside)
        popupView.addSubview(saveButton)
        
        let closeButton = makeButton(frame: CGRect(x: 10,y: addressForDriverTextField.frame.origin.y+addressForDriverTextField.frame.size.height+20,width: 50,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("close", comment: ""), titleColor: UIColor.red, isRounded: false)
        closeButton.addTarget(self, action: #selector(SelectedAddressViewController.closeButtonAction), for: .touchUpInside)
        popupView.addSubview(closeButton)
    }
    
    //Save Favourite Address
    func saveButtonAction(){
        setFavourite()
        //closeButtonAction()
    }
    
    //MARK: -  Connections
    
    //Set Favourite Address Connection
    func setFavourite(){
        // if ARSLineProgress.shown { return }
        if (favouritAddressTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterFavouriteAddress", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (addressForDriverTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterAddressForDriver", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
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
    
        let latitude:Double = lastPosition.target.latitude
        let longitude:Double = lastPosition.target.longitude

        if sessionID != nil {
            
            // let data = favouritAddressTextField.text?.data(using: String.Encoding.utf8)
            ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
            }
            let params :Dictionary<String,AnyObject> =
                ["sessionid": sessionID! as AnyObject,
                 "latitude": latitude as AnyObject,
                 "longitude": longitude as AnyObject,
                 "name": favouritAddressTextField.text! as AnyObject,       //nameNSString as AnyObject,
                    "address": addressForDriverTextField.text! as AnyObject,   //addressNSString as AnyObject,
                    "neighbor": originLabel.text! as AnyObject
            ]
            print("setFavourite Params=\(params)")
            
            setFavouriteAddressWithCallBack(apiName: "location/setfavoriteaddress", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                })
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        DispatchQueue.main.async {
                            let msg:String = responseDic.object(forKey: "msg") as! String
                            let alert = UIAlertController(title: NSLocalizedString("saveLocation", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                            self.backButtonAction()
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
