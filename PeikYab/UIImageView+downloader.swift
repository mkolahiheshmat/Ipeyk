//
//  ImageDownloader.swift
//  PeikYab
//
//  Created by Yarima on 12/14/16.
//  Copyright © 2016 Arash Z. Jahangiri. All rights reserved.
//

import Foundation
extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }).resume()
    }}
