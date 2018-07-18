//
//  JSONSerializable.swift
//  iTunesSearch
//
//  Created by Mehmet Çakır on 15.07.2018.
//  Copyright © 2018 Mehmet Çakır. All rights reserved.
//

import Foundation

public protocol JSONSerializable:Codable {
    func serialize() -> Data?
}

extension JSONSerializable {
    
    public func serialize() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    public func toDict() -> [String:Any]? {
        if let encoded = self.serialize() {
            if let dict = try! JSONSerialization.jsonObject(with: encoded, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                return dict
            }
        }
        return nil
    }
}
