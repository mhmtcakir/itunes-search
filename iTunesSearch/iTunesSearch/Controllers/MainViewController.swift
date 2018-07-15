//
//  MainViewController.swift
//  iTunesSearch
//
//  Created by Mehmet Çakır on 14.07.2018.
//  Copyright © 2018 Mehmet Çakır. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var navBarRightButtonItem: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollectionView: UICollectionView!

    let kCollectionSectionInset:CGFloat = 16.0
    let kCollectionCellHeight:CGFloat = 76.0
    let kLandscapeNumberOfCellPerRow:CGFloat = 2.0
    
    var data = ["Label1","Label2","Label3","Label4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if let layout = searchCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.invalidateLayout()
        }
    }
    
    // MARK: - Keyboard Show/Hide Notification Observers
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        searchCollectionView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        searchCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    @IBAction func act(_ sender: Any) {
        deleteSearchResultItem(itemIndex: 0)
    }
    
    func deleteSearchResultItem(itemIndex:Int) {
        searchCollectionView.performBatchUpdates({ () -> Void in
            data.remove(at: itemIndex)
            searchCollectionView.deleteItems(at: [IndexPath(item: itemIndex, section: 0)])
        }, completion:nil)
    }
}

// MARK: - UICollectionView Delegates
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCollectionViewCell
        cell.nameLabel.text = data[indexPath.row]//String(format: "Label Name Desc %i", indexPath.row)
        cell.infoLabel.text = String(format: "info %i", indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape == true {
            return CGSize(width: (self.view.frame.size.width-((kLandscapeNumberOfCellPerRow+1)*kCollectionSectionInset))/kLandscapeNumberOfCellPerRow, height: kCollectionCellHeight)
        }
        else {
            return CGSize(width: self.view.frame.size.width-(2*kCollectionSectionInset), height: kCollectionCellHeight)
        }
    }
}

// MARK: - UICollectionView Delegates
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("search with text : \(searchText)")
        
    }
}

