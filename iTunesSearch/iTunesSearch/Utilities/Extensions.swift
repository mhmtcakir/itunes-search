//
//  Extensions.swift
//  iTunesSearch
//
//  Created by Mehmet Çakır on 17.07.2018.
//  Copyright © 2018 Mehmet Çakır. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(fromUrlString urlStr:String?) {
        guard let url = URL(string: urlStr ?? "") else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self , comment: "")
    }
}

