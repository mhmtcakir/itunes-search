//
//  UserDefaultsHelper.swift
//  iTunesSearch
//
//  Created by Mehmet Çakır on 15.07.2018.
//  Copyright © 2018 Mehmet Çakır. All rights reserved.
//

import Foundation

class UserDefaultsHelper {        
    var deletedTrackList:[Int]?
    var readedTrackList:[Int]?
    
    static let sharedInstance: UserDefaultsHelper = {
        let instance = UserDefaultsHelper()
        return instance
    }()
    
    public func getStoredTrackList(withKey key:StoredType) -> [Int] {
        var trackList:[Int] = []
        if let storedListData = UserDefaults.standard.object(forKey: key.rawValue) {
            if let decodedArrayData = NSKeyedUnarchiver.unarchiveObject(with: storedListData as! Data) as? [Int] {
                trackList = decodedArrayData
            }
        }
        return trackList
    }
    
    public func saveItem(trackId:Int, withKey key:StoredType){
        let encodedData:Data?
        
        if key == .Readed {
            if readedTrackList == nil {
                readedTrackList = getStoredTrackList(withKey: key)
            }
            readedTrackList!.append(trackId)
            encodedData = NSKeyedArchiver.archivedData(withRootObject: readedTrackList!)
        }
        else {
            if deletedTrackList == nil {
                deletedTrackList = getStoredTrackList(withKey: key)
            }
            deletedTrackList!.append(trackId)
            encodedData = NSKeyedArchiver.archivedData(withRootObject: deletedTrackList!)
        }
        
        UserDefaults.standard.set(encodedData, forKey: key.rawValue)
    }
}
