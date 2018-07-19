//
//  SearchDataService.swift
//  iTunesSearch
//
//  Created by Mehmet Çakır on 15.07.2018.
//  Copyright © 2018 Mehmet Çakır. All rights reserved.
//

import Foundation

public protocol SearchDataServiceDelegate {
    func searchRetrieved(response:Response?, withErrorMessage error:String?)
}

class SearchDataService {
    var dataTask:URLSessionDataTask?
    var delegate:SearchDataServiceDelegate?
    
    init(dataServiceDelegate:SearchDataServiceDelegate) {
        self.delegate = dataServiceDelegate
    }
    
    func cancelRunningTaskIfExist() {
        if let previousTask = dataTask,previousTask.state != URLSessionTask.State.completed {
            previousTask.cancel()
        }
    }
    
    public func searchData(withText text:String, andDataType type:String) {
        #if targetEnvironment(simulator)
        print("search text:\(text) type:\(type)")
        #endif
        
        cancelRunningTaskIfExist()
        let searchText = text.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
        let urlString = String(format: Constant.URLs.kSearchURL, searchText, type).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: urlString ?? "") else {
            if let _ = self.delegate {
                DispatchQueue.main.async {
                    self.delegate!.searchRetrieved(response:nil, withErrorMessage: "GenericSearchErrorMessage".localized())
                }
            }
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                if let _ = self.delegate {
                    DispatchQueue.main.async {
                        self.delegate!.searchRetrieved(response:nil, withErrorMessage: "GenericSearchErrorMessage".localized())
                    }
                }
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let resultData = try JSONDecoder().decode(Response.self, from: data)
                DispatchQueue.main.async {
                    print(resultData)
                    if let _ = self.delegate {
                        self.delegate!.searchRetrieved(response: resultData, withErrorMessage: nil)
                    }
                }                
            } catch let jsonError {
                print(jsonError)
                DispatchQueue.main.async {
                    self.delegate!.searchRetrieved(response:nil, withErrorMessage: "GenericSearchErrorMessage".localized())
                }
            }
        }
        
        dataTask?.resume()
    }
}
