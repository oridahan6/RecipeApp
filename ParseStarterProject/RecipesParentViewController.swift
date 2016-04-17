//
//  RecipesParentViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 13/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class RecipesParentViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    var searchButton: UIBarButtonItem!
    var searchController: UISearchController!

    var filteredRecipes = [Recipe]()
    var shouldShowSearchResults = false
    
    var emptySearchLabel: UILabel?
    
    var recipes = [Recipe]() {
        didSet {
            self.recipesUpdated()
        }
    }
    
    //--------------------------------------
    // MARK: - Init Methods
    //--------------------------------------
    
    func recipesUpdated() {
        // override this method!!
        print("do not forget to override recipesUpdated if needed!!!!!")
    }
    
    //--------------------------------------
    // MARK: - Life Cycle Methods
    //--------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create Search Button
        self.searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(FavoritesViewController.showSearchBar(_:)))
        navigationItem.rightBarButtonItem = self.searchButton

        configureSearchController()
        
        self.definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--------------------------------------
    // MARK: - Helpers Methods
    //--------------------------------------

    func showSearchBar(sender: UIBarButtonItem) {
        self.navigationItem.setHidesBackButton(true, animated: true)
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
        searchController.searchBar.showsCancelButton = true
        
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

        searchController.searchBar.sizeToFit()
    }
    
    func getRecipeBasedOnSearch(index: Int) -> Recipe {
        if isShowSearchResults() {
            return filteredRecipes[index]
        }
        return recipes[index]
    }
    
    func handleIfEmptySearch() {
        if searchController.searchBar.text?.isEmpty == false && filteredRecipes.count == 0 {
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
            self.emptySearchLabel!.font = UIFont(name: "Alef-Regular", size: 20)
            self.emptySearchLabel!.sizeToFit()
            self.emptySearchLabel!.tag = 45
        }
        if let searchString = searchController.searchBar.text {
            self.emptySearchLabel!.text = String.localizedStringWithFormat(NSLocalizedString("emptySearchRecipes", comment: ""), searchString)
        }
        self.tableView.backgroundView = emptySearchLabel
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func isShowSearchResults() -> Bool {
        if searchController.searchBar.text?.isEmpty == true {
            return false
        }
        return shouldShowSearchResults
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
        self.navigationItem.setHidesBackButton(false, animated: true)
        
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
            filteredRecipes = recipes.filter({ (recipe) -> Bool in
                let recipeTitle: NSString = recipe.title
                
                return (recipeTitle.rangeOfString(searchString, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
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
