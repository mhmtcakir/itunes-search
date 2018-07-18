//
//  DetailViewController.swift
//  iTunesSearch
//
//  Created by Mehmet Çakır on 18.07.2018.
//  Copyright © 2018 Mehmet Çakır. All rights reserved.
//

import UIKit

protocol DetailViewDelegate {
    func removeItemFromList(atIndex index:Int?)
}

class DetailViewController:UIViewController {
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var subInfo1Label: UILabel!
    @IBOutlet weak var subInfo2Label: UILabel!
    @IBOutlet weak var subInfo3Label: UILabel!
    @IBOutlet weak var navBarDeleteButton: UIBarButtonItem!
    
    var deleteDelegate:DetailViewDelegate?
    var searchItem:ResultItem?
    var selectedItemIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let detailData = searchItem {
            itemImageView.loadImage(fromUrl: detailData.artworkUrl100)
            trackNameLabel.text = searchItem?.getListItemNameText() ?? ""
            collectionNameLabel.text = detailData.artistName ?? ""
            subInfo1Label.text = detailData.primaryGenreName ?? ""
            subInfo2Label.text =  getSubInfo2()
            subInfo3Label.text = String(format: "Release: %@", DateTimeUtils.sharedInstance.dateStringToFormattedString(dateString: detailData.releaseDate))
        }
        else {
            navBarDeleteButton.isEnabled = false
            contentScrollView.isHidden = true
            showPopupMessage(titleText: "Error".localized(), messageText: "DetailDataNotFound".localized())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func getSubInfo2() -> String {
        var subInfo2 = ""
        if let kind = searchItem!.kind {
            if kind.contains("movie") {
                subInfo2 = searchItem?.contentAdvisoryRating ?? ""
            } else if (kind.contains("song")) {
                subInfo2 = String(format: "%i Track", searchItem!.trackCount ?? 1)
            } else if (kind.contains("podcast")) {
                subInfo2 = "Podcasts"
            }
        }
        return subInfo2
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "SearchItemDeleteAlertMessage".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "AlertViewDeleteButtonTitle".localized(), style: .destructive, handler:{ action in
            DispatchQueue.main.async {
                self.deleteDelegate?.removeItemFromList(atIndex: self.selectedItemIndex)
                self.navigationController?.popViewController(animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "AlertViewCancelButtonTitle".localized(), style: .cancel, handler:nil))
        self.present(alert, animated: true)
    }
    
    func showPopupMessage(titleText:String?, messageText:String?) {
        let alert = UIAlertController(title: titleText ?? "", message: messageText ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "AlertViewCloseButtonTitle".localized(), style: .default, handler:{ action in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true)
    }
}
