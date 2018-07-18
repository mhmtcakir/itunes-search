//
//  Constants.swift
//  iTunesSearch
//
//  Created by Mehmet Çakır on 15.07.2018.
//  Copyright © 2018 Mehmet Çakır. All rights reserved.
//

import Foundation

class Constant: NSObject {
    
    struct URLs {
        static let kResultLimit:Int = 100
        static let kBaseURL: String = "https://itunes.apple.com/"
        static let kSearchURL: String = kBaseURL+"search?term=%@&limit=\(kResultLimit)&media=%@&country=tr"
    }
    
    struct Menus {
        static let kSearchTypeMenuItems = ["All":"all", "Music":"music", "Movie":"movie", "Podcast":"podcast"]
    }
}
