//
//  CategoriesViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 27/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class CategoriesViewController: UITableViewController, SwiftPromptsProtocol, UISearchResultsUpdating, UISearchBarDelegate {
    
    let CellIdentifier = "CategoryTableViewCell"
    let SegueRecipesViewController = "RecipesViewController"
    
    var prompt = SwiftPromptsView()
    var activityIndicator: ActivityIndicator!
    
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
    
    //--------------------------------------
    // MARK: - Life Cycle Methods
    //--------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = getLocalizedString("Categories")
        
        if !Helpers.sharedInstance.isInternetConnectionAvailable() {
            self.buildAlert()
            self.showAlert()
        } else {
            // Activity Indicator
            self.activityIndicator = ActivityIndicator(largeActivityView: self.view)
            
            // Hack for placing the hud in the correct place
            Helpers.sharedInstance.hackForPlacingHUD(self.activityIndicator.HUD)
            
            ParseHelper.sharedInstance.updateCategories(self)
        }
        
        // Create Search Button
        self.searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(FavoritesViewController.showSearchBar(_:)))
        navigationItem.rightBarButtonItem = self.searchButton
        
        configureSearchController()
        
        self.addPullToRefresh()
        
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //--------------------------------------
    // MARK: - Navigation
    //--------------------------------------

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueRecipesViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let category = self.getCategoryBasedOnSearch(indexPath.row)
                let destinationViewController = segue.destinationViewController as! RecipesViewController
                destinationViewController.category = category
                searchController.searchBar.resignFirstResponder()
                self.definesPresentationContext = false
            }
        }
    }

    //--------------------------------------
    // MARK: - Table view data source
    //--------------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = nil
        if isShowSearchResults() {
            self.handleIfEmptySearch()
            return filteredCategories.count
        }
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! CategoryTableViewCell

        let category = self.getCategoryBasedOnSearch(indexPath.row)

        cell.categoryNameLabel.text = category.name
        cell.recipesCountLabel.text = Helpers.sharedInstance.getSingularOrPluralForm(category.recipesCount, textToConvert: "recipe")
        
        // update image async
        let imageUrlString = Constants.GDCategoriesImagesPath + category.imageName
        KingfisherHelper.sharedInstance.setImageWithUrl(cell.categoryImage, url: imageUrlString)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        return cell
    }

    //--------------------------------------
    // MARK: - Helpers Methods
    //--------------------------------------

    func loadCategories(fromPullToRefresh: Bool = false) {
        if !fromPullToRefresh {
            self.beginUpdateView()
        }
        ParseHelper.sharedInstance.updateCategories(self)
    }

    func showSearchBar(sender: UIBarButtonItem) {
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
                if view2.isKindOfClass(UITextField) {
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
            self.emptySearchLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            self.emptySearchLabel!.textColor = UIColor.blackColor()
            self.emptySearchLabel!.numberOfLines = 0
            self.emptySearchLabel!.textAlignment = NSTextAlignment.Center
            self.emptySearchLabel!.font = Helpers.sharedInstance.getTextFont(20)
            self.emptySearchLabel!.sizeToFit()
            self.emptySearchLabel!.tag = 45
        }
        if let searchString = searchController.searchBar.text {
            self.emptySearchLabel!.text = String.localizedStringWithFormat(NSLocalizedString("emptySearchCategories", comment: ""), searchString)
        }
        self.tableView.backgroundView = emptySearchLabel
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }

    func getCategoryBasedOnSearch(index: Int) -> Category {
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
        self.activityIndicator.show()
    }
    
    func endUpdateView() {
        self.activityIndicator.hide()
        self.tableView.dg_stopLoading()
    }

    private func isShowSearchResults() -> Bool {
        if searchController.searchBar.text?.isEmpty == true {
            return false
        }
        return shouldShowSearchResults
    }
    
    private func buildAlert() {
        //Create an instance of SwiftPromptsView and assign its delegate
        prompt = SwiftPromptHelper.getSwiftPromptView(self.view.bounds)
        prompt.delegate = self
        
        SwiftPromptHelper.buildErrorAlert(prompt, type: "noInternetConnection")
    }
    
    private func showAlert() {
        self.view.addSubview(prompt)
    }
    
    //--------------------------------------
    // MARK: - UISearchBarDelegate methods
    //--------------------------------------
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        self.navigationItem.rightBarButtonItem = self.searchButton
        
        self.navigationItem.titleView = nil
        searchController.searchBar.showsCancelButton = true
        
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    //--------------------------------------
    // MARK: - UISearchResultsUpdating methods
    //--------------------------------------
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchString = searchController.searchBar.text where searchString.isEmpty == false {
            
            shouldShowSearchResults = true
            
            // Filter the data array and get only those countries that match the search text.
            filteredCategories = categories.filter({ (category) -> Bool in
                let categoryName: NSString = category.name
                
                return (categoryName.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
            })
            
            // Reload the tableview.
            tableView.reloadData()
        } else {
            shouldShowSearchResults = false
            tableView.reloadData()
        }
    }
    
    //--------------------------------------
    // MARK: - SwiftPromptsProtocol delegate methods
    //--------------------------------------

    func clickedOnTheMainButton() {
        prompt.dismissPrompt()
    }
    
    func clickedOnTheSecondButton() {
        prompt.dismissPrompt()
    }
    
    func promptWasDismissed() {

    }

    //--------------------------------------
    // MARK: - UIScrollViewDelegate Methods
    //--------------------------------------

    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if searchController.searchBar.isFirstResponder() && (shouldShowSearchResults || searchController.active) {
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
