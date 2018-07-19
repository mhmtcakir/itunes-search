//
//  MainViewController.swift
//  iTunesSearch
//
//  Created by Mehmet Çakır on 14.07.2018.
//  Copyright © 2018 Mehmet Çakır. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,SearchDataServiceDelegate,DetailViewDelegate {
    @IBOutlet weak var navBarRightButtonItem: UIBarButtonItem!
    @IBOutlet weak var noSearchResultView: UIStackView!
    @IBOutlet weak var noSearchResultLabel: UILabel!
    @IBOutlet weak var searchPlaceholderLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var dataService: SearchDataService?
    var searchResult:[ResultItem] = []
    var itemToDelete:IndexPath?
    
    let kCollectionSectionInset:CGFloat = 16.0
    let kCollectionCellHeight:CGFloat = 66.0
    let kLandscapeNumberOfCellPerRow:CGFloat = 2.0
    let kMinSearchTextCount:Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataService = SearchDataService(dataServiceDelegate: self)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !searchResult.isEmpty {
            guard let deleteItem = itemToDelete else {
                prepareSearchDataListView(checkDeletedList: false)
                return
            }
            
            deleteListItem(itemIndex: deleteItem)
            prepareSearchDataListView(checkDeletedList: true)
        }
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
    
    // MARK: - Prepare Data -
    func prepareSearchDataListView(checkDeletedList getDeleted:Bool) {
        
        if !searchResult.isEmpty {
            let readedData = UserDefaultsHelper.sharedInstance.getStoredTrackList(withKey: .Readed)
            if getDeleted {
                let deletedData = UserDefaultsHelper.sharedInstance.getStoredTrackList(withKey: .Deleted)
                searchResult = searchResult.map{$0}.filter{!deletedData.contains($0.trackId!)}
            }
            
            searchResult.filter{readedData.contains($0.trackId!)}.forEach{$0.isReaded = true}
        } else if let searchText = searchBar.text, searchText.count > kMinSearchTextCount {
            activityIndicator.stopAnimating()
            noSearchResultLabel.text = String(format: "NoSearchResult".localized(), searchText)
            noSearchResultView.isHidden = false
        } else {
            searchPlaceholderLabel.isHidden = false
        }
        
        searchCollectionView.reloadData()
    }
    
    // MARK: - Keyboard Show/Hide Notification Observers
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardSize = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        searchCollectionView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        searchCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    // MARK: - Button Actions -
    @IBAction func navigationBarSearchTypeButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "AlertPopupSearchTypeTitle".localized(), message: "AlertPopupSearchTypeDescription".localized(), preferredStyle: .actionSheet)
        for item in Constant.Menus.kSearchTypeMenuItems.keys.sorted() {
            alert.addAction(UIAlertAction(title: item, style: .default, handler:alertButtonsAction))
        }
        
        alert.addAction(UIAlertAction(title: "AlertViewCancelButtonTitle".localized(), style: .destructive, handler:nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func alertButtonsAction(alertAction: UIAlertAction) {
        navBarRightButtonItem.title = alertAction.title
        
        if let searchText = searchBar.text, searchText.count > kMinSearchTextCount {
            sendSearchRequest(searchBar.text!)
        }
    }
    
    func deleteListItem(itemIndex:IndexPath) {
        searchCollectionView.performBatchUpdates({ () -> Void in
            if let deletedTrackId = self.searchResult[itemIndex.row].trackId {
                UserDefaultsHelper.sharedInstance.saveItem(trackId: deletedTrackId, withKey: .Deleted)
            }
            
            searchResult.remove(at: itemIndex.row)
            searchCollectionView.deleteItems(at: [itemIndex])
        }, completion:{ completed in
            self.itemToDelete = nil
        })
    }
    
    // MARK: - SearchDataServiceDelegate -
    func searchRetrieved(response:Response?, withErrorMessage error:String?) {
        guard let _ = response?.results else {
            var errorMessage:String = "GenericSearchErrorMessage".localized()
            if let errMsg = response?.errorMessage {
                errorMessage = errMsg
            }
    
            self.present(AlertUtility.sharedInstance.getInfoAlert(title: nil, message: errorMessage), animated: true)
            self.searchResult = []
            prepareSearchDataListView(checkDeletedList: true)
            return
        }
        
        searchCollectionView.isHidden = false
        self.searchResult = response!.results ?? []
        prepareSearchDataListView(checkDeletedList: true)
        activityIndicator.stopAnimating()
    }
    
    public func sendSearchRequest(_ searchText:String) {
        clearSearchResultData()
        searchCollectionView.isHidden = true
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        self.perform(#selector(getSearchData(_:)), with: searchText, afterDelay: 0.6)
    }
    
    @objc private func getSearchData(_ searchText:String?) {
        searchPlaceholderLabel.isHidden = true
        noSearchResultView.isHidden = true
        activityIndicator.startAnimating()
        dataService?.searchData(withText: searchText ?? "", andDataType: Constant.Menus.kSearchTypeMenuItems[navBarRightButtonItem.title!] ?? "")
    }
    
    private func clearSearchResultData() {
        dataService?.cancelRunningTaskIfExist()
        if searchResult.count > 0 {
            searchResult.removeAll()
        }
    }
    
    // MARK: - DetailViewControllerDelegate -
    func removeItemFromList(atIndex index: Int?) {
        guard let deletedIndex = index else {
            return
        }
        
        itemToDelete = IndexPath(item: deletedIndex, section: 0)
    }
}

// MARK: - UICollectionView Delegates
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCollectionViewCell
        let item:ResultItem = searchResult[indexPath.row]
        cell.nameLabel.text = item.getListItemNameText() ?? ""            
        cell.infoLabel.text = item.artistName ?? ""
        cell.itemImageView.loadImage(fromUrl: item.artworkUrl60)
        cell.setReaded(readed: item.isReaded)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.orientation.isLandscape == true {
            return CGSize(width: (self.view.frame.size.width-((kLandscapeNumberOfCellPerRow+1)*kCollectionSectionInset))/kLandscapeNumberOfCellPerRow, height: kCollectionCellHeight)
        } else {
            return CGSize(width: self.view.frame.size.width-(2*kCollectionSectionInset), height: kCollectionCellHeight)
        }
    }    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedItemIndex:Int = sender as! Int
        
        if let trackId = searchResult[selectedItemIndex].trackId {
            UserDefaultsHelper.sharedInstance.saveItem(trackId: trackId, withKey: .Readed)
        }
        
        let viewController:DetailViewController = segue.destination as! DetailViewController
        viewController.deleteDelegate = self
        viewController.selectedItemIndex = selectedItemIndex
        viewController.searchItem = self.searchResult[selectedItemIndex]
    }
}

// MARK: - UICollectionView Delegates -
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchPlaceholderLabel.isHidden = true
        noSearchResultView.isHidden = true
        
        if searchText.count > kMinSearchTextCount {
            sendSearchRequest(searchText)
        } else {
            clearSearchResultData()
            self.activityIndicator.stopAnimating()
            prepareSearchDataListView(checkDeletedList: true)
            searchCollectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text, searchText.count == 2 {
            sendSearchRequest(searchBar.text!)
        }
    }
}
