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
        self.searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(FavoritesViewController.showSearchBar(_:)))
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

    func showSearchBar(_ sender: UIBarButtonItem) {
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
                if view2.isKind(of: UITextField.self) {
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
    
    func getRecipeBasedOnSearch(_ index: Int) -> Recipe {
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
            self.emptySearchLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            self.emptySearchLabel!.textColor = UIColor.black
            self.emptySearchLabel!.numberOfLines = 0
            self.emptySearchLabel!.textAlignment = NSTextAlignment.center
            self.emptySearchLabel!.font = Helpers.sharedInstance.getTextFont(20)
            self.emptySearchLabel!.sizeToFit()
            self.emptySearchLabel!.tag = 45
        }
        if let searchString = searchController.searchBar.text {
            self.emptySearchLabel!.text = String.localizedStringWithFormat(NSLocalizedString("emptySearchRecipes", comment: ""), searchString)
        }
        self.tableView.backgroundView = emptySearchLabel
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
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
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.navigationItem.rightBarButtonItem = self.searchButton
        self.navigationItem.setHidesBackButton(false, animated: true)
        
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
            filteredRecipes = recipes.filter({ (recipe) -> Bool in
                let recipeTitle: NSString = recipe.title as NSString
                
                return (recipeTitle.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
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
