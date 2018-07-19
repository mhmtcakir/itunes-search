//
//  AlertUtility.swift
//  iTunesSearch
//
//  Created by Mehmet Çakır on 19.07.2018.
//  Copyright © 2018 Mehmet Çakır. All rights reserved.
//

import UIKit

class AlertUtility {
    var infoAlert:UIAlertController? = nil
    
    static let sharedInstance:AlertUtility = {
        let instance = AlertUtility()
        instance.infoAlert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        instance.infoAlert?.addAction(UIAlertAction(title: "AlertViewCloseButtonTitle".localized(), style: .default, handler: nil))
        return instance
    }()
    
    func getInfoAlert(title:String?, message:String) -> UIAlertController {
        guard let alertController = infoAlert else {
            return AlertUtility.sharedInstance.infoAlert!
        }
        infoAlert?.title = title
        infoAlert?.message = message
        return alertController
    }
}
