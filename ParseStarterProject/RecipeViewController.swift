//
//  RecipeViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 31/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let SectionHeaderTableViewCellIdentifier = "SectionHeaderTableViewCell"
    let RecipeSubtitleTableViewCellIdentifier = "RecipeSubtitleTableViewCell"
    let PrepTimeTableViewCellIdentifier = "PrepTimeTableViewCell"
    let IngredientTableViewCellIdentifier = "IngredientTableViewCell"
    let DirectionTableViewCellIdentifier = "DirectionTableViewCell"
    
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateAdded: UILabel!
    @IBOutlet var level: UILabel!
    @IBOutlet var overallTime: UILabel!
    @IBOutlet var type: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    var recipe: Recipe!
    
    private var ingredientsSubtitleByIndexArray = [Bool]()
    private var ingredientsOrderedArray = [String]()
    private var directionsSubtitleByIndexArray = [Bool]()
    private var directionsOrderedArray = [String]()
    
    // MARK: -
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.titleLabel.text = recipe.title
        self.type.text = recipe.type
        self.level.text = recipe.level
        self.overallTime.text = recipe.getOverallPreperationTimeText()
        self.dateAdded.text = recipe.getDateAddedDiff()
        
        // update image async
        let imageUrlString = Constants.GDRecipesImagesPath + recipe.imageName
        Helpers().updateImageFromUrlAsync(imageUrlString, imageViewToUpdate: self.recipeImageView)

        // Make sections headers static and not floating
        self.stopSectionsHeadersFromFloating()
        
        // prepare ordered ingredients array for later use
        self.prepareIngredientsOrderedArray()
        
        // prepare ordered directions array for later use
        self.prepareDirectionsOrderedArray()
        
        // set table view background image
        self.view.backgroundColor = UIColor(patternImage: Helpers().getDeviceSpecificBGImage("tableview-bg"))

        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1
            case 1:
                return self.getNumOfRowsFromDict(self.recipe.ingredients)
            case 2:
                return self.getNumOfRowsFromDict(self.recipe.directions)
            default:
                return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(PrepTimeTableViewCellIdentifier, forIndexPath: indexPath) as! PrepTimeTableViewCell
            cell.backgroundColor = .clearColor()
            cell.cookTimeLabel.text = recipe.getCookTimeText()
            cell.prepTimeLabel.text = recipe.getPreperationTimeText()
            return cell
        } else if indexPath.section == 1 {

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
                
                cell.ingredientAmountLabel.text = Helpers().getFractionSymbolFromString(amount)
                cell.ingredientLabel.text = ingredientText
                cell.backgroundColor = .clearColor()
                return cell
            }
            
        } else if indexPath.section == 2 {
            
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(SectionHeaderTableViewCellIdentifier) as! SectionHeaderTableViewCell
        
        switch section {
            case 0:
                self.setSectionHeaderElements(cell, FAIconName: FontAwesome.ClockO, title: "sectionHeaderTitleTime")
            case 1:
                // SPLIT TEST: shopping-cart|lemon-o|pencil-square-o
                self.setSectionHeaderElements(cell, FAIconName: FontAwesome.ShoppingBasket, title: "sectionHeaderTitleIngredients")
            case 2:
                self.setSectionHeaderElements(cell, FAIconName: FontAwesome.FileTextO, title: "sectionHeaderTitleDirections")
            default:
                self.setSectionHeaderElements(cell, FAIconName: FontAwesome.ClockO, title: "sectionHeaderTitleTime")
        }

        return cell.contentView
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = .clearColor()
    }
    
    // MARK: -
    // MARK: Helpers
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
        let dummyViewHeight: CGFloat = 40
        let dummyView: UIView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, dummyViewHeight))
        tableView.tableHeaderView = dummyView
        tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
    }
}
