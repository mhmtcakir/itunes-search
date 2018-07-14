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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if let layout = searchCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.invalidateLayout()
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchCollectionViewCell
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

