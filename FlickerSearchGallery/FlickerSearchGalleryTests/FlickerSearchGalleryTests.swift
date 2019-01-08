//
//  FlickerSearchGalleryTests.swift
//  FlickerSearchGalleryTests
//
//  Created by Mahesh Sonaiya on 06/01/19.
//  Copyright © 2019 Mahesh Sonaiya. All rights reserved.
//

import XCTest
@testable import FlickrSearchGallery

class FlickerSearchGalleryTests: XCTestCase {

    var viewController: FlickrGalleryViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        viewController = navigationController.topViewController as? FlickrGalleryViewController
        
        UIApplication.shared.keyWindow!.rootViewController = navigationController
        
        XCTAssertNotNil(navigationController.view)
        XCTAssertNotNil(viewController.view)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            viewController.viewModel.searchImagesFromFlicr(search: nil, isFirstTime: true, with: { (FlickrGalleryResponse) in
                self.stopMeasuring()
            }, with: { (errorRespose) in
                self.stopMeasuring()
            })
        }
    }
    
    func testUICollectionViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(viewController.collectionView)
    }
    
    func testViewModelShouldNotNilAfterViewDidLoad() {
        XCTAssertNotNil(viewController.viewModel)
    }
    
    func testUISearchbarIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(viewController.searchBar)
    }
    
    func testLoadingViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(viewController.loadingView)
    }
    
    func testLoadingIndicatorViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(viewController.loadingIndicatorView)
    }
    
    func testShouldSetCollectionViewDataSource() {
        XCTAssertNotNil(viewController.collectionView.dataSource)
    }
    
    func testClassConformsToCollectionViewDataSource() {
        XCTAssert(viewController.conforms(to: UICollectionViewDataSource.self))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.collectionView(_:cellForItemAt:))))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.collectionView(_:numberOfItemsInSection:))))
    }
    
    func testClassConformsToSearchViewDelegate() {
        XCTAssert(viewController.conforms(to: UISearchBarDelegate.self))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.searchBarTextDidBeginEditing(_:))))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.searchBarTextDidEndEditing(_:))))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.searchBarSearchButtonClicked(_:))))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.searchBarCancelButtonClicked(_:))))
        XCTAssertTrue(viewController.responds(to: #selector(viewController.searchBar(_:textDidChange:))))
    }
    
    func testShouldSetCollectionViewDelegate() {
        XCTAssertNotNil(viewController.collectionView.delegate)
    }
    
    func testCollectionViewCellsIsDisplayedWithMatchingImage() {
        // Hit API Call and Reloaded Collection
        viewController.viewModel.searchImagesFromFlicr(search: nil, isFirstTime: true, with: { [weak self] (flickrGalleryResponse) in
            XCTAssertNotNil(flickrGalleryResponse, "API Response should not be nil")
            
            DispatchQueue.main.async {
                self?.viewController?.collectionView.reloadData()
                RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.5))
                
                //Check cells count with data
                let cells = self?.viewController.collectionView.visibleCells as! [FlickrImageCollectionViewCell]
                XCTAssertNotNil(self?.viewController.viewModel.flickrGalleryResponse)
                XCTAssertEqual(cells.count, self?.viewController.viewModel.flickrGalleryResponse?.photo.count, "Cells count should match array.count")
            }
        }) { (errorResponse) in
            XCTAssertNil(errorResponse.errorMessage)
        }
    }

}
