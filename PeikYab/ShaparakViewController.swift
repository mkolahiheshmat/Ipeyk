//
//  ShaparakViewController.swift
//  PeikYab
//
//  Created by Developer on 10/9/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
import UIKit

class ShaparakViewController:BaseViewController,UIWebViewDelegate{
    
    //MARK: - Variables
    var webView:UIWebView!
    var webViewURL:String!
    
    //MARK: -  view DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTopbar(NSLocalizedString("onlinePayment", comment: ""))
        backButton.addTarget(self, action: #selector(ShaparakViewController.backAction), for: .touchUpInside)
        
        self.view.isUserInteractionEnabled = true
        
        print("webViewURL= ",webViewURL)
        
        //Shaparak Web View
        webView = UIWebView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight - 64))
        //webView.loadRequest(NSURLRequest(url: NSURL(string: webViewURL)! as URL) as URLRequest)
        webView.delegate = self
        //self.view.addSubview(webView)
        
        let url = NSURL (string: webViewURL);
        let request = NSURLRequest(url: url! as URL);
        webView.loadRequest(request as URLRequest);
        self.view.addSubview(webView)
    }
    //    func webView(webView: UIWebView!, didFailLoadWithError error: NSError!) {
    //        print("Webview fail with error \(error)");
    //    }
    ////    func webView(webView: UIWebView!, shouldStartLoadWithRequest request: NSURLRequest!, navigationType: UIWebViewNavigationType) -&gt; Bool {
    ////    return true;
    ////    }
    //    func webViewDidStartLoad(webView: UIWebView!) {
    //        print("Webview started Loading")
    //    }
    //    func webViewDidFinishLoad(_ webView: UIWebView!) {
    //        print("Webview did finish load")
    //    }
    
    //MARK: -  custom Methods
    func backAction(){
        // _ = self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}
