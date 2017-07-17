//
//  Requester.swift
//  PeikYab
//
//  Created by Yarima on 8/30/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

//username: saman.salehi71@gmail.com
//password: 123

import Foundation

let baseURL = "http://ipeyk.com/services/client/"

let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
let time:String = String(getCurrentInMillis())
let salt = "asia-peykyab-1"
let hash:String = generateHash(appid:appid, time:time, imei:getUUID(), salt:salt)

let Headers = [
    "accept-language": "fa",
    "appid": appid,
    "accept": "application/json",
    "time": time,
    "hash":  hash,
    "imei": getUUID(),
    "cache-control": "no-cache",
    "content-type": "application/x-www-form-urlencoded",
    "os": "ios",
    "subscribertype": "1",
    "postman-token":"988f5bdd-a665-495a-5f6d-21a6cab634c7",
    "packagename":"ir.vasl.peykyab"
]

func getUUID() -> String{
    let uuID:String? = UserDefaults.standard.object(forKey: "UUID") as? String
    if uuID == nil {
        let uuid = NSUUID().uuidString
        UserDefaults.standard.set(uuid, forKey: "UUID")
        return uuid
    }else{
        return uuID!
    }
    
}
func signupWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    let parameters = params!
    let manager = AFHTTPSessionManager()
    manager.requestSerializer.setValue("fa", forHTTPHeaderField: "accept-language")
    manager.requestSerializer.setValue(appid, forHTTPHeaderField: "appid")
    manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "accept")
    manager.requestSerializer.setValue(time, forHTTPHeaderField: "time")
    manager.requestSerializer.setValue(hash, forHTTPHeaderField: "hash")
    manager.requestSerializer.setValue(getUUID(), forHTTPHeaderField: "imei")
    manager.requestSerializer.setValue("no-cache", forHTTPHeaderField: "cache-control")
    manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
    manager.requestSerializer.setValue("ios", forHTTPHeaderField: "os")
    manager.requestSerializer.setValue("1", forHTTPHeaderField: "subscribertype")
    manager.requestSerializer.setValue("ir.vasl.peykyab", forHTTPHeaderField: "packagename")
    manager.requestSerializer.setValue("988f5bdd-a665-495a-5f6d-21a6cab634c7", forHTTPHeaderField: "postman-token")
    
    manager.post("\(baseURL)\(apiName)", parameters: parameters, progress: nil, success: { (URLSessionDataTask, responseObject:Any) in
        print(responseObject as! NSDictionary)
        completionHandler(responseObject as? NSDictionary, nil)
        }, failure: { (data:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            completionHandler(nil, error as NSError)
    })
}

func registerTokenAsyncWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    let headers = Headers
    let parameters = params!
    
    // let postString = "sessionid=\(parameters.object(forKey: "sessionid")!)" + "&token=\(parameters.object(forKey: "token")!)" + "&os=\(parameters.object(forKey: "os")!)" + "&phoneNum=09121234567" //+ "&phoneNum=\(parameters.object(forKey: "phoneNum")!)"
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    postData.append("&token=\(parameters.object(forKey: "token")!)".data(using: String.Encoding.utf8)!)
    postData.append("&os=\(parameters.object(forKey: "os")!)".data(using: String.Encoding.utf8)!)
    postData.append("&phoneNum=\(parameters.object(forKey: "phoneNum")!)".data(using: String.Encoding.utf8)!)
    
    print("postData:\(postData)")
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    
    //let data = postString.data(using: String.Encoding.unicode, allowLossyConversion: true)
    //print("Data = \(data.unsafelyUnwrapped)")
    //let convertedStr = NSString(data: data!, encoding: String.Encoding.unicode.rawValue)
    //print("Converted String = \(convertedStr!)")
    
    request.httpBody = postData  //data
    
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg")!)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    dataTask.resume()
}

func loginWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "username=\(parameters.object(forKey: "username")!)".data(using: String.Encoding.utf8)!) as Data
    postData.append("&password=\(parameters.object(forKey: "password")!)".data(using: String.Encoding.utf8)!)
    print (postData)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    
    //    let request = NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //                                      cachePolicy: .useProtocolCachePolicy,
    //                                      timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError? )
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func forgotPasswordWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    print("parameters:\(parameters)")
    
    let postData = NSData(data: "mobile_email=\(parameters.object(forKey: "mobile_email")!)".data(using: String.Encoding.utf8)!) as Data
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func getNearDriversWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    //postData.appendData("&name=\(parameters.objectForKey("name")!)".dataUsingEncoding(NSUTF8StringEncoding)!)
    
    //35.748425914532549
    //51.285110078752041
    
    //35.753467, 51.294948
    
    //var latitude: Double = parameters.objectForKey("latitude") as! Double
    //postData.append("&latitude=latitude".data(using: String.Encoding.utf8)!)
    
    //var longitude: Double = parameters.objectForKey("longitude") as! Double
    //postData.append("&longitude=longitude".data(using: String.Encoding.utf8)!)
    
    // print(parameters.object(forKey: "latitude")!)
    
    let lat:String? = parameters.object(forKey: "latitude")! as? String
    postData.append("&latitude=\(lat!)".data(using: String.Encoding.utf8)!)
    
    let long:String? = parameters.object(forKey: "longitude")! as? String
    postData.append("&longitude=\(long!)".data(using: String.Encoding.utf8)!)
    
    //postData.append("&latitude=\(parameters.object(forKey: "latitude")!)".data(using: String.Encoding.utf8)!)
    //postData.append("&longitude=\(parameters.object(forKey: "longitude")!)".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    //    let request = NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //                                      cachePolicy: .useProtocolCachePolicy,
    //                                      timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                //print(object.object(forKey: "msg") as Any)
                print (object.object(forKey: "data") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func getTripListWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    print(parameters)
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    let status: Int = parameters.object(forKey: "status") as! Int
    postData.append("&status=\(status)".data(using: String.Encoding.utf8)!)
    
    let page: Int = parameters.object(forKey: "page") as! Int
    postData.append("&page=\(page)".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                print (object.object(forKey: "data") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func getSupportIssueListWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    print(parameters)
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    let type:Int = parameters.object(forKey: "type") as! Int
    postData.append("&type=\(type)".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                //print(object.object(forKey: "msg") as Any)
                print (object.object(forKey: "data") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func supportSendIssueWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    let parameters = params!
    let manager = AFHTTPSessionManager()
    manager.requestSerializer.setValue("fa", forHTTPHeaderField: "accept-language")
    manager.requestSerializer.setValue(appid, forHTTPHeaderField: "appid")
    manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "accept")
    manager.requestSerializer.setValue(time, forHTTPHeaderField: "time")
    manager.requestSerializer.setValue(hash, forHTTPHeaderField: "hash")
    manager.requestSerializer.setValue(getUUID(), forHTTPHeaderField: "imei")
    manager.requestSerializer.setValue("no-cache", forHTTPHeaderField: "cache-control")
    manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
    manager.requestSerializer.setValue("ios", forHTTPHeaderField: "os")
    manager.requestSerializer.setValue("1", forHTTPHeaderField: "subscribertype")
    manager.requestSerializer.setValue("ir.vasl.peykyab", forHTTPHeaderField: "packagename")
    manager.requestSerializer.setValue("988f5bdd-a665-495a-5f6d-21a6cab634c7", forHTTPHeaderField: "postman-token")
    
    manager.post("\(baseURL)\(apiName)", parameters: parameters, progress: nil, success: { (URLSessionDataTask, responseObject:Any) in
        print(responseObject as! NSDictionary)
        completionHandler(responseObject as? NSDictionary, nil)
        }, failure: { (data:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            completionHandler(nil, error as NSError)
    })

}

func logoutWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "username=\(parameters.object(forKey: "username")!)".data(using: String.Encoding.utf8)!) as Data
    postData.append("&sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!)
    print (postData)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    
    //    let request = NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //                                      cachePolicy: .useProtocolCachePolicy,
    //                                      timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError? )
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}
func getProfileWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    let postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    print (postData)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError? )
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func setProfileWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    let parameters = params!
    let manager = AFHTTPSessionManager()
    manager.requestSerializer.setValue("fa", forHTTPHeaderField: "accept-language")
    manager.requestSerializer.setValue(appid, forHTTPHeaderField: "appid")
    manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "accept")
    manager.requestSerializer.setValue(time, forHTTPHeaderField: "time")
    manager.requestSerializer.setValue(hash, forHTTPHeaderField: "hash")
    manager.requestSerializer.setValue(getUUID(), forHTTPHeaderField: "imei")
    manager.requestSerializer.setValue("no-cache", forHTTPHeaderField: "cache-control")
    manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
    manager.requestSerializer.setValue("ios", forHTTPHeaderField: "os")
    manager.requestSerializer.setValue("1", forHTTPHeaderField: "subscribertype")
    manager.requestSerializer.setValue("ir.vasl.peykyab", forHTTPHeaderField: "packagename")
    manager.requestSerializer.setValue("988f5bdd-a665-495a-5f6d-21a6cab634c7", forHTTPHeaderField: "postman-token")
    
    manager.post("\(baseURL)\(apiName)", parameters: parameters, progress: nil, success: { (URLSessionDataTask, responseObject:Any) in
        print(responseObject as! NSDictionary)
        completionHandler(responseObject as? NSDictionary, nil)
        }, failure: { (data:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            completionHandler(nil, error as NSError)
    })
}

func getSettingWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    let postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    //NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //  cachePolicy: .useProtocolCachePolicy,
    // timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func setSettingWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    let getNews:Int = parameters.object(forKey: "sendnewsletter") as! Int
    postData.append("&sendnewsletter=\(getNews)".data(using: String.Encoding.utf8)!)
    
    let infoEmail:Int = parameters.object(forKey: "sendtripinfobyemail") as! Int
    postData.append("&sendtripinfobyemail=\(infoEmail)".data(using: String.Encoding.utf8)!)
    
    let infoSMS:Int = parameters.object(forKey: "sendtripinfobysms") as! Int
    postData.append("&sendtripinfobysms=\(infoSMS)".data(using: String.Encoding.utf8)!)
    
    let turnoverEmail:Int = parameters.object(forKey: "sendtransactionbyemail") as! Int
    postData.append("&sendtransactionbyemail=\(turnoverEmail)".data(using: String.Encoding.utf8)!)
    
    let turnoverSMS:Int = parameters.object(forKey: "sendtransactionbysms") as! Int
    postData.append("&sendtransactionbysms=\(turnoverSMS)".data(using: String.Encoding.utf8)!)
    
    postData.append("&language=\(parameters.object(forKey: "language")!)" .data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func getPriceWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    
    let headers = Headers
    
    let parameters = params!
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    let origlatitude:Double = parameters.object(forKey: "origlatitude") as! Double
    postData.append("&origlatitude=\(origlatitude)".data(using: String.Encoding.utf8)!)
    
    let origlongitude:Double = parameters.object(forKey: "origlongitude") as! Double
    postData.append("&origlongitude=\(origlongitude)".data(using: String.Encoding.utf8)!)
    
    let destlatitude:Double = parameters.object(forKey: "destlatitude") as! Double
    postData.append("&destlatitude=\(destlatitude)".data(using: String.Encoding.utf8)!)
    
    let destlongitude:Double = parameters.object(forKey: "destlongitude") as! Double
    postData.append("&destlongitude=\(destlongitude)".data(using: String.Encoding.utf8)!)
    
    let hasreturn:Int = parameters.object(forKey: "hasreturn") as! Int
    postData.append("&hasreturn=\(hasreturn)".data(using: String.Encoding.utf8)!)
    
    //postData.append("&discountcode=\(parameters.object(forKey: "discountcode")!)".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    //NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //  cachePolicy: .useProtocolCachePolicy,
    // timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func getFavouritAddressListWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()){
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    print(parameters)
    print("HEADERS:\(headers)")
    
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    let page: Int = parameters.object(forKey: "page") as! Int
    postData.append("&page=\(page)".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                //print(object.object(forKey: "msg") as Any)
                print (object.object(forKey: "data") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func updateFavouriteAddressWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    let parameters = params!
    let manager = AFHTTPSessionManager()
    manager.requestSerializer.setValue("fa", forHTTPHeaderField: "accept-language")
    manager.requestSerializer.setValue(appid, forHTTPHeaderField: "appid")
    manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "accept")
    manager.requestSerializer.setValue(time, forHTTPHeaderField: "time")
    manager.requestSerializer.setValue(hash, forHTTPHeaderField: "hash")
    manager.requestSerializer.setValue(getUUID(), forHTTPHeaderField: "imei")
    manager.requestSerializer.setValue("no-cache", forHTTPHeaderField: "cache-control")
    manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
    manager.requestSerializer.setValue("ios", forHTTPHeaderField: "os")
    manager.requestSerializer.setValue("1", forHTTPHeaderField: "subscribertype")
    manager.requestSerializer.setValue("ir.vasl.peykyab", forHTTPHeaderField: "packagename")
    manager.requestSerializer.setValue("988f5bdd-a665-495a-5f6d-21a6cab634c7", forHTTPHeaderField: "postman-token")
    
    manager.post("\(baseURL)\(apiName)", parameters: parameters, progress: nil, success: { (URLSessionDataTask, responseObject:Any) in
        print(responseObject as! NSDictionary)
        completionHandler(responseObject as? NSDictionary, nil)
        }, failure: { (data:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            completionHandler(nil, error as NSError)
    })
}

func deleteFavouriteAddressWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    print(parameters)
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    let addressID: Int = parameters.object(forKey: "addressid") as! Int
    postData.append("&addressid=\(addressID)".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                //print(object.object(forKey: "msg") as Any)
                print (object.object(forKey: "data") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func setFavouriteAddressWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    let parameters = params!
    let manager = AFHTTPSessionManager()
    manager.requestSerializer.setValue("fa", forHTTPHeaderField: "accept-language")
    manager.requestSerializer.setValue(appid, forHTTPHeaderField: "appid")
    manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "accept")
    manager.requestSerializer.setValue(time, forHTTPHeaderField: "time")
    manager.requestSerializer.setValue(hash, forHTTPHeaderField: "hash")
    manager.requestSerializer.setValue(getUUID(), forHTTPHeaderField: "imei")
    manager.requestSerializer.setValue("no-cache", forHTTPHeaderField: "cache-control")
    manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
    manager.requestSerializer.setValue("ios", forHTTPHeaderField: "os")
    manager.requestSerializer.setValue("1", forHTTPHeaderField: "subscribertype")
    manager.requestSerializer.setValue("ir.vasl.peykyab", forHTTPHeaderField: "packagename")
    manager.requestSerializer.setValue("988f5bdd-a665-495a-5f6d-21a6cab634c7", forHTTPHeaderField: "postman-token")
    
    manager.post("\(baseURL)\(apiName)", parameters: parameters, progress: nil, success: { (URLSessionDataTask, responseObject:Any) in
        print(responseObject as! NSDictionary)
        completionHandler(responseObject as? NSDictionary, nil)
        }, failure: { (data:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            completionHandler(nil, error as NSError)
    })
}

func getTransactionsListWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    let postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    //NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //  cachePolicy: .useProtocolCachePolicy,
    // timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func shaparakWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    print(parameters)
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    let paymentType: Int = parameters.object(forKey: "paymenttype") as! Int
    postData.append("&paymenttype=\(paymentType)".data(using: String.Encoding.utf8)!)
    
    let chargeAmount: Int = parameters.object(forKey: "chargeamount") as! Int
    postData.append("&chargeamount=\(chargeAmount)".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                //print(object.object(forKey: "msg") as Any)
                print (object.object(forKey: "data") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func setChargeCardWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    postData.append("&chargecardcode=\(parameters.object(forKey: "chargecardcode")!)".data(using: String.Encoding.utf8)!)
    
    //let chargeCardCodeString:String? = parameters.object(forKey: "chargecardcode") as? String
    //postData.append("&chargecardcode=\(chargeCardCodeString!)".data(using: .unicode)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    //NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //  cachePolicy: .useProtocolCachePolicy,
    // timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func getCreditWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    let postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    //NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //  cachePolicy: .useProtocolCachePolicy,
    // timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func requestTripWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    let parameters = params!
    let manager = AFHTTPSessionManager()
    manager.requestSerializer.setValue("fa", forHTTPHeaderField: "accept-language")
    manager.requestSerializer.setValue(appid, forHTTPHeaderField: "appid")
    manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "accept")
    manager.requestSerializer.setValue(time, forHTTPHeaderField: "time")
    manager.requestSerializer.setValue(hash, forHTTPHeaderField: "hash")
    manager.requestSerializer.setValue(getUUID(), forHTTPHeaderField: "imei")
    manager.requestSerializer.setValue("no-cache", forHTTPHeaderField: "cache-control")
    manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
    manager.requestSerializer.setValue("ios", forHTTPHeaderField: "os")
    manager.requestSerializer.setValue("1", forHTTPHeaderField: "subscribertype")
    manager.requestSerializer.setValue("ir.vasl.peykyab", forHTTPHeaderField: "packagename")
    manager.requestSerializer.setValue("988f5bdd-a665-495a-5f6d-21a6cab634c7", forHTTPHeaderField: "postman-token")
    
    manager.post("\(baseURL)\(apiName)", parameters: parameters, progress: nil, success: { (URLSessionDataTask, responseObject:Any) in
        print(responseObject as! NSDictionary)
        completionHandler(responseObject as? NSDictionary, nil)
        }, failure: { (data:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            completionHandler(nil, error as NSError)
    })

    /*
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    postData.append("&origlatitude=\(parameters.object(forKey: "origlatitude")!)".data(using: String.Encoding.utf8)!)
    postData.append("&origlongitude=\(parameters.object(forKey: "origlongitude")!)".data(using: String.Encoding.utf8)!)
    postData.append("&origlocalname=\(parameters.object(forKey: "origlocalname")!)".data(using: String.Encoding.utf8)!)
    postData.append("&destlatitude=\(parameters.object(forKey: "destlatitude")!)".data(using: String.Encoding.utf8)!)
    postData.append("&destlongitude=\(parameters.object(forKey: "destlongitude")!)".data(using: String.Encoding.utf8)!)
    postData.append("&destlocalname=\(parameters.object(forKey: "destlocalname")!)".data(using: String.Encoding.utf8)!)
    postData.append("&hasreturn=\(parameters.object(forKey: "hasreturn")!)".data(using: String.Encoding.utf8)!)
    postData.append("&discountcode=\(parameters.object(forKey: "discountcode")!)".data(using: String.Encoding.utf8)!)
    postData.append("&totalprice=\(parameters.object(forKey: "totalprice")!)".data(using: String.Encoding.utf8)!)
    postData.append("&recieverinfotype=\(parameters.object(forKey: "recieverinfotype")!)".data(using: String.Encoding.utf8)!)
    postData.append("&recievername=\(parameters.object(forKey: "recievername")!)".data(using: String.Encoding.utf8)!)
    postData.append("&recievernumber=\(parameters.object(forKey: "recievernumber")!)".data(using: String.Encoding.utf8)!)
    postData.append("&recieveraddress=\(parameters.object(forKey: "recieveraddress")!)".data(using: String.Encoding.utf8)!)
    postData.append("&paymenttype=\(parameters.object(forKey: "paymenttype")!)".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
 */
}

func cancelTripWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    //postData.append("&tripid=\(parameters.object(forKey: "tripid")!)".data(using: String.Encoding.utf8)!)
    
    let tripID:Int = parameters.object(forKey: "tripid") as! Int
    postData.append("&tripid=\(tripID)".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func getMessageListWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    postData.append("&page=\(parameters.object(forKey: "page")!)".data(using: String.Encoding.utf8)!)
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    //NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //  cachePolicy: .useProtocolCachePolicy,
    // timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func setSubscriberMobileWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    postData.append("&mobile=\(parameters.object(forKey: "mobile")!)".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    
    //    let request = NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //                                      cachePolicy: .useProtocolCachePolicy,
    //                                      timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError? )
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}
func verifySubscriberMobileWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    postData.append("&verifycode=\(parameters.object(forKey: "verifycode")!)".data(using: String.Encoding.utf8)!)
    print (postData)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    
    //    let request = NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //                                      cachePolicy: .useProtocolCachePolicy,
    //                                      timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError? )
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func resendVerificationCodeWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "username=\(parameters.object(forKey: "username")!)".data(using: String.Encoding.utf8)!) as Data
    postData.append("&mobile=\(parameters.object(forKey: "mobile")!)".data(using: String.Encoding.utf8)!)
    
    let activateType:Int = parameters.object(forKey: "activate_type") as! Int
    postData.append("&activate_type=\(activateType)".data(using: String.Encoding.utf8)!)
    
    postData.append("&type=\(parameters.object(forKey: "type"))".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    //NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //  cachePolicy: .useProtocolCachePolicy,
    // timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func getMessageToDriverTemplateWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    let page: Int = parameters.object(forKey: "page") as! Int
    postData.append("&page=\(page)".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    //NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //  cachePolicy: .useProtocolCachePolicy,
    // timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func sendMessageToDriverWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    
    let parameters = params!
    let manager = AFHTTPSessionManager()
    manager.requestSerializer.setValue("fa", forHTTPHeaderField: "accept-language")
    manager.requestSerializer.setValue(appid, forHTTPHeaderField: "appid")
    manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "accept")
    manager.requestSerializer.setValue(time, forHTTPHeaderField: "time")
    manager.requestSerializer.setValue(hash, forHTTPHeaderField: "hash")
    manager.requestSerializer.setValue(getUUID(), forHTTPHeaderField: "imei")
    manager.requestSerializer.setValue("no-cache", forHTTPHeaderField: "cache-control")
    manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
    manager.requestSerializer.setValue("ios", forHTTPHeaderField: "os")
    manager.requestSerializer.setValue("1", forHTTPHeaderField: "subscribertype")
    manager.requestSerializer.setValue("ir.vasl.peykyab", forHTTPHeaderField: "packagename")
    manager.requestSerializer.setValue("988f5bdd-a665-495a-5f6d-21a6cab634c7", forHTTPHeaderField: "postman-token")
    
    manager.post("\(baseURL)\(apiName)", parameters: parameters, progress: nil, success: { (URLSessionDataTask, responseObject:Any) in
        print(responseObject as! NSDictionary)
        completionHandler(responseObject as? NSDictionary, nil)
        }, failure: { (data:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            completionHandler(nil, error as NSError)
    })

//    
//    //    let uuid = NSUUID().UUIDString
//    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
//    //    let time = String(getCurrentMillis())
//    //    let salt = "asia-peykyab-1"
//    let headers = Headers
//    let parameters = params!
//    
//    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
//    postData.append("&messagetext=\(parameters.object(forKey: "messagetext")!)".data(using: String.Encoding.utf8)!)
//    
//    let tripID:Int = parameters.object(forKey: "tripid") as! Int
//    postData.append("&tripid=\(tripID)".data(using: String.Encoding.utf8)!)
//    
//    let messageID:Int = parameters.object(forKey: "messageid") as! Int
//    postData.append("&messageid=\(messageID)".data(using: String.Encoding.utf8)!)
//    
//    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
//                             cachePolicy: .useProtocolCachePolicy,
//                             timeoutInterval: 60.0)
//    //NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
//    //  cachePolicy: .useProtocolCachePolicy,
//    // timeoutInterval: 60.0)
//    request.httpMethod = "POST"
//    request.allHTTPHeaderFields = headers
//    request.httpBody = postData
//    
//    let session = URLSession.shared
//    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
//        if (error != nil) {
//            print(error as Any)
//        } else {
//            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
//                print("error")
//                completionHandler(nil, error as NSError?)
//                return
//            }
//            
//            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print(dataString as Any)
//            
//            do {
//                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
//                // use anyObj here
//                let object = anyObj as NSDictionary
//                print(object.object(forKey: "msg") as Any)
//                completionHandler(anyObj as NSDictionary, nil)
//            } catch let error as NSError {
//                print("json error: \(error.localizedDescription)")
//                completionHandler(nil, error)
//            }
//        }
//    })
//    
//    dataTask.resume()
}

func getTripCostInfoWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    let tripID:Int = parameters.object(forKey: "tripid") as! Int
    postData.append("&tripid=\(tripID)".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    //NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //  cachePolicy: .useProtocolCachePolicy,
    // timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func getTripDriverInfoWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    let tripID:Int = parameters.object(forKey: "tripid") as! Int
    postData.append("&tripid=\(tripID)".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    //NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //  cachePolicy: .useProtocolCachePolicy,
    // timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}


func setTripRateWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    let parameters = params!
    let manager = AFHTTPSessionManager()
    manager.requestSerializer.setValue("fa", forHTTPHeaderField: "accept-language")
    manager.requestSerializer.setValue(appid, forHTTPHeaderField: "appid")
    manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "accept")
    manager.requestSerializer.setValue(time, forHTTPHeaderField: "time")
    manager.requestSerializer.setValue(hash, forHTTPHeaderField: "hash")
    manager.requestSerializer.setValue(getUUID(), forHTTPHeaderField: "imei")
    manager.requestSerializer.setValue("no-cache", forHTTPHeaderField: "cache-control")
    manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
    manager.requestSerializer.setValue("ios", forHTTPHeaderField: "os")
    manager.requestSerializer.setValue("1", forHTTPHeaderField: "subscribertype")
    manager.requestSerializer.setValue("ir.vasl.peykyab", forHTTPHeaderField: "packagename")
    manager.requestSerializer.setValue("988f5bdd-a665-495a-5f6d-21a6cab634c7", forHTTPHeaderField: "postman-token")
    
    manager.post("\(baseURL)\(apiName)", parameters: parameters, progress: nil, success: { (URLSessionDataTask, responseObject:Any) in
        print(responseObject as! NSDictionary)
        completionHandler(responseObject as? NSDictionary, nil)
        }, failure: { (data:URLSessionDataTask?, error:Error) in
            print(error.localizedDescription)
            completionHandler(nil, error as NSError)
    })
}

func getUnsatisfiedMessagelistWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    let postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    //NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //  cachePolicy: .useProtocolCachePolicy,
    // timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func getLastInProgressTripWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    let postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    //NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //  cachePolicy: .useProtocolCachePolicy,
    // timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func getTripInfoWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    let tripID:Int = parameters.object(forKey: "tripid") as! Int
    postData.append("&tripid=\(tripID)".data(using: String.Encoding.utf8)!)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    //NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //  cachePolicy: .useProtocolCachePolicy,
    // timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func getAppConfigWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    let postData = NSData(data: "sessionid=\(parameters.object(forKey: "sessionid")!)".data(using: String.Encoding.utf8)!) as Data
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    //NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //  cachePolicy: .useProtocolCachePolicy,
    // timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError?)
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func GoogleLoginWithCallBack(apiName: String, params:NSDictionary?, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
    
    //    let uuid = NSUUID().UUIDString
    //    let appid = "ab44219d-6f48-11e6-b325-005056a96c03"
    //    let time = String(getCurrentMillis())
    //    let salt = "asia-peykyab-1"
    let headers = Headers
    let parameters = params!
    
    var postData = NSData(data: "id=\(parameters.object(forKey: "id")!)".data(using: String.Encoding.utf8)!) as Data
    postData.append("&idToken=\(parameters.object(forKey: "idToken")!)".data(using: String.Encoding.utf8)!)
    print (postData)
    
    var request = URLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
                             cachePolicy: .useProtocolCachePolicy,
                             timeoutInterval: 60.0)
    
    //    let request = NSMutableURLRequest(url: URL(string: "\(baseURL)\(apiName)")!,
    //                                      cachePolicy: .useProtocolCachePolicy,
    //                                      timeoutInterval: 60.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = postData
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            print(error as Any)
        } else {
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                completionHandler(nil, error as NSError? )
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(dataString as Any)
            
            do {
                let anyObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                // use anyObj here
                let object = anyObj as NSDictionary
                print(object.object(forKey: "msg") as Any)
                completionHandler(anyObj as NSDictionary, nil)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                completionHandler(nil, error)
            }
        }
    })
    
    dataTask.resume()
}

func getCurrentInMillis()->Int64{
    return  Int64(Date().timeIntervalSince1970 * 1000)
}
//hash = md5(appid+time+imei+salt)
func generateHash(appid:String, time:String, imei:String, salt:String) -> String {
    let myString:String = appid+"_"+time+"_"+imei+"_"+salt
    print(md5(string: myString))
    return md5(string: myString)
}
func md5(string: String) -> String {
    var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
    if let data = string.data(using: String.Encoding.utf8) {
        CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
    }
    
    var digestHex = ""
    for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
        digestHex += String(format: "%02x", digest[index])
    }
    return digestHex
}
