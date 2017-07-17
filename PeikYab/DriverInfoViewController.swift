//
//  DriverInfoViewController.swift
//  PeikYab
//
//  Created by Developer on 10/22/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class DriverInfoViewController:BaseViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate, UITextFieldDelegate,UIGestureRecognizerDelegate{
    
    //MARK: - Variables
    let tehranCenterLat = 35.707885
    let tehranCenterLong = 51.396502
    
    let longitude:Double = UserDefaults.standard.object(forKey: "originLongitude") as! Double
    let latitude:Double = UserDefaults.standard.object(forKey: "originLatitude") as! Double
    
    var markerOrigin : GMSMarker!
    var driverLocationMarker : GMSMarker!
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
    
    var estimateTimeLabel:UILabel!
    var scrollView:UIScrollView!
    var driverProfileImageView:UIImageView!
    var driverImageURL:String!
    var driverNameLabel:UILabel!
    var pelakNumberLabel:UILabel!
    var callPhoneImageView:UIImageView!
    var driverName:String?
    var pelak:String?
    var driverMobileNumber:String?
    
    var transparentView:UIView!
    var cashPopupView : UIView!
    var amountToPayLabel:UILabel!
    var priceLabel:UILabel!
    var currentCreditLabel:UILabel!
    var currentCredit:Int = 0
    
    var addCreditTransparentView:UIView!
    var addCreditPopupView:UIView!
    var addCreditCurrentCreditLabel:UILabel!
    var amountTextField:UITextField!
    var tapGesture:UIGestureRecognizer!
    var paymentNumber : Int = 0
    var onlinePaymentButton:UIButton!
    //var USSDPaymentButton:UIButton!
    var peykyabButton:UIButton!
    var payButton:UIButton!
    var webViewURL:String!
    var addCreditCloseButton:UIButton!
    var estimateTimeToOriginText:String!
    var driverLocationLongitude:CLLocationDegrees!
    var driverLocationLatitude:CLLocationDegrees!
    var twoDPos:CLLocationCoordinate2D!
    
    //MARK: -  view WillAppear
    override func viewWillAppear(_ animated: Bool) {
        paymentNumber = 0
        getTripDriverInfo()
        //getCredit()
    }
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DriverInfoViewController.NavigateToPeikArrivedAtOriginVC(notification:)), name: NSNotification.Name(rawValue: "event104"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DriverInfoViewController.NavigateToMapVC(notification:)), name: NSNotification.Name(rawValue: "event111"), object: nil)
        
        setupMap()
        makeTopbar(NSLocalizedString("", comment: ""))
        mapView.isUserInteractionEnabled = false
        
        backButton.isHidden = true
        //backButton.addTarget(self, action: #selector(DriverInfoViewController.backAction), for: .touchUpInside)
        
        //        let markerImage = UIImage(named: "marker")
        //        markerButton = UIButton(frame: CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 22, width: 49, height: 43))
        //        markerButton.setBackgroundImage(markerImage, for: UIControlState())
        //        markerButton.addTarget(self, action: #selector(ViewController.markerButtonAction), for: .touchUpInside)
        //        mapView.addSubview(markerButton)
        
        //        scrollView = UIScrollView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight))
        //        scrollView.delegate = self
        //        if DeviceType.IS_IPHONE_4_OR_LESS {
        //            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+200)
        //        }else if DeviceType.IS_IPHONE_5{
        //            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight-60)
        //        }else if DeviceType.IS_IPHONE_6{
        //            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight-60)
        //        }else if DeviceType.IS_IPHONE_6P{
        //            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight-60)
        //        }
        //        self.view.addSubview(scrollView)
        self.view.isUserInteractionEnabled = true
        //scrollView.showsVerticalScrollIndicator = false
        self.hideKeyboardWhenTappedAround()
        
        //estimated Time to arrive Peyk Label
        estimateTimeLabel = UILabel(frame: CGRect(x: 0,y: 64,width: screenWidth,height: 40))
        estimateTimeLabel.backgroundColor = tripIDLabelColor
        estimateTimeLabel.textColor = UIColor.white
        estimateTimeLabel.textAlignment = .center
        // estimateTimeLabel.text = "پیک موتوری شما تا"+self.estimateTimeToOriginText+" دیگر می رسد"
        estimateTimeLabel.font = FONT_NORMAL(17)
        estimateTimeLabel.adjustsFontSizeToFitWidth = true
        estimateTimeLabel.isUserInteractionEnabled = true
        self.view.addSubview(estimateTimeLabel)
        
        //tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGesture))
        // tapGesture.delegate = self
        //estimateTimeLabel.addGestureRecognizer(tapGesture)
    }

    //MARK: -  google map delegate
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        /*
         if numbeOfTappedOnMarker == 0 {
         //show spinner on Price button
         indicatorForOriginLabel.startAnimating()
         self.originLabel.addSubview(indicatorForOriginLabel)
         self.originLabel.text = ""
         
         UIView.animate(withDuration: 0.3, animations: {
         self.markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 13, y: mapView.frame.size.height/2 - 16, width: 27, height: 33)
         })
         firstPosition = position
         }else if numbeOfTappedOnMarker == 1{
         //show spinner on Price button
         UIView.animate(withDuration: 0.3, animations: {
         self.markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 13, y: mapView.frame.size.height/2 - 16, width: 25, height: 40)
         })
         }
 */
    }
    
    /*
    func getAddressForLatLng(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let aGMSGeocoder: GMSGeocoder = GMSGeocoder()
        
        let twoDLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        aGMSGeocoder.reverseGeocodeCoordinate(twoDLocation) { gms , error in
            if gms != nil{
                if gms?.firstResult() != nil{
                    let gmsAddress: GMSAddress = (gms?.firstResult())!
                    
                    if self.numbeOfTappedOnMarker == 0 {
                        var originStr = ""
                        if gmsAddress.locality != nil{
                            originStr = gmsAddress.locality!
                        }
                        if gmsAddress.subLocality != nil{
                            originStr = originStr + " " + gmsAddress.subLocality!
                        }
                        if gmsAddress.thoroughfare != nil{
                            originStr = originStr + " " + gmsAddress.thoroughfare!
                        }
                        self.indicatorForOriginLabel.stopAnimating()
                        self.indicatorForOriginLabel.removeFromSuperview()
                        self.originLabel.text = originStr
                        
                    }
                }
            }
        }
    }
 */
    
    /*
     func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
     if numbeOfTappedOnMarker == 0 {
     UIView.animate(withDuration: 0.3, animations: {
     self.markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 22, width: 49, height: 43)
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
     */
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.animate(toLocation: marker.position)
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       // let userLocation = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude,
                                              longitude: longitude, zoom: 10.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: -  TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //USSDPaymentButton.setTitleColor(grayColor,for: UIControlState())
        onlinePaymentButton.setTitleColor(grayColor,for: UIControlState())
        peykyabButton.setTitleColor(grayColor,for: UIControlState())
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            UIView.animate(withDuration: 0.3, animations: {
                var rect = self.view.frame
                rect.origin.y -= 180
                self.view.frame = rect
            })
        }else if DeviceType.IS_IPHONE_5{
            UIView.animate(withDuration: 0.3, animations: {
                var rect = self.view.frame
                rect.origin.y -= 130
                self.view.frame = rect
            })
        }else if DeviceType.IS_IPHONE_6{
            UIView.animate(withDuration: 0.3, animations: {
                var rect = self.view.frame
                rect.origin.y -= 100
                self.view.frame = rect
            })
        }else if DeviceType.IS_IPHONE_6P{
            UIView.animate(withDuration: 0.3, animations: {
                var rect = self.view.frame
                rect.origin.y -= 100
                self.view.frame = rect
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.3, animations: {
            var rect = self.view.frame
            rect.origin.y = 0
            self.view.frame = rect
        })
    }
    
    //MARK: -  Custom methods
    
    //func backAction(){
    //  _ = self.navigationController?.popViewController(animated: true)
    //}
    
    func handleGesture(_ sender: UITapGestureRecognizer){
        // let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PeikArrivedAtOriginViewController") as! PeikArrivedAtOriginViewController
        //self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    //MARK: Push Notification Selector
    func NavigateToPeikArrivedAtOriginVC(notification: Notification) {
        //let tempDic:[String:AnyObject] = notification.object! as! Dictionary<String, AnyObject>
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PeikArrivedAtOriginViewController") as! PeikArrivedAtOriginViewController
        //nextViewController.driverImageURL = self.driverImageURL
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func NavigateToMapVC(notification: Notification) {
        let tempDic:[String:AnyObject] = notification.object! as! Dictionary<String, AnyObject>
        //let data:[String:AnyObject] = tempDic["data"] as! [String : AnyObject]
        //let message:String = data["details"]!["msg"] as! String
        let notificationName = Notification.Name("showAlert")
        NotificationCenter.default.post(name: notificationName, object: tempDic)
        //let alertController = UIAlertController(title: NSLocalizedString("cancelService", comment: ""), message:String(describing: data), preferredStyle: .alert)
        //let OKAction = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: .default) {
        //   (action:UIAlertAction!) in
        self.perform(#selector(DriverInfoViewController.showMapVC), with: nil, afterDelay: 0.7)
        //}
        
        //alertController.addAction(OKAction)
        //present(alertController, animated: true, completion:nil)
        
    }
    
    func showMapVC(){
        
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    func setupMap() -> Void {
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude,
                                              longitude: longitude,
                                              zoom: 10.0)
        mapView = GMSMapView.map(withFrame:self.view.bounds,camera:camera)
        //  mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 64), camera:camera)
        mapView.delegate = self
        self.view.addSubview(mapView)
        if CLLocationManager.locationServicesEnabled()
            && CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.isMyLocationEnabled = true
        }
        markerOrigin = GMSMarker()
        twoDPos = CLLocationCoordinate2D(latitude: latitude,longitude: longitude)
        
        print ("Latitude:\(latitude)","longitude:\(longitude)")
        
        markerOrigin.position = twoDPos
        let markerImage = UIImage(named: "marker")
        markerOrigin.icon = markerImage
        markerOrigin.snippet = NSLocalizedString("origin", comment: "")
        markerOrigin.appearAnimation = kGMSMarkerAnimationPop
        markerOrigin.map = mapView
        //self.view = mapView
        
        //setCurrentUserLocation()
        
        makeBottomView()
    }
    
//    func setCurrentUserLocation(){
//        //user location stuff
//        locationManager.delegate = self
//        locationManager.distanceFilter = kCLDistanceFilterNone
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
//    }
    
    func makeBottomView(){
        if bottomView != nil{
            bottomView.removeFromSuperview()
        }
        bottomView = UIView(frame:CGRect(x: 0, y: screenHeight-150, width: screenWidth, height:150))
        bottomView.backgroundColor = bottomColor
        self.view.addSubview(bottomView)
        
        //Driver Image
        driverProfileImageView = UIImageView(frame: CGRect(x: screenWidth-70,y: 20, width: 50, height: 50))
        driverProfileImageView.image = UIImage(named: "driverProfileImage")
        driverProfileImageView.contentMode = .scaleAspectFit
        bottomView.addSubview(driverProfileImageView)
        
        //Name Label
        let  nameLabel = UILabel(frame: CGRect(x: driverProfileImageView.frame.origin.x-60,y: 20,width: 50,height: 25))
        nameLabel.backgroundColor = UIColor.white
        nameLabel.textColor = topViewBlue
        nameLabel.font = FONT_NORMAL(13)
        nameLabel.text = NSLocalizedString("driverName", comment: "")
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .right
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        bottomView.addSubview(nameLabel)
        
        //DriverName Label
        driverNameLabel = UILabel(frame: CGRect(x: 50,y: 20,width: 100,height: 25))
        driverNameLabel.backgroundColor = UIColor.white
        driverNameLabel.textColor = UIColor.darkGray
        driverNameLabel.font = FONT_NORMAL(17)
        driverNameLabel.text = driverName //NSLocalizedString("Nima", comment: "")
        driverNameLabel.numberOfLines = 1
        driverNameLabel.textAlignment = .right
        driverNameLabel.adjustsFontSizeToFitWidth = true
        driverNameLabel.minimumScaleFactor = 0.5
        bottomView.addSubview(driverNameLabel)
        
        //Pelak Label
        let pelakLabel = UILabel(frame: CGRect(x: driverProfileImageView.frame.origin.x-60,y:50,width: 50,height: 25))
        pelakLabel.backgroundColor = UIColor.white
        pelakLabel.textColor = topViewBlue
        pelakLabel.font = FONT_NORMAL(13)
        pelakLabel.text = NSLocalizedString("pelak", comment: "")
        pelakLabel.numberOfLines = 1
        pelakLabel.textAlignment = .right
        pelakLabel.adjustsFontSizeToFitWidth = true
        pelakLabel.minimumScaleFactor = 0.5
        bottomView.addSubview(pelakLabel)
        
        //Pelak Number Label
        pelakNumberLabel = UILabel(frame: CGRect(x: 50,y: 45,width: 100,height: 25))
        pelakNumberLabel.backgroundColor = UIColor.white
        pelakNumberLabel.textColor = topViewBlue
        pelakNumberLabel.font = FONT_NORMAL(17)
        pelakNumberLabel.text = pelak  //"۵۴۸ خ ۱۲۷"
        pelakNumberLabel.numberOfLines = 1
        pelakNumberLabel.textAlignment = .right
        pelakNumberLabel.adjustsFontSizeToFitWidth = true
        pelakNumberLabel.minimumScaleFactor = 0.5
        bottomView.addSubview(pelakNumberLabel)
        
        //Cash Button
        let cashButton = UIButton(frame: CGRect(x: 0,y: pelakNumberLabel.frame.origin.y+pelakNumberLabel.frame.size.height+20,width: screenWidth/2,height: 60))
        cashButton.backgroundColor = greenColor
        cashButton.titleLabel!.font = FONT_MEDIUM(15)
        cashButton.tintColor = whiteColor
        cashButton.setTitle(NSLocalizedString("cash", comment: ""), for:UIControlState())
        cashButton.addTarget(self, action: #selector(cashButtonAction), for: .touchUpInside)
        bottomView.addSubview(cashButton)
        
        //Call Driver Button
        let callDriverButton = UIButton(frame: CGRect(x: cashButton.frame.origin.x+cashButton.frame.size.width,y: cashButton.frame.origin.y,width: screenWidth/2,height: 60))
        callDriverButton.backgroundColor = tripIDLabelColor
        callDriverButton.titleLabel?.font = FONT_MEDIUM(15)
        callDriverButton.setTitle(NSLocalizedString("callDriver", comment: ""), for:.normal)
        callDriverButton.addTarget(self, action: #selector(callDriverButtonAction), for: .touchUpInside)
        //callDriverButton.setBackgroundImage(UIImage(named: "enterMobileImage"), for: UIControlState())
        bottomView.addSubview(callDriverButton)
        
        // Call Driver Image
        callPhoneImageView = UIImageView(frame: CGRect(x: screenWidth-30,y: screenHeight-60, width: 30, height: 30))
        callPhoneImageView.image = UIImage(named: "enterMobileImage")
        callPhoneImageView.contentMode = .scaleAspectFit
        callDriverButton.addSubview(callPhoneImageView)
    }
    
    func markerButtonAction(){
        //        numbeOfTappedOnMarker = numbeOfTappedOnMarker + 1
        //
        //        if numbeOfTappedOnMarker == 1 {
        //            //increase height of bottom view
        //
        //            markerOrigin = GMSMarker()
        //            markerOrigin.position = firstPosition.target
        //            let markerImage = UIImage(named: "marker")
        //            markerOrigin.icon = markerImage
        //            markerOrigin.snippet = NSLocalizedString("origin", comment: "")
        //            markerOrigin.appearAnimation = kGMSMarkerAnimationPop
        //            markerOrigin.map = mapView
        //
        //            markerButton.isHidden = true
        //
        //            //show pop up dialog
        //            popupButtonAction()
        //        }
    }
    
    func cancelButtonAction() {
        
        //        //reset markers
        //        mapView.isUserInteractionEnabled = true
        //        numbeOfTappedOnMarker = 0
        //        self.markerOrigin.map = nil
        //        self.markerButton.isHidden = false
        //        let markerImage3 = UIImage(named: "marker")
        //        markerButton.frame = CGRect(x: mapView.frame.size.width/2 - 25, y: mapView.frame.size.height/2 - 22, width: 49, height: 43)
        //        markerButton.setBackgroundImage(markerImage3, for: UIControlState())
    }
    
    //Show Popup
    func popupButtonAction(){
        
        transparentView = UIView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight - 64))
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        transparentView.isUserInteractionEnabled = true
        self.view.addSubview(transparentView)
        
        cashPopupView = UIView(frame: CGRect(x: 20,y: screenHeight/2-200,width: screenWidth-40,height: 280))
        cashPopupView.backgroundColor = whiteColor
        cashPopupView.layer.shadowColor = UIColor.gray.cgColor
        cashPopupView.layer.shadowOpacity = 0.5
        cashPopupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cashPopupView.layer.shadowRadius = 20
        cashPopupView.isUserInteractionEnabled = true
        transparentView.addSubview(cashPopupView)
        
        let  cashLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cashPopupView.frame.size.width , height: 50))
        cashLabel.backgroundColor = DriverInfoOrange
        cashLabel.textColor = whiteColor
        cashLabel.font = FONT_NORMAL(13)
        cashLabel.text = NSLocalizedString("cash", comment: "")
        cashLabel.textAlignment = .center
        cashLabel.adjustsFontSizeToFitWidth = true
        cashPopupView.addSubview(cashLabel)
        
        let amountToPayLabel = UILabel(frame: CGRect(x: 0, y: cashLabel.frame.origin.x+cashLabel.frame.size.height, width: cashPopupView.frame.size.width, height: 30))
        amountToPayLabel.backgroundColor = whiteColor
        amountToPayLabel.textColor = tripIDLabelColor
        amountToPayLabel.font = FONT_NORMAL(13)
        amountToPayLabel.text = NSLocalizedString("amountToPay", comment: "")
        amountToPayLabel.textAlignment = .center
        amountToPayLabel.adjustsFontSizeToFitWidth = true
        cashPopupView.addSubview(amountToPayLabel)
        
        priceLabel = UILabel(frame: CGRect(x: 0, y: amountToPayLabel.frame.origin.y+amountToPayLabel.frame.size.height, width: cashPopupView.frame.size.width , height: 30))
        priceLabel.backgroundColor = whiteColor
        priceLabel.textColor = topViewBlue
        priceLabel.font = FONT_NORMAL(13)
        let price = UserDefaults.standard.object(forKey: "tripPrice")
        priceLabel.text = (price as! String?)! + NSLocalizedString("rial", comment: "")
        priceLabel.textAlignment = .center
        priceLabel.adjustsFontSizeToFitWidth = true
        cashPopupView.addSubview(priceLabel)
        
        //popup Current Label
        let currentLabel = UILabel(frame: CGRect(x: 0,y: priceLabel.frame.origin.y+priceLabel.frame.size.height, width: cashPopupView.frame.size.width, height: 30))
        currentLabel.backgroundColor = whiteColor
        currentLabel.textColor = grayColor
        currentLabel.font = FONT_NORMAL(13)
        currentLabel.text = NSLocalizedString("currentCredit", comment: "")
        currentLabel.textAlignment = .center
        cashPopupView.addSubview(currentLabel)
        
        //popup Current Credit Label
        currentCreditLabel = UILabel(frame: CGRect(x:0,y: currentLabel.frame.origin.y+currentLabel.frame.size.height, width: cashPopupView.frame.size.width, height: 30))
        currentCreditLabel.backgroundColor = whiteColor
        currentCreditLabel.textColor = grayColor
        currentCreditLabel.font = FONT_NORMAL(13)
        //currentCreditLabel.text = "\(currentCredit)" + NSLocalizedString("rial", comment: "")
        currentCreditLabel.textAlignment = .center
        cashPopupView.addSubview(currentCreditLabel)
        getCredit()
        
        //popup Trip Price Will pay from your credit Label
        let tripPriceWillPayLabel = UILabel(frame: CGRect(x:30,y: currentCreditLabel.frame.origin.y+currentCreditLabel.frame.size.height, width: cashPopupView.frame.size.width-60, height: 60))
        tripPriceWillPayLabel.backgroundColor = UIColor.white
        tripPriceWillPayLabel.textColor = topViewBlue
        tripPriceWillPayLabel.font = FONT_NORMAL(13)
        tripPriceWillPayLabel.text = NSLocalizedString("tripPriceWillPayFromYourCredit", comment: "")
        tripPriceWillPayLabel.numberOfLines = 2
        tripPriceWillPayLabel.textAlignment = .center
        tripPriceWillPayLabel.adjustsFontSizeToFitWidth = true
        cashPopupView.addSubview(tripPriceWillPayLabel)
        
        let addCreditButton = makeButton(frame: CGRect(x: 10,y: tripPriceWillPayLabel.frame.origin.y+tripPriceWillPayLabel.frame.size.height,width: 80,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("addCredit", comment: ""), titleColor: topViewBlue, isRounded: false)
        addCreditButton.addTarget(self, action: #selector(DriverInfoViewController.addCreditButtonAction), for: .touchUpInside)
        addCreditButton.titleLabel?.font = FONT_NORMAL(15)
        cashPopupView.addSubview(addCreditButton)
        
        let closeButton = makeButton(frame: CGRect(x: cashPopupView.frame.size.width-90,y: tripPriceWillPayLabel.frame.origin.y+tripPriceWillPayLabel.frame.size.height,width:80,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("close", comment: ""), titleColor: UIColor.red, isRounded: false)
        closeButton.addTarget(self, action: #selector(DriverInfoViewController.closeButtonAction), for: .touchUpInside)
        closeButton.titleLabel?.font = FONT_NORMAL(15)
        cashPopupView.addSubview(closeButton)
    }
    
    func cashButtonAction(){
        popupButtonAction()
    }
    //Call Driver Button Action
    func callDriverButtonAction(_ sender: UIButton!) {
        let phoneNumber = driverMobileNumber
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNumber!)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    //popup Add Credit Button Action
    func addCreditButtonAction(){
        closeButtonAction()
        addCredit()
    }
    
    //Hide Popup
    func closeButtonAction(){
        if cashPopupView != nil{
        cashPopupView.removeFromSuperview()
        }
        if transparentView != nil{
        transparentView.removeFromSuperview()
        }
    }
    
    //Add Credit Button Action
    func addCredit(){
        
        // Popup Transparent View
        addCreditTransparentView = UIView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight - 64))
        addCreditTransparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addCreditTransparentView.isUserInteractionEnabled = true
        self.view.addSubview(addCreditTransparentView)
        
        //Add Credit Popup View
        addCreditPopupView = UIView(frame: CGRect(x: 50,y: screenHeight/2-200,width: screenWidth-100,height: 350))
        addCreditPopupView.backgroundColor = whiteColor
        addCreditPopupView.layer.cornerRadius = 0
        addCreditPopupView.layer.shadowColor = UIColor.gray.cgColor
        addCreditPopupView.layer.shadowOpacity = 0.5
        addCreditPopupView.layer.shadowOffset = CGSize(width: 1, height: 1)
        addCreditPopupView.layer.shadowRadius = 20
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            addCreditPopupView.frame.origin.y = 70
        }
        self.view.addSubview(addCreditPopupView)
        
        //popup Add Credit Label
        let addCreditLabel = UILabel(frame: CGRect(x: 0,y: 0, width: addCreditPopupView.frame.size.width, height: 50))
        addCreditLabel.backgroundColor = orangeColor2
        addCreditLabel.textColor = whiteColor
        addCreditLabel.font = FONT_NORMAL(17)
        addCreditLabel.text = NSLocalizedString("addCredit", comment: "")
        addCreditLabel.textAlignment = .center
        addCreditPopupView.addSubview(addCreditLabel)
        
        //Add Creditpopup Current Label
        let addCreditCurrentLabel = UILabel(frame: CGRect(x: addCreditPopupView.frame.size.width/2,y: addCreditLabel.frame.origin.y+addCreditLabel.frame.size.height, width: addCreditPopupView.frame.size.width/2, height: 50))
        addCreditCurrentLabel.backgroundColor = UIColor.white
        addCreditCurrentLabel.textColor = topViewBlue
        addCreditCurrentLabel.font = FONT_NORMAL(13)
        addCreditCurrentLabel.text = NSLocalizedString("currentCredit", comment: "")
        addCreditCurrentLabel.textAlignment = .center
        addCreditPopupView.addSubview(addCreditCurrentLabel)
        
        //popup Current Credit Label
        addCreditCurrentCreditLabel = UILabel(frame: CGRect(x:0,y: addCreditLabel.frame.origin.y+addCreditLabel.frame.size.height, width: addCreditPopupView.frame.size.width/2, height: 50))
        addCreditCurrentCreditLabel.backgroundColor = UIColor.white
        addCreditCurrentCreditLabel.textColor = topViewBlue
        addCreditCurrentCreditLabel.font = FONT_NORMAL(13)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        let NSPrice:NSNumber = NSNumber(value:currentCredit)
        let Separator = formatter.string(from: NSPrice)
        
        addCreditCurrentCreditLabel.text = "\(Separator!)" + NSLocalizedString("rial", comment: "")
        addCreditCurrentCreditLabel.textAlignment = .center
        addCreditPopupView.addSubview(addCreditCurrentCreditLabel)
        getCredit()
        
        //addCreditThrough Label
        let  addCreditThroughLabel = UILabel(frame: CGRect(x: addCreditCurrentCreditLabel.frame.origin.x,y: addCreditCurrentCreditLabel.frame.origin.y+addCreditCurrentCreditLabel.frame.size.height, width: addCreditPopupView.frame.size.width, height: 50))
        addCreditThroughLabel.backgroundColor = whiteColor
        addCreditThroughLabel.textColor = labelTextColor
        addCreditThroughLabel.font = FONT_NORMAL(15)
        addCreditThroughLabel.text = NSLocalizedString("addCreditThrough", comment: "")
        addCreditThroughLabel.textAlignment = .center
        addCreditPopupView.addSubview(addCreditThroughLabel)
        lineView = UIView(frame: CGRect(x: addCreditThroughLabel.frame.origin.x,y: addCreditThroughLabel.frame.origin.y+45,width: addCreditThroughLabel.frame.size.width,height: 1))
        lineView.backgroundColor = lineViewColor
        addCreditPopupView.addSubview(lineView)
        
        //popup online Payment Button
        onlinePaymentButton = makeButton(frame: CGRect(x: addCreditThroughLabel.frame.origin.x,y: addCreditThroughLabel.frame.origin.y+addCreditThroughLabel.frame.size.height,width: addCreditPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("onlinePayment", comment: ""), titleColor: grayColor, isRounded: false)
        onlinePaymentButton.addTarget(self, action: #selector(DriverInfoViewController.onlinePaymentButtonAction), for: .touchUpInside)
        addCreditPopupView.addSubview(onlinePaymentButton)
        
        lineView = UIView(frame: CGRect(x: onlinePaymentButton.frame.origin.x,y: onlinePaymentButton.frame.origin.y+45,width: onlinePaymentButton.frame.size.width,height: 1))
        lineView.backgroundColor = lineViewColor
        addCreditPopupView.addSubview(lineView)
        
        //popup USSD Payment Button
        //USSDPaymentButton = makeButton(frame: CGRect(x: onlinePaymentButton.frame.origin.x,y: onlinePaymentButton.frame.origin.y+onlinePaymentButton.frame.size.height,width: addCreditPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("USSDPayment", comment: ""), titleColor: grayColor, isRounded: false)
        // USSDPaymentButton.addTarget(self, action: #selector(DriverInfoViewController.USSDPaymentButtonAction), for: .touchUpInside)
        // addCreditPopupView.addSubview(USSDPaymentButton)
        // lineView = UIView(frame: CGRect(x: USSDPaymentButton.frame.origin.x,y: USSDPaymentButton.frame.origin.y+45,width: USSDPaymentButton.frame.size.width,height: 1))
        // lineView.backgroundColor = lineViewColor
        // addCreditPopupView.addSubview(lineView)
        
        //popup peykyab Button
        peykyabButton = makeButton(frame: CGRect(x: onlinePaymentButton.frame.origin.x,y: onlinePaymentButton.frame.origin.y+onlinePaymentButton.frame.size.height,width: addCreditPopupView.frame.width,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("peykyabCard", comment: ""), titleColor: grayColor, isRounded: false)
        peykyabButton.addTarget(self, action: #selector(TurnoverViewController.peykYabButtonAction), for: .touchUpInside)
        addCreditPopupView.addSubview(peykyabButton)
        lineView = UIView(frame: CGRect(x: peykyabButton.frame.origin.x,y: peykyabButton.frame.origin.y+45,width: peykyabButton.frame.size.width,height: 1))
        lineView.backgroundColor = lineViewColor
        addCreditPopupView.addSubview(lineView)
        
        //popup amount TextField
        amountTextField = UITextField(frame: CGRect(x: peykyabButton.frame.origin.x,y: peykyabButton.frame.origin.y+peykyabButton.frame.size.height,width: addCreditPopupView.frame.size.width,height: 50))
        amountTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("amountToAdd", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //amountTextField.placeholder = NSLocalizedString("amountToAdd", comment: "")
        amountTextField.backgroundColor = lightBlue
        amountTextField.font = FONT_NORMAL(13)
        amountTextField.textColor = labelGrayColor
        amountTextField.borderStyle = .none
        amountTextField.autocorrectionType = UITextAutocorrectionType.no
        amountTextField.keyboardType = UIKeyboardType.default
        amountTextField.returnKeyType = UIReturnKeyType.done
        amountTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        amountTextField.contentVerticalAlignment = .center
        amountTextField.contentHorizontalAlignment = .center
        amountTextField.textAlignment = .center
        amountTextField.delegate=self
        amountTextField.keyboardType = .numberPad
        amountTextField.tag = 13
        addCreditPopupView.addSubview(amountTextField)
        
        //Popup Pay Button
        payButton = makeButton(frame: CGRect(x: amountTextField.frame.origin.x+amountTextField.frame.size.width-50,y: amountTextField.frame.origin.y+amountTextField.frame.size.height,width: 50,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("pay", comment: ""), titleColor: topViewBlue, isRounded: false)
        payButton.addTarget(self, action: #selector(DriverInfoViewController.payButtonAction), for: .touchUpInside)
        addCreditPopupView.addSubview(payButton)
        
        //popup Close Button
        let closeButton = makeButton(frame: CGRect(x: amountTextField.frame.origin.x,y: amountTextField.frame.origin.y+amountTextField.frame.size.height,width: 50,height: 50), backImageName: nil, backColor: whiteColor, title: NSLocalizedString("close", comment: ""), titleColor: UIColor.red, isRounded: false)
        closeButton.addTarget(self, action: #selector(DriverInfoViewController.addCreditCloseButtonAction), for: .touchUpInside)
        addCreditPopupView.addSubview(closeButton)
    }
    /*
     //USSD PaymentButton Action
     func USSDPaymentButtonAction(){
     onlinePaymentButton.setTitleColor(labelGrayColor,for: UIControlState())
     peykyabButton.setTitleColor(labelGrayColor,for: UIControlState())
     USSDPaymentButton.setTitleColor(topViewBlue,for: UIControlState())
     amountTextField.placeholder = NSLocalizedString("amountToAdd", comment: "")
     payButton.setTitle(NSLocalizedString("pay", comment: ""), for: .normal)
     paymentNumber = 2
     }
     */
    
    //online Payment Action
    func onlinePaymentButtonAction(){
        //USSDPaymentButton.setTitleColor(labelGrayColor,for: UIControlState())
        peykyabButton.setTitleColor(labelGrayColor,for: UIControlState())
        onlinePaymentButton.setTitleColor(topViewBlue,for: UIControlState())
        amountTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("amountToAdd", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //amountTextField.placeholder = NSLocalizedString("amountToAdd", comment: "")
        payButton.setTitle(NSLocalizedString("pay", comment: ""), for: .normal)
        paymentNumber = 1
    }
    
    //Peykyab Button Action
    func peykYabButtonAction(){
        //USSDPaymentButton.setTitleColor(labelGrayColor,for: UIControlState())
        onlinePaymentButton.setTitleColor(labelGrayColor,for: UIControlState())
        peykyabButton.setTitleColor(topViewBlue,for: UIControlState())
        amountTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("enterChargeCardCode", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //amountTextField.placeholder = NSLocalizedString("enterChargeCardCode", comment: "")
        payButton.setTitle(NSLocalizedString("send", comment: ""), for: .normal)
        paymentNumber = 3
    }
    //Pay Button Action
    func payButtonAction(){
        switch paymentNumber
        {
        case 0:
            let alert = UIAlertController(title: NSLocalizedString("addCredit", comment: ""), message:NSLocalizedString("selectAddCreditWay", comment: "") , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case 1:
            shaparak()
            break
            //case 2:
            //USSD()
        //break
        case 3:
            giftCard()
            break
        default:
            print("Nothing")
            break
        }
    }
    
    func addCreditCloseButtonAction(){
        
        addCreditPopupView.removeFromSuperview()
        addCreditTransparentView.removeFromSuperview()
    }
    
    //MARK: -  Connections
    
    //Get Trip Driver Info
    func getTripDriverInfo(){
        
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
        let tripID:Int = UserDefaults.standard.object(forKey: "tripID") as! Int
        
        if sessionID != nil {
            ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
            }
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        "tripid": tripID as AnyObject
            ]
            getTripDriverInfoWithCallBack(apiName: "trip/gettripdriverinfo", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                print("Params:\(params)")
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                })
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        
                        DispatchQueue.main.async {
                            if let driverUrl:String = responseDic.object(forKey:"profilePicture") as? String{
                                self.driverProfileImageView.imageFromServerURL(urlString: driverUrl)
                                self.driverImageURL = driverUrl
                                UserDefaults.standard.set(self.driverImageURL!, forKey: "driverImageURL")
                                
                            }
                            self.driverName = responseDic.object(forKey:"nicename") as? String
                            self.driverNameLabel.text = self.driverName
                            
                            UserDefaults.standard.set(self.driverName!, forKey: "driverName")
                            
                            self.pelak = responseDic.object(forKey:"pelak") as? String
                            self.pelakNumberLabel.text = self.pelak
                            
                            UserDefaults.standard.set(self.pelak!,forKey:"driverPelak")
                            
                            self.driverMobileNumber = responseDic.object(forKey:"mobile") as? String
                            
                            
                            UserDefaults.standard.set(self.driverMobileNumber!,forKey:"driverMobileNumber")
                            
                            self.estimateTimeToOriginText = responseDic.object(forKey:"estimateTimeToOrig_Text") as! String
                            self.estimateTimeLabel.text = " پیک موتوری شما تا "+self.estimateTimeToOriginText+" دیگر می رسد"
                            self.driverLocationLatitude = responseDic.object(forKey:"driverCurrentLatitude") as! CLLocationDegrees
                            print("driver Location Lat:\(self.driverLocationLatitude!)")
                            self.driverLocationLongitude = responseDic.object(forKey:"driverCurrentLongitude") as! CLLocationDegrees
                            print("driver Location Long:\(self.driverLocationLongitude!)")
                            
                            //just Add motor Marker once not each time that view will apear
                            if self.driverLocationMarker == nil{
                                self.driverLocationMarker = GMSMarker()
                                let driverLocation = CLLocationCoordinate2D(latitude: self.driverLocationLatitude!,longitude: self.driverLocationLongitude!)
                                
                                print ("Latitude:\(self.driverLocationLatitude!)","longitude:\(self.driverLocationLongitude!)")
                                
                                self.driverLocationMarker.position = driverLocation
                                let driverMarkerImage = UIImage(named: "motor")
                                self.driverLocationMarker.icon = driverMarkerImage
                                self.driverLocationMarker.snippet = NSLocalizedString("peykLocation", comment: "")
                                self.driverLocationMarker.appearAnimation = kGMSMarkerAnimationPop
                                self.driverLocationMarker.map = self.mapView
                                
                                let path = GMSMutablePath()
                                path.add(driverLocation)
                                path.add(self.twoDPos)
                                
                                let bounds = GMSCoordinateBounds(path: path)
                                self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding:120.0))
                                self.mapView.isUserInteractionEnabled = false
                            }
                            
                        }
                        //                        DispatchQueue.main.async {
                        //                            print("Params:\(params)")
                        //                            let msg:String = responseDic.object(forKey: "msg") as! String
                        //                            let alert = UIAlertController(title: NSLocalizedString("message", comment: ""), message: msg, preferredStyle: UIAlertControllerStyle.alert)
                        //                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                        //                            self.present(alert, animated: true, completion: nil)
                        //                            self.sendpopupView.removeFromSuperview()
                        //                            self.transparentView.removeFromSuperview()
                        //                        }
                    }else/*status>1*/{
                        //Session Expired
                        if (resDic?.object(forKey: "code") as! Int) == 403 && (resDic?.object(forKey: "status") as! Int) == 0{
                            
                            DispatchQueue.main.async {
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                nextViewController.showBackButton = false
                                self.present(nextViewController, animated: true, completion: nil)
                                
                                //                            let msg:String = responseDic.object(forKey: "msg") as! String
                                //                            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:msg , preferredStyle: UIAlertControllerStyle.alert)
                                //                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                                //self.present(alert, animated: true, completion: nil)
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
    
    //get Credit Connection
    func getCredit(){
        
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
                                                        ]
            getCreditWithCallBack(apiName: "billing/getcredit", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                })
                
                if let responseDic = resDic{
                    
                    if (resDic?.object(forKey: "status") as! Int) == 1{
                        
                        self.currentCredit = resDic?.object(forKey: "credit") as! Int
                        
                        DispatchQueue.main.async{
                            
                            self.currentCredit = resDic?.object(forKey: "credit") as! Int!
                            
                            let formatter = NumberFormatter()
                            formatter.numberStyle = .decimal
                            formatter.groupingSeparator = ","
                            let NSPrice:NSNumber = NSNumber(value:self.currentCredit)
                            let Separator = formatter.string(from: NSPrice)
                            
                            self.currentCreditLabel.text = "\(Separator!)" + NSLocalizedString("rial", comment: "")
                        }
                    }else/*status>1*/{
                        //Session Expired
                        if (resDic?.object(forKey: "code") as! Int) == 403 && (resDic?.object(forKey: "status") as! Int) == 0{
                            
                            DispatchQueue.main.async {
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                nextViewController.showBackButton = false
                                self.present(nextViewController, animated: true, completion: nil)
                                
                                //                            let msg:String = responseDic.object(forKey: "msg") as! String
                                //                            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:msg , preferredStyle: UIAlertControllerStyle.alert)
                                //                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                                //self.present(alert, animated: true, completion: nil)
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
    //Add Credit via Online Payment in Webview Connection
    func shaparak(){
        
        if (amountTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterCreditAmount", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
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
        
        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
        
        let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
        
        //let chargeamount:Int? = Int(amountTextField.text!)!
        
        //convert persian number to english number
        let NumberStr: String = amountTextField.text!
        let Formatter: NumberFormatter = NumberFormatter()
        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
        let final = Formatter.number(from: NumberStr)
        if final != 0 {
            print("\(final!)")
        }
        let chargeamount:Int? = Int(final!)
        print (chargeamount!)
        
        if sessionID != nil {
            
            let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                        "paymenttype":paymentNumber as AnyObject,
                                                        "chargeamount":chargeamount! as AnyObject
            ]
            shaparakWithCallBack(apiName: "billing/creditcharge", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                })
                
                if let responseDic = resDic{
                    
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        DispatchQueue.main.async{
                            
                            self.addCreditPopupView.removeFromSuperview()
                            self.addCreditTransparentView.removeFromSuperview()
                            
                            self.webViewURL = responseDic.object(forKey: "url") as! String
                            
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ShaparakViewController") as! ShaparakViewController
                            nextViewController.webViewURL = self.webViewURL
                            self.present(nextViewController, animated:true, completion:nil)
                            
                        }
                    }else/*status>1*/{
                        //Session Expired
                        if (resDic?.object(forKey: "code") as! Int) == 403 && (resDic?.object(forKey: "status") as! Int) == 0{
                            
                            DispatchQueue.main.async {
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                nextViewController.showBackButton = false
                                self.present(nextViewController, animated: true, completion: nil)
                                
                                //                            let msg:String = responseDic.object(forKey: "msg") as! String
                                //                            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:msg , preferredStyle: UIAlertControllerStyle.alert)
                                //                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
                                //self.present(alert, animated: true, completion: nil)
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
                //ERROR
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
    
    //Add Credit  via peikyab Charge Card Connection
    func giftCard(){
        
        if (amountTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterCreditAmount", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
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
                                                        "chargecardcode":amountTextField.text! as AnyObject
            ]
            setChargeCardWithCallBack(apiName: "billing/setchargecard", params: params as NSDictionary?){
                (resDic:NSDictionary?, error:NSError?) in
                
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                })
                
                if let responseDic = resDic{
                    if (responseDic.object(forKey: "status") as! Int) == 1{
                        
                        self.addCreditPopupView.removeFromSuperview()
                        
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
                                //self.present(alert, animated: true, completion: nil)
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
