//
//  PhImageView.swift
//  Photo
//
//  Created by Guillermo Diaz on 8/17/22.
//

import UIKit

extension UIImageView {
    public func imageFromServerURL(urlString: String?) {
        
        guard let urlString = urlString else {
            image = #imageLiteral(resourceName: "NotFound")
            return
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil { return }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }).resume()
    }
}
