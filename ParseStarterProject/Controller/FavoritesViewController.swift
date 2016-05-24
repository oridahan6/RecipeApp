//
//  FavoritesViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 27/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class FavoritesViewController: RecipesParentViewController, SwiftPromptsProtocol {

    let CellIdentifier = "FavoriteRecipeTableViewCell"
    let SegueRecipeViewController = "RecipeViewController"

    var editButton: UIBarButtonItem!
    
    var emptyMessageLabel: UILabel?
    
    var recipeRemoved = false
    var prompt = SwiftPromptsView()
    var activityIndicator: ActivityIndicator!
    
    override func recipesUpdated() {
        if !self.recipeRemoved {
            tableView.reloadData()
        }
        self.recipeRemoved = false
    }
    
    //--------------------------------------
    // MARK: - Life Cycle Methods
    //--------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.title = getLocalizedString("Favorites")
        
        // Create Edit Button
        self.editButton = UIBarButtonItem(title: getLocalizedString("edit"), style: .Plain, target: self, action: #selector(FavoritesViewController.editItems(_:)))
        navigationItem.leftBarButtonItem = self.editButton

        // Activity Indicator
        self.activityIndicator = ActivityIndicator(largeActivityView: self.view)
        
        // Hack for placing the hud in the correct place
        Helpers.sharedInstance.hackForPlacingHUD(self.activityIndicator.HUD)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if !Helpers.sharedInstance.isInternetConnectionAvailable() {
            self.buildAlert()
            self.showAlert()
        } else {
            self.reloadFavorites()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.recipes.count == 0 {
            self.endUpdateView()
        }
    }
    
    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------

    func reloadFavorites() {
        if let favoriteIds = NSUserDefaults.standardUserDefaults().arrayForKey("favorites") as? [String] {
            ParseHelper.sharedInstance.updateFavoriteRecipes(self, ids: favoriteIds)
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
            self.emptyMessageLabel!.font = Helpers.sharedInstance.getTextFont(20)
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
        if self.recipes.count == 0 {
            self.addEmptyFavoritesLabel()
        }
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
    // MARK: - Table view data source
    //--------------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = nil
        if isShowSearchResults() {
            self.handleIfEmptySearch()
            return filteredRecipes.count
        } else if self.recipes.count > 0 {
            return recipes.count
        }
        return 0;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! FavoriteRecipeTableViewCell
        
        let recipe = self.getRecipeBasedOnSearch(indexPath.row)
        
        let recipeDetailsView = cell.recipeDetailsView
        recipeDetailsView.recipe = recipe
        recipeDetailsView.isShowDate = false
        recipeDetailsView.setNeedsDisplay()

        if recipe.imageName != "" {
            // update image async
            let imageUrlString = Constants.GDRecipesImagesPath + recipe.imageName
            KingfisherHelper.sharedInstance.setImageWithUrl(cell.recipeImageView, url: imageUrlString)
        } else if let recipeFile = recipe.imageFile {
            let fileUrl = recipeFile.getUrl()
            KingfisherHelper.sharedInstance.setImageWithUrl(cell.recipeImageView, url: fileUrl)
        }
        
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
            if self.recipes.count == 0 {
                self.addEmptyFavoritesLabel()
            }
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
                let recipe = self.getRecipeBasedOnSearch(indexPath.row)
                let destinationViewController = segue.destinationViewController as! RecipeViewController
                destinationViewController.recipe = recipe
            }
        }
    }
    
    //--------------------------------------
    // MARK: - UISearchBarDelegate methods
    //--------------------------------------
    
    override func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        super.searchBarCancelButtonClicked(searchBar)
        self.navigationItem.leftBarButtonItem = self.editButton
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
