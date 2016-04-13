//
//  RecipesViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 27/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Kingfisher

class RecipesViewController: UITableViewController, SwiftPromptsProtocol, UISearchResultsUpdating, UISearchBarDelegate {

    let CellIdentifier = "RecipeTableViewCell"
    let SegueRecipeViewController = "RecipeViewController"
    
    var searchButton: UIBarButtonItem!
    
    var catId: Int?
    var prompt = SwiftPromptsView()
    var activityIndicator: ActivityIndicator!
    
    var searchController: UISearchController!
    
    var filteredRecipes = [Recipe]()
    var shouldShowSearchResults = false
    
    var recipes = [Recipe]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: getLocalizedString("Recipes"), image: UIImage.fontAwesomeIconWithName(FontAwesome.Cutlery, textColor: UIColor.grayColor(), size: CGSizeMake(30, 30)), tag: 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = getLocalizedString("Recipes")
        
        if !Helpers.isInternetConnectionAvailable() {
            self.buildAlert()
            self.showAlert()
        } else {
            // Activity Indicator
            self.activityIndicator = ActivityIndicator(largeActivityView: self.view)
            
            if let categoryId = self.catId {
                ParseHelper().updateRecipesFromCategoryId(self, catId: categoryId)
            } else {
                ParseHelper().updateRecipes(self)
            }
        }
        
        // Create Search Button
        self.searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(FavoritesViewController.showSearchBar(_:)))
        navigationItem.rightBarButtonItem = self.searchButton

        configureSearchController()
        
        // Register Class
        // tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--------------------------------------
    // MARK: - Navigation
    //--------------------------------------

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueRecipeViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                var recipe: Recipe!
                
                if shouldShowSearchResults {
                    recipe = filteredRecipes[indexPath.row]
                } else {
                    recipe = recipes[indexPath.row]
                }
                
                let destinationViewController = segue.destinationViewController as! RecipeViewController
                destinationViewController.recipe = recipe
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
        if shouldShowSearchResults {
            return filteredRecipes.count
        } else {
            return recipes.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! RecipeTableViewCell

        var recipe: Recipe!
        
        if shouldShowSearchResults {
            recipe = filteredRecipes[indexPath.row]
        } else {
            recipe = recipes[indexPath.row]
        }

        cell.recipeDetailsView.titleLabel.text = recipe.title
        cell.recipeDetailsView.typeLabel.text = recipe.type
        cell.recipeDetailsView.levelLabel.text = recipe.level
        cell.recipeDetailsView.overallTimeLabel.text = recipe.getOverallPreperationTimeText()
        cell.recipeDetailsView.dateAddedLabel.text = recipe.getDateAddedDiff()
        
        cell.recipeDetailsView.typeImageView.image = recipe.getTypeImage()
        
        // update image async
        let imageUrlString = Constants.GDRecipesImagesPath + recipe.imageName
        KingfisherHelper.sharedInstance.setImageWithUrl(cell.recipeImageView, url: imageUrlString)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    //--------------------------------------
    // MARK: - Helpers Methods
    //--------------------------------------
    
    func showSearchBar(sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem = nil
        
        self.navigationItem.titleView = searchController.searchBar
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
        searchController.searchBar.sizeToFit()
    }

    private func buildAlert() {
        //Create an instance of SwiftPromptsView and assign its delegate
        prompt = SwiftPromptHelper.getSwiftPromptView(self.view.bounds)
        prompt.delegate = self
        
        SwiftPromptHelper.buildErrorAlert(prompt)
        
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

}
