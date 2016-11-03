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
    
    fileprivate var ingredientsSubtitleByIndexArray = [Bool]()
    fileprivate var ingredientsOrderedArray = [String]()
    fileprivate var directionsSubtitleByIndexArray = [Bool]()
    fileprivate var directionsOrderedArray = [String]()
    
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

        self.tableView.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.prepareFavoritesElements()
    }
    
    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------
    
    fileprivate func getNumOfRowsFromDict(_ dict: [String: [String]]) -> Int {
        var numOfRows: Int = 0
        if dict.count > 1 {
            numOfRows += dict.count - 1
        }
        for (_, values) in dict {
            numOfRows += values.count
        }
        return numOfRows
    }
    
    fileprivate func setSectionHeaderElements(_ cell: SectionHeaderTableViewCell, FAIconName: FontAwesome, title: String) {
        cell.sectionHeaderIconImageView.image = UIImage.fontAwesomeIcon(name: FAIconName, textColor: UIColor.black, size: CGSize(width: 20, height: 20))
        cell.titleLabel.text = getLocalizedString(title)
    }
    
    fileprivate func prepareIngredientsOrderedArray() {
        
        for (title, ingredients) in recipe.ingredients.reversed() {
            
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
    
    fileprivate func prepareDirectionsOrderedArray() {
        
        for (title, directions) in recipe.directions.reversed() {
            
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
    
    fileprivate func stopSectionsHeadersFromFloating() {
        let dummyViewHeight: CGFloat = 60
        let dummyView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: dummyViewHeight))
        tableView.tableHeaderView = dummyView
        tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
    }
    
    fileprivate func setFavoriteButtonIcon(_ favoriteButton: UIButton) {
        if self.isFavorite == true {
            favoriteButton.setTitle(String.fontAwesomeIcon(name: FontAwesome.Heart), for: UIControlState())
        } else {
            favoriteButton.setTitle(String.fontAwesomeIcon(name: FontAwesome.HeartO), for: UIControlState())
        }
    }
    
    fileprivate func prepareFavoritesElements() {
        if let favoritesIds = UserDefaults.standard.array(forKey: "favorites") as? [String] {
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

    @IBAction func markAsFavorite(_ sender: AnyObject) {
        if self.isFavorite == true {
            self.isFavorite = false
            if var favoriteIds = UserDefaults.standard.array(forKey: "favorites") as? [String] {
                favoriteIds.removeObject(recipe.id)
                UserDefaults.standard.set(favoriteIds, forKey: "favorites")
            }
        } else {
            self.isFavorite = true
            if var favoriteIds = UserDefaults.standard.array(forKey: "favorites") as? [String] {
                favoriteIds.append(self.recipe.id)
                UserDefaults.standard.set(favoriteIds, forKey: "favorites")
            } else {
                UserDefaults.standard.set([self.recipe.id], forKey: "favorites")
            }
        }
        self.setFavoriteButtonIcon(self.favoriteButton)
    }
    
    //--------------------------------------
    // MARK: - Table view data source
    //--------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: RecipeImageTableViewCellIdentifier, for: indexPath) as! RecipeImageTableViewCell
            
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
            let cell = tableView.dequeueReusableCell(withIdentifier: PrepTimeTableViewCellIdentifier, for: indexPath) as! PrepTimeTableViewCell
            cell.backgroundColor = .clear
            
            cell.recipe = recipe
            return cell
        } else if indexPath.section == 2 {

            if self.ingredientsSubtitleByIndexArray[indexPath.row] == true {
                let cell = tableView.dequeueReusableCell(withIdentifier: RecipeSubtitleTableViewCellIdentifier, for: indexPath) as! RecipeSubtitleTableViewCell
                cell.subtitleLabel.text = self.ingredientsOrderedArray[indexPath.row]
                cell.backgroundColor = .clear
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableViewCellIdentifier, for: indexPath) as! IngredientTableViewCell
                
                let ingredient = self.ingredientsOrderedArray[indexPath.row]
                let ingredientArr = ingredient.components(separatedBy: "|")
                let amount: String = ingredientArr[0]
                let ingredientText: String = ingredientArr[1]
                
                cell.ingredientAmountLabel.text = Helpers.sharedInstance.getFractionSymbolFromString(amount)
                cell.ingredientLabel.text = ingredientText
                cell.backgroundColor = .clear
                return cell
            }
            
        } else if indexPath.section == 3 {
            
            if self.directionsSubtitleByIndexArray[indexPath.row] == true {
                let cell = tableView.dequeueReusableCell(withIdentifier: RecipeSubtitleTableViewCellIdentifier, for: indexPath) as! RecipeSubtitleTableViewCell
                cell.subtitleLabel.text = self.directionsOrderedArray[indexPath.row]
                cell.backgroundColor = .clear
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: DirectionTableViewCellIdentifier, for: indexPath) as! DirectionTableViewCell
                cell.directionLabel.text = self.directionsOrderedArray[indexPath.row]
                cell.directionIndexLabel.text = "\(indexPath.row + 1)"
                cell.backgroundColor = .clear
                return cell
            }
        }
        return UITableViewCell()
    }
    
    //--------------------------------------
    // MARK: - Table view delegate
    //--------------------------------------

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 215
        }
        else if indexPath.section == 1 {
            if let cell = self.tableView.cellForRow(at: indexPath) as? PrepTimeTableViewCell {
                return cell.getHeight()
            }
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 215.0
        }
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 58.0
        }
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: SectionHeaderTableViewCellIdentifier) as! SectionHeaderTableViewCell
        
        switch section {
            case 0:
                let recipeDetailCell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailSectionHeaderTableViewCellIdentifier) as! RecipeDetailSectionHeaderTableViewCell
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
                let dummyView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: dummyViewHeight))
                return dummyView
        }

        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}
