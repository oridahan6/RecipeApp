//
//  RecipeViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 31/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
//import Kingfisher

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let SectionHeaderTableViewCellIdentifier = "SectionHeaderTableViewCell"
    let RecipeDetailSectionHeaderTableViewCellIdentifier = "RecipeDetailSectionHeaderTableViewCell"
    let RecipeSubtitleTableViewCellIdentifier = "RecipeSubtitleTableViewCell"
    let RecipeImageTableViewCellIdentifier = "RecipeImageTableViewCell"
    let PrepTimeTableViewCellIdentifier = "PrepTimeTableViewCell"
    let IngredientTableViewCellIdentifier = "IngredientTableViewCell"
    let DirectionTableViewCellIdentifier = "DirectionTableViewCell"
    
    @IBOutlet var tableView: UITableView!
    
    var recipe: Recipe!
    var isFavorite: Bool = false
    var favoriteButton: UIButton!
    
    private var ingredientsSubtitleByIndexArray = [Bool]()
    private var ingredientsOrderedArray = [String]()
    private var directionsSubtitleByIndexArray = [Bool]()
    private var directionsOrderedArray = [String]()
    
    //--------------------------------------
    // MARK: - View Life Cycle
    //--------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Make sections headers static and not floating
        self.stopSectionsHeadersFromFloating()
        
        // prepare ordered ingredients array for later use
        self.prepareIngredientsOrderedArray()
        
        // prepare ordered directions array for later use
        self.prepareDirectionsOrderedArray()
        
        // set table view background image
        self.view.backgroundColor = UIColor(patternImage: Helpers.sharedInstance.getDeviceSpecificBGImage("tableview-bg"))

        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.prepareFavoritesElements()
    }
    
    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------
    
    private func getNumOfRowsFromDict(dict: [String: [String]]) -> Int {
        var numOfRows: Int = 0
        if dict.count > 1 {
            numOfRows += dict.count - 1
        }
        for (_, values) in dict {
            numOfRows += values.count
        }
        return numOfRows
    }
    
    private func setSectionHeaderElements(cell: SectionHeaderTableViewCell, FAIconName: FontAwesome, title: String) {
        cell.sectionHeaderIconImageView.image = UIImage.fontAwesomeIconWithName(FAIconName, textColor: UIColor.blackColor(), size: CGSizeMake(20, 20))
        cell.titleLabel.text = getLocalizedString(title)
    }
    
    private func prepareIngredientsOrderedArray() {
        
        for (title, ingredients) in recipe.ingredients.reverse() {
            
            if title != "general" {
                self.ingredientsOrderedArray.append(title)
                self.ingredientsSubtitleByIndexArray.append(true)
            }
            for ingredient in ingredients {
                self.ingredientsSubtitleByIndexArray.append(false)
                self.ingredientsOrderedArray.append(ingredient)
            }
            
        }
        
    }
    
    private func prepareDirectionsOrderedArray() {
        
        for (title, directions) in recipe.directions.reverse() {
            
            if title != "general" {
                self.directionsOrderedArray.append(title)
                self.directionsSubtitleByIndexArray.append(true)
            }
            for direction in directions {
                self.directionsSubtitleByIndexArray.append(false)
                self.directionsOrderedArray.append(direction)
            }
            
        }
        
    }
    
    private func stopSectionsHeadersFromFloating() {
        let dummyViewHeight: CGFloat = 60
        let dummyView: UIView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, dummyViewHeight))
        tableView.tableHeaderView = dummyView
        tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
    }
    
    private func setFavoriteButtonIcon(favoriteButton: UIButton) {
        if self.isFavorite == true {
            favoriteButton.setTitle(String.fontAwesomeIconWithName(FontAwesome.Heart), forState: .Normal)
        } else {
            favoriteButton.setTitle(String.fontAwesomeIconWithName(FontAwesome.HeartO), forState: .Normal)
        }
    }
    
    private func prepareFavoritesElements() {
        if let favoritesIds = NSUserDefaults.standardUserDefaults().arrayForKey("favorites") as? [String] {
            if favoritesIds.contains(recipe.id) {
                isFavorite = true
            } else {
                isFavorite = false
            }
        }
        if let favoriteButton = self.favoriteButton {
            self.setFavoriteButtonIcon(favoriteButton)
        }
    }
    
    //--------------------------------------
    // MARK: - Buttons actions
    //--------------------------------------

    @IBAction func markAsFavorite(sender: AnyObject) {
        if self.isFavorite == true {
            self.isFavorite = false
            if var favoriteIds = NSUserDefaults.standardUserDefaults().arrayForKey("favorites") as? [String] {
                favoriteIds.removeObject(recipe.id)
                NSUserDefaults.standardUserDefaults().setObject(favoriteIds, forKey: "favorites")
            }
        } else {
            self.isFavorite = true
            if var favoriteIds = NSUserDefaults.standardUserDefaults().arrayForKey("favorites") as? [String] {
                favoriteIds.append(self.recipe.id)
                NSUserDefaults.standardUserDefaults().setObject(favoriteIds, forKey: "favorites")
            } else {
                NSUserDefaults.standardUserDefaults().setObject([self.recipe.id], forKey: "favorites")
            }
        }
        self.setFavoriteButtonIcon(self.favoriteButton)
    }
    
    //--------------------------------------
    // MARK: - Table view data source
    //--------------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                return self.getNumOfRowsFromDict(self.recipe.ingredients)
            case 3:
                return self.getNumOfRowsFromDict(self.recipe.directions)
            default:
                return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(RecipeImageTableViewCellIdentifier, forIndexPath: indexPath) as! RecipeImageTableViewCell
            
            if recipe.imageName != "" {
                // update image async
                let imageUrlString = Constants.GDRecipesImagesPath + recipe.imageName
                KingfisherHelper.sharedInstance.setImageWithUrl(cell.recipeImageView, url: imageUrlString)
            } else if let recipeFile = recipe.imageFile {
                let fileUrl = recipeFile.getUrl()
                KingfisherHelper.sharedInstance.setImageWithUrl(cell.recipeImageView, url: fileUrl)
            }
            
            cell.favoriteButton.titleLabel?.font = UIFont.fontAwesomeOfSize(22)
            self.setFavoriteButtonIcon(cell.favoriteButton)
            
            self.favoriteButton = cell.favoriteButton
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(PrepTimeTableViewCellIdentifier, forIndexPath: indexPath) as! PrepTimeTableViewCell
            cell.backgroundColor = .clearColor()
            
            cell.recipe = recipe
            return cell
        } else if indexPath.section == 2 {

            if self.ingredientsSubtitleByIndexArray[indexPath.row] == true {
                let cell = tableView.dequeueReusableCellWithIdentifier(RecipeSubtitleTableViewCellIdentifier, forIndexPath: indexPath) as! RecipeSubtitleTableViewCell
                cell.subtitleLabel.text = self.ingredientsOrderedArray[indexPath.row]
                cell.backgroundColor = .clearColor()
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(IngredientTableViewCellIdentifier, forIndexPath: indexPath) as! IngredientTableViewCell
                
                let ingredient = self.ingredientsOrderedArray[indexPath.row]
                let ingredientArr = ingredient.componentsSeparatedByString("|")
                let amount: String = ingredientArr[0]
                let ingredientText: String = ingredientArr[1]
                
                cell.ingredientAmountLabel.text = Helpers.sharedInstance.getFractionSymbolFromString(amount)
                cell.ingredientLabel.text = ingredientText
                cell.backgroundColor = .clearColor()
                return cell
            }
            
        } else if indexPath.section == 3 {
            
            if self.directionsSubtitleByIndexArray[indexPath.row] == true {
                let cell = tableView.dequeueReusableCellWithIdentifier(RecipeSubtitleTableViewCellIdentifier, forIndexPath: indexPath) as! RecipeSubtitleTableViewCell
                cell.subtitleLabel.text = self.directionsOrderedArray[indexPath.row]
                cell.backgroundColor = .clearColor()
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(DirectionTableViewCellIdentifier, forIndexPath: indexPath) as! DirectionTableViewCell
                cell.directionLabel.text = self.directionsOrderedArray[indexPath.row]
                cell.directionIndexLabel.text = "\(indexPath.row + 1)"
                cell.backgroundColor = .clearColor()
                return cell
            }
        }
        return UITableViewCell()
    }
    
    //--------------------------------------
    // MARK: - Table view delegate
    //--------------------------------------

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 215
        }
        else if indexPath.section == 1 {
            if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? PrepTimeTableViewCell {
                return cell.getHeight()
            }
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 215.0
        }
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 58.0
        }
        return 45.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(SectionHeaderTableViewCellIdentifier) as! SectionHeaderTableViewCell
        
        switch section {
            case 0:
                let recipeDetailCell = tableView.dequeueReusableCellWithIdentifier(RecipeDetailSectionHeaderTableViewCellIdentifier) as! RecipeDetailSectionHeaderTableViewCell
                recipeDetailCell.recipe = self.recipe
                return recipeDetailCell
            
            case 1:
                self.setSectionHeaderElements(cell, FAIconName: FontAwesome.ClockO, title: "sectionHeaderTitleTime")
            case 2:
                // SPLIT TEST: shopping-cart|lemon-o|pencil-square-o
                self.setSectionHeaderElements(cell, FAIconName: FontAwesome.ShoppingBasket, title: "sectionHeaderTitleIngredients")
            case 3:
                self.setSectionHeaderElements(cell, FAIconName: FontAwesome.FileTextO, title: "sectionHeaderTitleDirections")
            default:
                let dummyViewHeight: CGFloat = 45
                let dummyView: UIView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, dummyViewHeight))
                return dummyView
        }

        return cell.contentView
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = .clearColor()
    }
}
