//
//  ViewController.swift
//  FlickerSearchGallery
//
//  Created by Mahesh Sonaiya on 06/01/19.
//  Copyright © 2019 Mahesh Sonaiya. All rights reserved.
//

import UIKit

class FlickrGalleryViewController: UIViewController {
    // MARK: - Properties
    let viewModel = FlickrSearchViewModel() // Declared as open as used in Testing
    fileprivate let cellIdentifier = "FlickrImageCellIdentifier"
    fileprivate let flickrImageCollectionViewCell = "FlickrImageCollectionViewCell"
    fileprivate let collectionMargin = CGFloat(10)
    fileprivate var searchActive : Bool = false
    fileprivate var searchText : String = "kittens"
    fileprivate var isDataLoading = false

    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var bottomRefreshLoaderView: UIView!
    @IBOutlet weak var bottomRefreshLoadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var sectionFooterHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        setup()
        makeAPICall(searchText: searchText, isFirstTime: true)
    }

    // MARK: - View Setup
    func setup() {
        let layout = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout)
        layout.itemSize.width = (UIScreen.main.bounds.width - collectionMargin * 2)/3
        layout.itemSize.height = (UIScreen.main.bounds.width - collectionMargin * 2)/3
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        
        collectionView.register(UINib.init(nibName: flickrImageCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        searchBar.delegate = self
        searchBar.text = searchText
        
        loadingView.layer.cornerRadius = 10
        loadingView.layer.masksToBounds = true
    }

    // MARK: - API Call for Search Operation
    func makeAPICall(searchText : String?, isFirstTime : Bool) {
        if isFirstTime {
            viewModel.pageNo = 1
            viewModel.flickrGalleryResponse = nil
            viewModel.hasMoreItems = false
            showOrHideLoadingIndicator(showView: true)
        } else {
            viewModel.pageNo = viewModel.pageNo + 1
        }
        
        viewModel.searchImagesFromFlicr(search: searchText, isFirstTime: isFirstTime, with: { [weak self] (flickrGalleryResponse) in
            
            DispatchQueue.main.async {
                self?.showOrHideLoadingIndicator(showView: false)
                self?.collectionView.reloadData()
                if isFirstTime {
                    if let photos = self?.viewModel.flickrGalleryResponse?.photo, photos.count > 0 {
                        self?.collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 0), at: UICollectionView.ScrollPosition.top, animated: true)
                    } else {
                        self?.displayAlertMessage(errorMessage: "No Results found!")
                    }
                } else {
                    self?.manageFooterView(showFooterView: false)
                }
            }
        }) { [weak self] (errorResponse) in
            self?.showOrHideLoadingIndicator(showView: false)
            self?.displayAlertMessage(errorMessage: errorResponse.errorMessage)
        }
    }
    
    // MARK: - Show or Hide Loading View
    func showOrHideLoadingIndicator(showView : Bool) {
        loadingView.isHidden = !showView
        showView == true ? loadingIndicatorView.startAnimating() : loadingIndicatorView.stopAnimating()
    }
}

// MARK: - UICollectionViewDataSource and UICollectionViewDelegate Methods
extension FlickrGalleryViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.flickrGalleryResponse?.photo.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,for: indexPath) as! FlickrImageCollectionViewCell
        
        // Configure the cell
        if let imageObject = viewModel.flickrGalleryResponse?.photo[indexPath.row] {
            cell.setUpCell(media: imageObject)
        }
        
        return cell
    }
}

// MARK: - UISearchBarDelegate Methods
extension FlickrGalleryViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchText.count > 2 {
            searchBar.endEditing(true)
            makeAPICall(searchText: searchText, isFirstTime: true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
    
    
}

//MARK: Pagination
extension FlickrGalleryViewController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((collectionView.contentOffset.y + collectionView.frame.size.height) >= collectionView.contentSize.height)
        {
            if !isDataLoading && (viewModel.hasMoreItems) {
                isDataLoading = true
                manageFooterView(showFooterView: true)
                makeAPICall(searchText: searchText, isFirstTime: false)
            }
        }
    }
    
    func manageFooterView(showFooterView : Bool) {
        if showFooterView {
            sectionFooterHeightConstraint.constant = 66
            bottomRefreshLoaderView.isHidden = false
            bottomRefreshLoadingIndicatorView.startAnimating()
        } else {
            sectionFooterHeightConstraint.constant = 0
            bottomRefreshLoaderView.isHidden = true
            bottomRefreshLoadingIndicatorView.stopAnimating()
        }
    }
}

extension FlickrGalleryViewController {
    func displayAlertMessage(errorMessage : String) {
        DispatchQueue.main.async {
            let alertViewController = UIAlertController(title: "Gallery", message: errorMessage , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alertViewController.addAction(okAction)
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
}
