//
//  Results.swift
//  iTunesSearch
//
//  Created by Mehmet Çakır on 15.07.2018.
//  Copyright © 2018 Mehmet Çakır. All rights reserved.
//

import Foundation

public class ResultItem:JSONSerializable {
    let kind:String?
    let artistId:Int?
    let collectionId:Int?
    let trackId:Int?
    let artistName:String?
    let collectionName:String?
    let trackName:String?
    let artistViewUrl:String?
    let primaryGenreName:String?
    let releaseDate:String?
    let trackCount:Int?
    let longDescription:String?
    let collectionViewUrl:String?
    let contentAdvisoryRating:String?
    let artworkUrl30:String?
    let artworkUrl60:String?
    let artworkUrl100:String?
    var isReaded:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case kind = "kind"
        case artistId = "artistId"
        case collectionId = "collectionId"
        case trackId = "trackId"
        case artistName = "artistName"
        case primaryGenreName = "primaryGenreName"
        case releaseDate = "releaseDate"
        case trackCount = "trackCount"
        case longDescription = "longDescription"
        case collectionName = "collectionName"
        case trackName = "trackName"
        case artistViewUrl = "artistViewUrl"
        case collectionViewUrl = "collectionViewUrl"
        case contentAdvisoryRating = "contentAdvisoryRating"
        case artworkUrl30 = "artworkUrl30"
        case artworkUrl60 = "artworkUrl60"
        case artworkUrl100 = "artworkUrl100"
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        kind = try values.decodeIfPresent(String.self, forKey: .kind)
        artistId = try values.decodeIfPresent(Int.self, forKey: .artistId)
        collectionId = try values.decodeIfPresent(Int.self, forKey: .collectionId)
        trackId = try values.decodeIfPresent(Int.self, forKey: .trackId)
        artistName = try values.decodeIfPresent(String.self, forKey: .artistName)
        primaryGenreName = try values.decodeIfPresent(String.self, forKey: .primaryGenreName)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        trackCount = try values.decodeIfPresent(Int.self, forKey: .trackCount)
        longDescription = try values.decodeIfPresent(String.self, forKey: .longDescription)
        collectionName = try values.decodeIfPresent(String.self, forKey: .collectionName)
        trackName = try values.decodeIfPresent(String.self, forKey: .trackName)
        artistViewUrl = try values.decodeIfPresent(String.self, forKey: .artistViewUrl)
        collectionViewUrl = try values.decodeIfPresent(String.self, forKey: .collectionViewUrl)
        contentAdvisoryRating = try values.decodeIfPresent(String.self, forKey: .contentAdvisoryRating)
        artworkUrl30 = try values.decodeIfPresent(String.self, forKey: .artworkUrl30)
        artworkUrl60 = try values.decodeIfPresent(String.self, forKey: .artworkUrl60)
        artworkUrl100 = try values.decodeIfPresent(String.self, forKey: .artworkUrl100)
    }
    
    func getListItemNameText() -> String? {
        if let kind = self.kind {
            return kind.contains("movie") ? self.trackName : self.collectionName
        }
        return nil
    }        
}
