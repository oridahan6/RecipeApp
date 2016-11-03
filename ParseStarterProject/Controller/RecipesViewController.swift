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
    var updatedAt: Date!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        if category == nil {
            self.handleAddButton()
        }
    }
    
    //--------------------------------------
    // MARK: - Navigation
    //--------------------------------------

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueRecipeViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let recipe = self.getRecipeBasedOnSearch(indexPath.row)
                let destinationViewController = segue.destination as! RecipeViewController
                destinationViewController.recipe = recipe
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
            return filteredRecipes.count
        }
        return recipes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! RecipeTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    //--------------------------------------
    // MARK: - Table View Delegate
    //--------------------------------------

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let currentCell = cell as! RecipeTableViewCell
        let recipe = self.getRecipeBasedOnSearch(indexPath.row)
        
        let recipeDetailsView = currentCell.recipeDetailsView
        recipeDetailsView.recipe = recipe
        
        recipeDetailsView?.setNeedsDisplay()

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
    
    func loadRecipes(_ fromPullToRefresh: Bool = false) {
        if !fromPullToRefresh {
            self.beginUpdateView()
        }
        if let category = self.category {
            ParseHelper.sharedInstance.updateRecipesFromCategoryId(self, catId: category.catId)
        } else {
            ParseHelper.sharedInstance.updateRecipes(self)
        }
    }
    
    func showAddRecipeView(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: SegueAddRecipeViewController, sender: nil)
    }
    
    func handleAddButton() {
        // Create add recipe button
        if let user = ParseHelper.currentUser() {
            let parseUser = ParseUser(user: user)
            if parseUser.isAdmin() {
                if self.addButton == nil {
                    self.addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(RecipesViewController.showAddRecipeView(_:)))
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
    
    fileprivate func showAlert() {
        SCLAlertViewHelper.sharedInstance.showErrorAlert("noInternetConnection")
    }
    
    //--------------------------------------
    // MARK: - deinit
    //--------------------------------------

    deinit {
        tableView.dg_removePullToRefresh()
    }
}
