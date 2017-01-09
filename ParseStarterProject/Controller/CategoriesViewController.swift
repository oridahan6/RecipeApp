//
//  CategoriesViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 27/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let CellIdentifier = "CategoryTableViewCell"
    let SegueRecipesViewController = "RecipesViewController"
    
    var searchButton: UIBarButtonItem!
    var searchController: UISearchController!
    
    var filteredCategories = [Category]()
    var shouldShowSearchResults = false
    
    var emptySearchLabel: UILabel?
    
    var categories = [Category]() {
        didSet {
            tableView.reloadData()
        }
    }
    var categoriesImages = [Int: CategoryImage]()
    
    //--------------------------------------
    // MARK: - Life Cycle Methods
    //--------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = getLocalizedString("Categories")
        
        if !Helpers.sharedInstance.isInternetConnectionAvailable() {
            self.showAlert()
        } else {
            ParseHelper.sharedInstance.updateCategories(self)
            ParseHelper.sharedInstance.updateCategoriesImages(self)
        }
        
        // Create Search Button
        self.searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(FavoritesViewController.showSearchBar(_:)))
        navigationItem.rightBarButtonItem = self.searchButton
        
        configureSearchController()
        
        self.addPullToRefresh()
        
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.definesPresentationContext = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--------------------------------------
    // MARK: - Navigation
    //--------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueRecipesViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let category = self.getCategoryBasedOnSearch(indexPath.row)
                let destinationViewController = segue.destination as! RecipesViewController
                destinationViewController.category = category
                searchController.searchBar.resignFirstResponder()
                self.definesPresentationContext = false
            }
        }
    }
    
    //--------------------------------------
    // MARK: - Table view data source
    //--------------------------------------
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = nil
        if isShowSearchResults() {
            self.handleIfEmptySearch()
            return filteredCategories.count
        }
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! CategoryTableViewCell
        
        let category = self.getCategoryBasedOnSearch(indexPath.row)
        
        cell.categoryNameLabel.text = category.name
        cell.recipesCountLabel.text = Helpers.sharedInstance.getSingularOrPluralForm(category.recipesCount, textToConvert: "recipe")
        
        cell.categoryImage.image = UIImage(named: "placeholder.jpg")
        
        // update image async
        if let categoryImage = self.categoriesImages[category.catId] {
            if let imageFile = categoryImage.imageFile {
                let imageUrl = imageFile.getUrl()
                KingfisherHelper.sharedInstance.setImageWithUrl(cell.categoryImage, url: imageUrl)
            }
        }

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    //--------------------------------------
    // MARK: - Helpers Methods
    //--------------------------------------
    
    func loadCategories(_ fromPullToRefresh: Bool = false) {
        if !fromPullToRefresh {
            self.beginUpdateView()
        }
        ParseHelper.sharedInstance.updateCategories(self)
    }
    
    func showSearchBar(_ sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        
        self.navigationItem.titleView = searchController.searchBar
        
        searchController.searchBar.becomeFirstResponder()
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = getLocalizedString("searchByName")
        searchController.searchBar.setValue(getLocalizedString("cancel"), forKey:"_cancelButtonText")
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        // enable search button even when empty search string
        var searchBarTextField: UITextField!
        for subview in searchController.searchBar.subviews {
            for view2 in subview.subviews {
                if view2.isKind(of: UITextField.self) {
                    searchBarTextField = view2 as! UITextField
                    break
                }
            }
        }
        if let txtField = searchBarTextField {
            txtField.enablesReturnKeyAutomatically = false;
        }
        
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.sizeToFit()
    }
    
    func handleIfEmptySearch() {
        if searchController.searchBar.text?.isEmpty == false && filteredCategories.count == 0 {
            self.addEmptySearchLabel()
        } else {
            self.tableView.backgroundView = nil
        }
    }
    
    func addEmptySearchLabel() {
        if (self.emptySearchLabel == nil) {
            self.emptySearchLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            self.emptySearchLabel!.textColor = UIColor.black
            self.emptySearchLabel!.numberOfLines = 0
            self.emptySearchLabel!.textAlignment = NSTextAlignment.center
            self.emptySearchLabel!.font = Helpers.sharedInstance.getTextFont(20)
            self.emptySearchLabel!.sizeToFit()
            self.emptySearchLabel!.tag = 45
        }
        if let searchString = searchController.searchBar.text {
            self.emptySearchLabel!.text = String.localizedStringWithFormat(NSLocalizedString("emptySearchCategories", comment: ""), searchString)
        }
        self.tableView.backgroundView = emptySearchLabel
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func getCategoryBasedOnSearch(_ index: Int) -> Category {
        if isShowSearchResults() {
            return filteredCategories[index]
        }
        return categories[index]
    }
    
    func addPullToRefresh() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = tableView.backgroundColor!
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            self?.loadCategories(true)
            
            // Do not forget to call dg_stopLoading() at the end
            }, loadingView: loadingView)
        if let navBarColor = navigationController?.navigationBar.barTintColor {
            tableView.dg_setPullToRefreshFillColor(navBarColor)
        }
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
    }
    
    func beginUpdateView() {
        SVProgressHUDHelper.sharedInstance.showLoadingHUD()
    }
    
    func endUpdateView() {
        SVProgressHUDHelper.sharedInstance.dissmisHUD()
        self.tableView.dg_stopLoading()
    }
    
    fileprivate func isShowSearchResults() -> Bool {
        if searchController.searchBar.text?.isEmpty == true {
            return false
        }
        return shouldShowSearchResults
    }
    
    fileprivate func showAlert() {
        SCLAlertViewHelper.sharedInstance.showErrorAlert("noInternetConnection")
    }
    
    //--------------------------------------
    // MARK: - UISearchBarDelegate methods
    //--------------------------------------
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.navigationItem.rightBarButtonItem = self.searchButton
        
        self.navigationItem.titleView = nil
        searchController.searchBar.showsCancelButton = true
        
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    //--------------------------------------
    // MARK: - UISearchResultsUpdating methods
    //--------------------------------------
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text, searchString.isEmpty == false {
            
            shouldShowSearchResults = true
            
            // Filter the data array and get only those countries that match the search text.
            filteredCategories = categories.filter({ (category) -> Bool in
                let categoryName: NSString = category.name as NSString
                
                return (categoryName.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
            })
            
            // Reload the tableview.
            tableView.reloadData()
        } else {
            shouldShowSearchResults = false
            tableView.reloadData()
        }
    }
    
    //--------------------------------------
    // MARK: - UIScrollViewDelegate Methods
    //--------------------------------------
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if searchController.searchBar.isFirstResponder && (shouldShowSearchResults || searchController.isActive) {
            searchController.searchBar.resignFirstResponder()
        }
    }
    
    //--------------------------------------
    // MARK: - deinitialization
    //--------------------------------------
    
    deinit {
        if let superView = searchController.view.superview
        {
            superView.removeFromSuperview()
        }
    }
}
