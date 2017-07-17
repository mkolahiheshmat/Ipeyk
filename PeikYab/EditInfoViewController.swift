//
//  editInfoViewController.swift
//  PeikYab
//
//  Created by nooran on 9/4/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class EditInfoViewController:BaseViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate, UIScrollViewDelegate{
    
    //MARK: - Variables
    var scrollView : UIScrollView!
    var nameImage:UIImageView!
    var nameTextField : UITextField!
    var phoneImage:UIImageView!
    var phoneTextField : UITextField!
    var mobileImage:UIImageView!
    var mobileTextField : UITextField!
    var emailImage:UIImageView!
    var emailTextField : UITextField!
    var addressImage:UIImageView!
    var addressTextField : UITextField!
    var genderImage:UIImageView!
    var genderTextField : UITextField!
    var birthImage:UIImageView!
    var birthTextField : UITextField!
    var genderPickerView = UIPickerView()
    var datePickerView = UIPickerView()
    var genderPickerViewArray = NSArray()
    var yearArray = NSMutableArray()
    var monthArray = NSMutableArray()
    var dayArray = NSMutableArray()
    var dayStr = ""
    var monthStr = ""
    var yearStr = ""
    var saveButton:UIButton!
    var imageWidth:CGFloat = 50
    var imageHeight:CGFloat = 50
    var genderNumber:Int!
    var phoneNumber :String!
    
    
    //MARK: -  viewDidLoad
    override func viewDidLoad(){
        super.viewDidLoad()
        
        getProfile()
        
        self.hideKeyboardWhenTappedAround()
        scrollView = UIScrollView(frame: CGRect(x: 0,y: 64,width: screenWidth,height: screenHeight - 64))
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        if DeviceType.IS_IPHONE_4_OR_LESS {
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight+200)
        }else if DeviceType.IS_IPHONE_5{
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        }else if DeviceType.IS_IPHONE_6{
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        }else if DeviceType.IS_IPHONE_6P{
            scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        }
        self.view.addSubview(scrollView)
        
        makeTopbar(NSLocalizedString("editInfo", comment: ""))
        backButton.addTarget(self, action: #selector(TurnoverViewController.backAction), for: .touchUpInside)
        
        //Name Image
        nameImage = UIImageView(frame: CGRect(x: screenWidth-70,y: 0, width: imageWidth, height: imageHeight))
        nameImage.contentMode = .scaleAspectFit
        nameImage.image = UIImage(named: "name.png")
        scrollView.addSubview(nameImage)
        
        //Name TextField
        nameTextField = UITextField(frame: CGRect(x: 30,y: nameImage.frame.origin.y,width: screenWidth-imageWidth-50,height: 45))
        nameTextField.resignFirstResponder()
        nameTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("enterYourName", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //nameTextField.placeholder = NSLocalizedString("enterYourName", comment: "")
        nameTextField.layer.borderColor = grayColor.cgColor
        nameTextField.textColor = UIColor.black
        nameTextField.backgroundColor = whiteColor
        nameTextField.textAlignment = .right
        nameTextField.autocorrectionType = .no
        nameTextField.font = FONT_MEDIUM(12)
        nameTextField.autocorrectionType = .no
        nameTextField.delegate = self
        nameTextField.tag = 10
        addLineView(nameTextField.frame.origin.x,y:nameTextField.frame.origin.y+45,w:nameTextField.frame.size.width,h:2,color:lineViewColor,superView:scrollView)
        scrollView.addSubview(nameTextField)
        
        //Phone Image
        phoneImage = UIImageView(frame: CGRect(x: nameImage.frame.origin.x,y: nameImage.frame.origin.y+nameImage.frame.size.height+10, width: imageWidth, height: imageHeight))
        phoneImage.contentMode = .scaleAspectFit
        phoneImage.image = UIImage(named: "phone.png")
        scrollView.addSubview(phoneImage)
        
        //Phone TextField
        phoneTextField = UITextField(frame: CGRect(x: 30,y: phoneImage.frame.origin.y,width: screenWidth-imageWidth-50,height: 45))
        phoneTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("phoneNumber", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //phoneTextField.placeholder = NSLocalizedString("phoneNumber", comment: "")
        phoneTextField.delegate = self
        phoneTextField.keyboardType = .numberPad
        phoneTextField.layer.borderColor = grayColor.cgColor
        phoneTextField.textColor = UIColor.black
        phoneTextField.backgroundColor = whiteColor
        phoneTextField.textAlignment = .right
        phoneTextField.keyboardType = .numberPad
        phoneTextField.font = FONT_MEDIUM(12)
        phoneTextField.autocorrectionType = .no
        phoneTextField.delegate = self
        phoneTextField.tag = 11
        addLineView(phoneTextField.frame.origin.x,y:phoneTextField.frame.origin.y+45,w:phoneTextField.frame.size.width,h:2,color:lineViewColor,superView:scrollView)
        scrollView.addSubview(phoneTextField)
        
        //Mobile Image
        mobileImage = UIImageView(frame: CGRect(x: phoneImage.frame.origin.x,y: phoneImage.frame.origin.y+phoneImage.frame.size.height+10, width: imageWidth, height: imageHeight))
        mobileImage.contentMode = .scaleAspectFit
        mobileImage.image = UIImage(named: "mobile.png")
        scrollView.addSubview(mobileImage)
        
        //Mobile TextField
        mobileTextField = UITextField(frame: CGRect(x: 30,y: mobileImage.frame.origin.y,width: screenWidth-imageWidth-50,height: 45))

         mobileTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("mobileNumber", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //mobileTextField.placeholder = NSLocalizedString("mobileNumber", comment: "")
        mobileTextField.layer.borderColor = grayColor.cgColor
        mobileTextField.textColor = UIColor.lightGray
        mobileTextField.backgroundColor = whiteColor
        mobileTextField.textAlignment = .right
        mobileTextField.keyboardType = .numberPad
        mobileTextField.font = FONT_MEDIUM(12)
        mobileTextField.autocorrectionType = .no
        mobileTextField.tag = 12
        mobileTextField.delegate = self
        
        let mobileNumber = UserDefaults.standard.object(forKey: "mobileNumber")
        if mobileNumber != nil{
            mobileTextField.text = mobileNumber as! String?
        }
        
        mobileTextField.isUserInteractionEnabled = false
        addLineView(mobileTextField.frame.origin.x,y:mobileTextField.frame.origin.y+45,w:mobileTextField.frame.size.width,h:2,color:lineViewColor,superView:scrollView)
        scrollView.addSubview(mobileTextField)
        
        //Email Image
        emailImage = UIImageView(frame: CGRect(x: mobileImage.frame.origin.x,y: mobileImage.frame.origin.y+mobileImage.frame.size.height+10, width: imageWidth, height: imageHeight))
        emailImage.contentMode = .scaleAspectFit
        emailImage.image = UIImage(named: "email.png")
        scrollView.addSubview(emailImage)
        
        //Email TextField
        emailTextField = UITextField(frame: CGRect(x: 30,y: emailImage.frame.origin.y,width: screenWidth-imageWidth-50,height: 45))
        emailTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("email", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //emailTextField.placeholder = NSLocalizedString("email", comment: "")
        emailTextField.delegate = self
        emailTextField.tag = 13
        emailTextField.layer.borderColor = grayColor.cgColor
        emailTextField.textColor = UIColor.lightGray
        emailTextField.backgroundColor = whiteColor
        emailTextField.textAlignment = .right
        emailTextField.font = FONT_MEDIUM(12)
        emailTextField.autocorrectionType = .no
        
        let email = UserDefaults.standard.object(forKey: "userName")
        if email != nil{
            emailTextField.text = email as! String?
        }
        emailTextField.isUserInteractionEnabled = false
        addLineView(emailTextField.frame.origin.x,y:emailTextField.frame.origin.y+45,w:emailTextField.frame.size.width,h:2,color:lineViewColor,superView:scrollView)
        scrollView.addSubview(emailTextField)
        
        //Address Image
        addressImage = UIImageView(frame: CGRect(x: emailImage.frame.origin.x,y: emailImage.frame.origin.y+emailImage.frame.size.height+10, width: imageWidth, height: imageHeight))
        addressImage.contentMode = .scaleAspectFit
        addressImage.image = UIImage(named: "address.png")
        scrollView.addSubview(addressImage)
        
        //Address TextField
        addressTextField = UITextField(frame: CGRect(x: 30,y: addressImage.frame.origin.y,width: screenWidth-imageWidth-50,height: 45))
        addressTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("address", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //addressTextField.placeholder = NSLocalizedString("address", comment: "")
        addressTextField.delegate = self
        addressTextField.tag = 14
        addressTextField.layer.borderColor = grayColor.cgColor
        addressTextField.textColor = UIColor.black
        addressTextField.backgroundColor = whiteColor
        addressTextField.textAlignment = .right
        addressTextField.font = FONT_MEDIUM(12)
        addressTextField.autocorrectionType = .no
        addLineView(addressTextField.frame.origin.x,y:addressTextField.frame.origin.y+45,w:addressTextField.frame.size.width,h:2,color:lineViewColor,superView:scrollView)
        scrollView.addSubview(addressTextField)
        
        //Birthday Image
        birthImage = UIImageView(frame: CGRect(x: addressImage.frame.origin.x,y: addressImage.frame.origin.y+addressImage.frame.size.height+20, width: imageWidth, height: imageHeight))
        birthImage.contentMode = .scaleAspectFit
        birthImage.image = UIImage(named: "birth.png")
        scrollView.addSubview(birthImage)
        
        //Birthday TextField
        birthTextField = UITextField(frame: CGRect(x: 30,y: birthImage.frame.origin.y,width: screenWidth-imageWidth-50,height: 45))
        birthTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("birthDate", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //birthTextField.placeholder = NSLocalizedString("birthDate", comment: "")
        birthTextField.layer.borderColor = grayColor.cgColor
        birthTextField.textColor = UIColor.black
        birthTextField.delegate = self
        birthTextField.backgroundColor = whiteColor
        birthTextField.textAlignment = .right
        birthTextField.inputView = datePickerView
        birthTextField.font = FONT_MEDIUM(12)
        birthTextField.tag = 15
        addLineView(birthTextField.frame.origin.x,y:birthTextField.frame.origin.y+45,w:birthTextField.frame.size.width,h:2,color:lineViewColor,superView:scrollView)
        scrollView.addSubview(birthTextField)
        makeDatePickerView()
        
        //gender Image
        genderImage = UIImageView(frame: CGRect(x: birthImage.frame.origin.x,y: birthImage.frame.origin.y+birthImage.frame.size.height+10, width: imageWidth, height: imageHeight))
        genderImage.contentMode = .scaleAspectFit
        genderImage.image = UIImage(named: "gender.png")
        scrollView.addSubview(genderImage)
        
        //gender TextField
        genderTextField = UITextField(frame: CGRect(x: 30,y: genderImage.frame.origin.y,width: screenWidth-imageWidth-50,height: 45))
        genderTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("gender", comment: ""),attributes:[NSForegroundColorAttributeName: UIColor.darkGray])
        //genderTextField.placeholder = NSLocalizedString("gender", comment: "")
        genderTextField.layer.borderColor = grayColor.cgColor
        genderTextField.textColor = UIColor.black
        genderTextField.delegate = self
        genderTextField.backgroundColor = whiteColor
        genderTextField.textAlignment = .right
        genderTextField.inputView = genderPickerView
        genderTextField.font = FONT_MEDIUM(12)
        genderTextField.tag = 16
        addLineView(genderTextField.frame.origin.x,y:genderTextField.frame.origin.y+45,w:genderTextField.frame.size.width,h:2,color:lineViewColor,superView:scrollView)
        scrollView.addSubview(genderTextField)
        makeGenderPickerView()
        
        // Save Button
        saveButton = UIButton(frame: CGRect(x: 0,y: screenHeight-60,width: screenWidth,height: 60))
        saveButton.backgroundColor = greenColor
        saveButton.titleLabel?.font = FONT_MEDIUM(15)
        saveButton.setTitle(NSLocalizedString("saveChanges", comment: ""), for:UIControlState())
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        self.view.addSubview(saveButton)
        
    }
    //MARK: -  PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1000
        {
            return 1
        }else{
            return 3
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1000{
            return genderPickerViewArray.count
        }else{
            if component == 0{
                return yearArray.count
            }else if component == 1 {
                return monthArray.count
            }else{
                return dayArray.count
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1000{
            return String(describing: (genderPickerViewArray.object(at: row)))
        }else{
        }
        if component == 0{
            return String(describing: yearArray.object(at: row))
        }else if component == 1 {
            return  String(describing: monthArray.object(at: row))
        }else{
            return  String(describing: dayArray.object(at: row))
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1000
        {
            genderTextField.resignFirstResponder()
            genderTextField.text = genderPickerViewArray[row] as? String
            if genderPickerViewArray[row] as? String == NSLocalizedString("male", comment: ""){
                genderNumber = 2
            }else if genderPickerViewArray[row] as? String == NSLocalizedString("female", comment: ""){
                genderNumber = 1
            }
            
        }else{
            switch component
            {
            case 0:
                yearStr = String(describing: yearArray[row])
                break
            case 1:
                monthStr = String(describing: monthArray[row])
                changeMonthNameToNumber(nameString: monthArray[row] as! String)
                break
            case 2:
                dayStr = String(describing: dayArray[row])
                break
            default:
                print("")
            }
            if yearStr.characters.count>0 && monthStr.characters.count > 0 && dayStr.characters.count > 0 {
                birthTextField.resignFirstResponder()
                birthTextField.text = yearStr + "-" + monthStr + "-" + dayStr
            }
        }
    }
    
    //MARK: -  TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        addLineView(textField.frame.origin.x,y:textField.frame.origin.y+45,w:textField.frame.size.width,h:2,color:greenColor,superView: scrollView)
        if DeviceType.IS_IPHONE_4_OR_LESS {
            if textField.tag == 12 {
                scrollView.setContentOffset(CGPoint(x: 0,y: 50), animated: true)
            }else if textField.tag == 13{
                scrollView.setContentOffset(CGPoint(x: 0,y: 100), animated: true)
            }else if  textField.tag == 14{
                scrollView.setContentOffset(CGPoint(x: 0,y: 150), animated: true)
            }else if  textField.tag == 15{
                scrollView.setContentOffset(CGPoint(x: 0,y: 200), animated: true)
            }else if  textField.tag == 16{
                scrollView.setContentOffset(CGPoint(x: 0,y: 250), animated: true)
            }
        }else if DeviceType.IS_IPHONE_5{
            if  textField.tag == 13 || textField.tag == 14 || textField.tag == 15 || textField.tag == 16{
                UIView.animate(withDuration: 0.8, animations: {
                    var rect = self.view.frame
                    rect.origin.y -= 150
                    self.view.frame = rect
                })
            }
        }else if DeviceType.IS_IPHONE_6{
            if  textField.tag == 16{
                UIView.animate(withDuration: 0.8, animations: {
                    var rect = self.view.frame
                    rect.origin.y -= 70
                    self.view.frame = rect
                })
            }
        }else if DeviceType.IS_IPHONE_6P{
            //OK
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //scrollView.setContentOffset(CGPoint(x: 1,y: 1), animated: true)
        //scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        addLineView(textField.frame.origin.x,y:textField.frame.origin.y+45,w:textField.frame.size.width,h:2,color:lineViewColor,superView: scrollView)
        
//        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
//        if nameTextField.text?.rangeOfCharacter(from: characterset.inverted) != nil {
//            print("name=\(nameTextField.text!)")
//            nameTextField.text = "HELLO"
//        }else{
//            nameTextField.text = nameTextField.text
//        }

        
        UIView.animate(withDuration: 0.5, animations: {
            var rect = self.view.frame
            rect.origin.y = 0
            self.view.frame = rect
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: -  Custom Methods
    func backAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func makeGenderPickerView(){
        genderPickerView.layer.borderColor = grayColor.cgColor
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.tag = 1000
        genderPickerViewArray = [NSLocalizedString("male", comment: ""), NSLocalizedString("female", comment: "")];
        genderPickerView.layer.borderWidth = 1.0
        genderPickerView.backgroundColor = whiteColor
    }
    
    func makeDatePickerView(){
        for index in 1320...1377
        {
            yearArray.add(String(index))
        }
        for index in 1...31
        {
            dayArray.add(String(index))
        }
        monthArray = [NSLocalizedString("month1", comment: ""), NSLocalizedString("month2", comment: ""), NSLocalizedString("month3", comment: ""), NSLocalizedString("month4", comment: ""), NSLocalizedString("month5", comment: ""), NSLocalizedString("month6", comment: ""), NSLocalizedString("month7", comment: ""), NSLocalizedString("month8", comment: ""), NSLocalizedString("month9", comment: ""), NSLocalizedString("month10", comment: ""),NSLocalizedString("month11", comment: ""),NSLocalizedString("month12", comment: "")];
        datePickerView.layer.borderColor = grayColor.cgColor
        datePickerView.delegate = self
        datePickerView.dataSource = self
        datePickerView.tag = 2000
        datePickerView.layer.borderWidth = 1.0
        datePickerView.backgroundColor = whiteColor
    }
    
    //Save Button Action that call Set Profile Connection
    func saveButtonAction(){
        setProfile()
    }
    func changeMonthNameToNumber(nameString : String){
        switch nameString
        {
        case NSLocalizedString("month1", comment: ""):
            monthStr  = "1"
            break
        case NSLocalizedString("month2", comment: ""):
            monthStr  = "2"
            break
        case NSLocalizedString("month3", comment: ""):
            monthStr  = "3"
            break
        case NSLocalizedString("month4", comment: ""):
            monthStr  = "4"
            break
        case NSLocalizedString("month5", comment: ""):
            monthStr  = "5"
            break
        case NSLocalizedString("month6", comment: ""):
            monthStr  = "6"
            break
        case NSLocalizedString("month7", comment: ""):
            monthStr  = "7"
            break
        case NSLocalizedString("month8", comment: ""):
            monthStr  = "8"
            break
        case NSLocalizedString("month9", comment: ""):
            monthStr  = "9"
            break
        case NSLocalizedString("month10", comment: ""):
            monthStr  = "10"
            break
        case NSLocalizedString("month11", comment: ""):
            monthStr  = "11"
            break
        case NSLocalizedString("month12", comment: ""):
            monthStr  = "12"
            break

        default:
            break
        }
        
    }
    
    //MARK: -  Connections
    
    //Set Profile Connection
    func setProfile(){
        if (nameTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterYourName", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
//        if (phoneTextField.text?.characters.count) != 8 {
//            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("phoneNotCorrect", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
        /*
         if (mobileTextField.text?.characters.count) != 11 {
         let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("mobileNotCorrect", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         return
         }
         
         if (emailTextField.text?.characters.count==0)||(!emailTextField.text!.isEmail){
         let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("wrongEmailMessage", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
         alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         return
         }
         */
        if (addressTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("enterYourAddress", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (birthTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("selectYourBirthDate", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if (genderTextField.text?.characters.count==0){
            let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message:NSLocalizedString("selectYourGender", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
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
        
        if genderTextField.text == NSLocalizedString("male", comment: ""){
            genderNumber = 1
        }else if genderTextField.text == NSLocalizedString("female", comment: ""){
            genderNumber = 2
        }
        
        //convert persian number to english number
        let NumberStr: String = phoneTextField.text!
        let Formatter: NumberFormatter = NumberFormatter()
        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale!
        let final = Formatter.number(from: NumberStr)
        if final != 0 {
            print("\(final!)")
            phoneNumber = ("\(final!)")
            print (phoneNumber)
            
            if  phoneNumber.characters.count != 8{
                phoneNumber = "0" + ("\(final!)")
            }
        }
        
        //expired Session ---> "fdc7473e946a60201103136e5cc6489d" as AnyObject,
        let sessionID:String? = UserDefaults.standard.object(forKey: "sessionID") as? String
        
        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
        let params :Dictionary<String,AnyObject> = ["sessionid": sessionID! as AnyObject,
                                                    "nicename":self.nameTextField.text! as AnyObject ,
                                                    "landline":phoneNumber as AnyObject,
                                                    //"mobile":self.mobileTextField.text! as AnyObject,
            "email":self.emailTextField.text! as AnyObject,
            "address":self.addressTextField.text! as AnyObject,
            "birthdate":self.birthTextField.text! as AnyObject,
            "gender":genderNumber! as AnyObject
        ]
        
        print(params)
        setProfileWithCallBack(apiName: "setprofile", params: params as NSDictionary?){ (resDic:NSDictionary?, error:NSError?) in
            ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
            
            if let responseDic = resDic{
                if (responseDic.object(forKey: "status") as! Int) == 1{
                    
                    DispatchQueue.main.async {
                         _ = self.navigationController?.popToRootViewController(animated: false)
                        let alert = UIAlertController(title: NSLocalizedString("setProfile", comment: ""), message: NSLocalizedString("saveProfile", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
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
    
    //Call Get Profile Connection
    func getProfile(){
        
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
        
        print ("getProfile Session=\(sessionID)")
        
        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
        }
        let params :Dictionary<String,AnyObject> = ["sessionid":sessionID! as AnyObject]
        
        getProfileWithCallBack(apiName: "getprofile", params: params as NSDictionary?){ (resDic:NSDictionary?, error:NSError?) in
            ARSLineProgress.hideWithCompletionBlock({ () -> Void in
            })
            if let responseDic = resDic{
                
                if (responseDic.object(forKey: "status") as! Int) == 1{
                    DispatchQueue.main.async {
                        self.nameTextField.text = (responseDic.object(forKey: "nicename") as! String?)!
                        
                        let phoneNumber = responseDic.object(forKey: "landline")
                        
                        if phoneNumber != nil {
                            self.phoneTextField.text = phoneNumber as! String?  //(responseDic.object(forKey: "landline") as! String?)!
                        }
                        
                        let address = responseDic.object(forKey: "address")
                        
                        if address != nil{
                            self.addressTextField.text = address as! String?  //(responseDic.object(forKey: "address") as! String?)!
                        }
                        let birthday = responseDic.object(forKey: "birthdate")
                        
                        if birthday != nil{
                            
                            let birthDayString = (responseDic.object(forKey: "birthdate") as! String?)!
                            let birthDayArray : [String] = birthDayString.components(separatedBy: " ")
                            
                            self.birthTextField.text = birthDayArray[0]
                        }
                        let genderInt:Int? = responseDic.object(forKey: "gender") as? Int
                        if genderInt == 1{ //Male
                            self.genderTextField.text = NSLocalizedString("male", comment: "")
                        }else if genderInt == 2{ //female
                            self.genderTextField.text = NSLocalizedString("female", comment: "")
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
