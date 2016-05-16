//
//  RecipesViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 27/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Kingfisher

class RecipesViewController: RecipesParentViewController, SwiftPromptsProtocol {

    let CellIdentifier = "RecipeTableViewCell"
    let SegueRecipeViewController = "RecipeViewController"
    let SegueAddRecipeViewController = "AddRecipeViewController"
    
    var category: Category?
    var prompt = SwiftPromptsView()
    var activityIndicator: ActivityIndicator!
    
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
        
        if !Helpers.isInternetConnectionAvailable() {
            self.buildAlert()
            self.showAlert()
        } else {
            // Activity Indicator
            self.activityIndicator = ActivityIndicator(largeActivityView: self.view)

            // Hack for placing the hud in the correct place
            Helpers.hackForPlacingHUD(self.activityIndicator.HUD)
            
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

        let recipe = self.getRecipeBasedOnSearch(indexPath.row)
        
        cell.recipeDetailsView.titleLabel.text = recipe.title
        cell.recipeDetailsView.typeLabel.text = recipe.type
        cell.recipeDetailsView.levelLabel.text = recipe.level
        cell.recipeDetailsView.overallTimeLabel.text = recipe.getOverallPreperationTimeText()
        cell.recipeDetailsView.dateAddedLabel.text = recipe.getUpdatedAtDiff()
        
        cell.recipeDetailsView.typeImageView.image = recipe.getTypeImage()
        
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
        self.activityIndicator.show()
    }
    
    func endUpdateView() {
        self.activityIndicator.hide()
        self.tableView.dg_stopLoading()
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
    // MARK: - deinit
    //--------------------------------------

    deinit {
        tableView.dg_removePullToRefresh()
    }
}
