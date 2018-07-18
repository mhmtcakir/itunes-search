//
//  Response.swift
//  iTunesSearch
//
//  Created by Mehmet Çakır on 15.07.2018.
//  Copyright © 2018 Mehmet Çakır. All rights reserved.
//

import Foundation

public class Response:JSONSerializable {
    let errorMessage:String?
    let resultCount:Int?
    let results:[ResultItem]?
    
    enum CodingKeys: String, CodingKey {
        case errorMessage = "errorMessage"
        case resultCount = "resultCount"
        case results = "results"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        errorMessage = try values.decodeIfPresent(String.self, forKey: .errorMessage)
        resultCount = try values.decodeIfPresent(Int.self, forKey: .resultCount)
        results = try values.decodeIfPresent([ResultItem].self, forKey: .results)
    }
}
