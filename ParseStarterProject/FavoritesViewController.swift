//
//  FavoritesViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 27/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class FavoritesViewController: UITableViewController {

    let CellIdentifier = "FavoriteRecipeTableViewCell"
    let SegueRecipeViewController = "RecipeViewController"

    var emptyMessageLabel: UILabel?
    
    var recipeRemoved = false
    var activityIndicator: ActivityIndicator!
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: getLocalizedString("edit"), style: .Plain, target: self, action: #selector(FavoritesViewController.editItems(_:)))
        
        // Activity Indicator
        self.activityIndicator = ActivityIndicator(largeActivityView: self.view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.reloadFavorites()
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
    
    //--------------------------------------
    // MARK: - Table view data source
    //--------------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.recipes.count > 0 {
            self.tableView.backgroundView = nil
            return recipes.count
        } else if !self.activityIndicator.isAnimating(){
            self.addEmptyFavoritesLabel()
        }
        return 0;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! FavoriteRecipeTableViewCell
        
        let recipe = recipes[indexPath.row]
        
        cell.recipeDetailsView.titleLabel.text = recipe.title
        cell.recipeDetailsView.typeLabel.text = recipe.type
        cell.recipeDetailsView.levelLabel.text = recipe.level
        cell.recipeDetailsView.overallTimeLabel.text = recipe.getOverallPreperationTimeText()
        
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
                let recipe = recipes[indexPath.row]
                let destinationViewController = segue.destinationViewController as! RecipeViewController
                destinationViewController.recipe = recipe
            }
        }
    }
    

}
