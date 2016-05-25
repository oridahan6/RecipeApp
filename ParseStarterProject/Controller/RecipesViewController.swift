//
//  RecipesViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 27/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class RecipesViewController: RecipesParentViewController {

    let CellIdentifier = "RecipeTableViewCell"
    let SegueRecipeViewController = "RecipeViewController"
    let SegueAddRecipeViewController = "AddRecipeViewController"
    
    var category: Category?
    
    var addButton: UIBarButtonItem!
    var updatedAt: NSDate!
    
    override func recipesUpdated() {
        self.tableView.reloadData()
    }

    //--------------------------------------
    // MARK: - Life Cycle Methods
    //--------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Helpers.sharedInstance.isInternetConnectionAvailable() {
            self.showAlert()
        } else {
            if let category = self.category {
                self.title = category.name
            } else {
                self.title = getLocalizedString("Recipes")
            }
            self.loadRecipes()
        }
        
        self.addPullToRefresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if category == nil {
            self.handleAddButton()
        }
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
        }
        return recipes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! RecipeTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    //--------------------------------------
    // MARK: - Table View Delegate
    //--------------------------------------

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let currentCell = cell as! RecipeTableViewCell
        let recipe = self.getRecipeBasedOnSearch(indexPath.row)
        
        let recipeDetailsView = currentCell.recipeDetailsView
        recipeDetailsView.recipe = recipe
        
        recipeDetailsView.setNeedsDisplay()

        var imageUrl = ""
        if recipe.imageName != "" {
            imageUrl = Constants.GDRecipesImagesPath + recipe.imageName
        } else if let recipeFile = recipe.imageFile {
            imageUrl = recipeFile.getUrl()
        }
        // update image async
        KingfisherHelper.sharedInstance.setImageWithUrl(currentCell.recipeImageView, url: imageUrl)
    }
    
    //--------------------------------------
    // MARK: - Helpers Methods
    //--------------------------------------
    
    func loadRecipes(fromPullToRefresh: Bool = false) {
        if !fromPullToRefresh {
            self.beginUpdateView()
        }
        if let category = self.category {
            ParseHelper.sharedInstance.updateRecipesFromCategoryId(self, catId: category.catId)
        } else {
            ParseHelper.sharedInstance.updateRecipes(self)
        }
    }
    
    func showAddRecipeView(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier(SegueAddRecipeViewController, sender: nil)
    }
    
    func handleAddButton() {
        // Create add recipe button
        if let user = ParseHelper.currentUser() {
            let parseUser = ParseUser(user: user)
            if parseUser.isAdmin() {
                if self.addButton == nil {
                    self.addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(RecipesViewController.showAddRecipeView(_:)))
                }
                navigationItem.leftBarButtonItem = self.addButton
            }
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    func addPullToRefresh() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = tableView.backgroundColor!
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            
            self?.loadRecipes(true)
            
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
    
    private func showAlert() {
        SCLAlertViewHelper.sharedInstance.showErrorAlert("noInternetConnection")
    }
    
    //--------------------------------------
    // MARK: - deinit
    //--------------------------------------

    deinit {
        tableView.dg_removePullToRefresh()
    }
}
