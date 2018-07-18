//
//  ImageUtility.swift
//  iTunesSearch
//
//  Created by Mehmet Çakır on 17.07.2018.
//  Copyright © 2018 Mehmet Çakır. All rights reserved.
//

import UIKit

class ImageUtility {
    let imageCache:NSCache<NSString, NSData> = NSCache<NSString, NSData>()
    let kCacheCount:Int = 300
    
    static let sharedInstance:ImageUtility = {
        let instance = ImageUtility()
        instance.imageCache.countLimit = instance.kCacheCount
        return instance
    }()
    
    func clearCache() {
        ImageUtility.sharedInstance.imageCache.removeAllObjects()
    }
}

extension UIImageView {
    func loadImage(fromUrl:String?) {
        DispatchQueue.main.async {
            self.image = UIImage(named: "imagePlaceholderSmall")            
        }
        DispatchQueue.global().async {
            guard let url = URL(string: fromUrl ?? "") else { return }
            if let cachedImageData =  ImageUtility.sharedInstance.imageCache.object(forKey: url.absoluteString as NSString){
                DispatchQueue.main.async {
                    self.image = UIImage(data: cachedImageData as Data)
                }
                #if targetEnvironment(simulator)
                print("cached image")
                #endif
            } else {
                #if targetEnvironment(simulator)
                print("url image")
                #endif
                if let imageData = try? Data(contentsOf: url) {
                    ImageUtility.sharedInstance.imageCache.setObject(imageData as NSData, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async {
                        self.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
