//
//  FavoritesViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 27/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class FavoritesViewController: RecipesParentViewController {

    let CellIdentifier = "FavoriteRecipeTableViewCell"
    let SegueRecipeViewController = "RecipeViewController"

    var editButton: UIBarButtonItem!
    
    var emptyMessageLabel: UILabel?
    
    var recipeRemoved = false
    
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
        self.editButton = UIBarButtonItem(title: getLocalizedString("edit"), style: .plain, target: self, action: #selector(FavoritesViewController.editItems(_:)))
        navigationItem.leftBarButtonItem = self.editButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !Helpers.sharedInstance.isInternetConnectionAvailable() {
            self.showAlert()
        } else {
            self.reloadFavorites()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.recipes.count == 0 {
            self.endUpdateView()
        }
    }
    
    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------

    func reloadFavorites() {
        if let favoriteIds = UserDefaults.standard.array(forKey: "favorites") as? [String] {
            ParseHelper.sharedInstance.updateFavoriteRecipes(self, ids: favoriteIds)
        }
    }

    func editItems(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            navigationItem.rightBarButtonItem?.title = getLocalizedString("done")
        } else {
            navigationItem.rightBarButtonItem?.title = getLocalizedString("edit")
        }
    }
    
    func addEmptyFavoritesLabel() {
        if (self.emptyMessageLabel == nil) {
            self.emptyMessageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            self.emptyMessageLabel!.text = getLocalizedString("emptyFavorites")
            self.emptyMessageLabel!.textColor = UIColor.black
            self.emptyMessageLabel!.numberOfLines = 0
            self.emptyMessageLabel!.textAlignment = NSTextAlignment.center
            self.emptyMessageLabel!.font = Helpers.sharedInstance.getTextFont(20)
            self.emptyMessageLabel!.sizeToFit()
            self.emptyMessageLabel!.tag = 45
        }
        self.tableView.backgroundView = emptyMessageLabel
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func beginUpdateView() {
        self.tableView.backgroundView = nil
        SVProgressHUDHelper.sharedInstance.showLoadingHUD()
    }
    
    func endUpdateView() {
        SVProgressHUDHelper.sharedInstance.dissmisHUD()
        if self.recipes.count == 0 {
            self.addEmptyFavoritesLabel()
        }
    }
    
    fileprivate func showAlert() {
        SCLAlertViewHelper.sharedInstance.showErrorAlert("noInternetConnection")
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
        } else if self.recipes.count > 0 {
            return recipes.count
        }
        return 0;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! FavoriteRecipeTableViewCell
        
        let recipe = self.getRecipeBasedOnSearch(indexPath.row)
        
        let recipeDetailsView = cell.recipeDetailsView
        recipeDetailsView.recipe = recipe
        recipeDetailsView?.isShowDate = false
        recipeDetailsView?.setNeedsDisplay()

        if recipe.imageName != "" {
            // update image async
            let imageUrlString = Constants.GDRecipesImagesPath + recipe.imageName
            KingfisherHelper.sharedInstance.setImageWithUrl(cell.recipeImageView, url: imageUrlString)
        } else if let recipeFile = recipe.imageFile {
            let fileUrl = recipeFile.getUrl()
            KingfisherHelper.sharedInstance.setImageWithUrl(cell.recipeImageView, url: fileUrl)
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            recipeRemoved = true
            if var favoriteIds = UserDefaults.standard.array(forKey: "favorites") as? [String] {
                let recipe = self.recipes[indexPath.row]
                favoriteIds.removeObject(recipe.id)
                UserDefaults.standard.set(favoriteIds, forKey: "favorites")
            }
            self.recipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            if self.recipes.count == 0 {
                self.addEmptyFavoritesLabel()
            }
        }
    }
    
    //--------------------------------------
    // MARK: - Table view delegate
    //--------------------------------------

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
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
    // MARK: - UISearchBarDelegate methods
    //--------------------------------------
    
    override func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        super.searchBarCancelButtonClicked(searchBar)
        self.navigationItem.leftBarButtonItem = self.editButton
    }
}
