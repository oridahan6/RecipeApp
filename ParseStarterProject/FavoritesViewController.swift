//
//  FavoritesViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 27/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class FavoritesViewController: UITableViewController, SwiftPromptsProtocol, UISearchResultsUpdating, UISearchBarDelegate {

    let CellIdentifier = "FavoriteRecipeTableViewCell"
    let SegueRecipeViewController = "RecipeViewController"

    var searchButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    
    var emptyMessageLabel: UILabel?
    
    var recipeRemoved = false
    var prompt = SwiftPromptsView()
    var activityIndicator: ActivityIndicator!
    
    var searchController: UISearchController!
    
    var filteredRecipes = [Recipe]()
    var shouldShowSearchResults = false
    
    var recipeIds = [String]()
    var recipes = [Recipe]() {
        didSet {
            if !self.recipeRemoved {
                tableView.reloadData()
            }
            self.recipeRemoved = false
            self.updateRecipeIds()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: getLocalizedString("Favorites"), image: UIImage.fontAwesomeIconWithName(FontAwesome.Heart, textColor: UIColor.grayColor(), size: CGSizeMake(30, 30)), tag: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.title = getLocalizedString("Favorites")
        
        // Create Edit Button
        self.editButton = UIBarButtonItem(title: getLocalizedString("edit"), style: .Plain, target: self, action: #selector(FavoritesViewController.editItems(_:)))
        navigationItem.leftBarButtonItem = self.editButton

        // Create Search Button
        self.searchButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(FavoritesViewController.showSearchBar(_:)))
        navigationItem.rightBarButtonItem = self.searchButton

        // Activity Indicator
        self.activityIndicator = ActivityIndicator(largeActivityView: self.view)
        
        configureSearchController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if !Helpers.isInternetConnectionAvailable() {
            self.buildAlert()
            self.showAlert()
        } else {
            self.reloadFavorites()
        }
    }
    
    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------

    func reloadFavorites() {
        if let favoriteIds = NSUserDefaults.standardUserDefaults().arrayForKey("favorites") as? [String] {
            self.addToFavorites(favoriteIds)
            self.removeFromFavorites(favoriteIds)
        }
    }
    
    func addToFavorites(favoriteIds: [String]) {
        var recipeIdsToAdd = [String]()
        
        for id in favoriteIds {
            if !self.recipeIds.contains(id) {
                recipeIdsToAdd.append(id)
            }
        }
        if !recipeIdsToAdd.isEmpty {
            ParseHelper().updateFavoriteRecipes(self, ids: recipeIdsToAdd)
        }
        
    }
    
    func removeFromFavorites(favoriteIds: [String]) {
        for recipeId in recipeIds {
            if !favoriteIds.contains(recipeId) {
                recipeIds.removeObject(recipeId)
                for recipe in recipes {
                    if recipe.id == recipeId {
                        if let index = recipes.indexOf(recipe) {
                            recipes.removeAtIndex(index)
                        }
                    }
                }
            }
        }
    }

    func updateRecipeIds() {
        self.recipeIds = []
        for recipe in self.recipes {
            self.recipeIds.append(recipe.id)
        }
    }

    func editItems(sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.editing, animated: true)
        if tableView.editing {
            navigationItem.rightBarButtonItem?.title = getLocalizedString("done")
        } else {
            navigationItem.rightBarButtonItem?.title = getLocalizedString("edit")
        }
    }
    
    func addEmptyFavoritesLabel() {
        if (self.emptyMessageLabel == nil) {
            self.emptyMessageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            self.emptyMessageLabel!.text = getLocalizedString("emptyFavorites")
            self.emptyMessageLabel!.textColor = UIColor.blackColor()
            self.emptyMessageLabel!.numberOfLines = 0
            self.emptyMessageLabel!.textAlignment = NSTextAlignment.Center
            self.emptyMessageLabel!.font = UIFont(name: "Alef-Regular", size: 20)
            self.emptyMessageLabel!.sizeToFit()
            self.emptyMessageLabel!.tag = 45
        }
        self.tableView.backgroundView = emptyMessageLabel
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    func beginUpdateView() {
        self.tableView.backgroundView = nil
        self.activityIndicator.show()
    }
    
    func endUpdateView() {
        self.activityIndicator.hide()
    }
    
    func showSearchBar(sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        
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
    // MARK: - Table view data source
    //--------------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredRecipes.count
        } else if self.recipes.count > 0 {
            self.tableView.backgroundView = nil
            return recipes.count
        } else if !self.activityIndicator.isAnimating(){
            self.addEmptyFavoritesLabel()
        }
        return 0;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! FavoriteRecipeTableViewCell
        
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
        
        cell.recipeDetailsView.typeImageView.image = recipe.getTypeImage()
        
        // update image async
        let imageUrlString = Constants.GDRecipesImagesPath + recipe.imageName
        KingfisherHelper.sharedInstance.setImageWithUrl(cell.recipeImageView, url: imageUrlString)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            recipeRemoved = true
            if var favoriteIds = NSUserDefaults.standardUserDefaults().arrayForKey("favorites") as? [String] {
                let recipe = self.recipes[indexPath.row]
                favoriteIds.removeObject(recipe.id)
                NSUserDefaults.standardUserDefaults().setObject(favoriteIds, forKey: "favorites")
            }
            self.recipes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
    }
    
    //--------------------------------------
    // MARK: - Table view delegate
    //--------------------------------------

    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
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
        self.navigationItem.leftBarButtonItem = self.editButton
        
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
