//
//  AddRecipeTableViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 20/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AddRecipeViewController: UITableViewController, UITextFieldDelegate {

    let TitleTableViewCellIdentifier = "TitleTableViewCell"
    let ImageAddTableViewCellIdentifier = "ImageAddTableViewCell"
    let AddRecipeSectionHeaderTableViewCellIdentifier = "AddRecipeSectionHeaderTableViewCell"
    let GeneralInfoTableViewCellIdentifier = "GeneralInfoTableViewCell"
    let TotalTimeTableViewCellIdentifier = "TotalTimeTableViewCell"
    let AddIngredientSectionTableViewCellIdentifier = "AddIngredientSectionTableViewCell"
    let AddIngredientTableViewCellIdentifier = "AddIngredientTableViewCell"
    let AddDirectionSectionTableViewCellIdentifier = "AddDirectionSectionTableViewCell"
    let AddDirectionTableViewCellIdentifier = "AddDirectionTableViewCell"
    let AddRecipeButtonsTableViewCellIdentifier = "AddRecipeButtonsTableViewCell"

    var ingredientsArray: [String] = ["ingredient"]
    var directionsArray: [String] = ["direction"]
    
    var ingredientsEndPositionPerSection = ["general": 0]
    var currentIngredientSection = "general"
    
    // Submit parameters
    var recipeTitle: String!
    var recipeImage: UIImage!
    var recipeLevel: String!
    var recipeType: String!
    var recipePrepTime: Int!
    var recipeCookTime: Int!
    var recipeIngredients: [String: [String]] = ["general": []]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = getLocalizedString("addRecipe")
        
        // Make sections headers static and not floating
        self.stopSectionsHeadersFromFloating()

        // set table view background image
        self.view.backgroundColor = UIColor(patternImage: Helpers().getDeviceSpecificBGImage("tableview-bg"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return self.ingredientsArray.count + 1
        case 4:
            return self.directionsArray.count + 1
        default:
            return 0
        }

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(ImageAddTableViewCellIdentifier, forIndexPath: indexPath) as! ImageAddTableViewCell
            cell.parentController = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(GeneralInfoTableViewCellIdentifier, forIndexPath: indexPath) as! GeneralInfoTableViewCell
            cell.backgroundColor = .clearColor()
            cell.tableViewController = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(TotalTimeTableViewCellIdentifier, forIndexPath: indexPath) as! TotalTimeTableViewCell
            cell.backgroundColor = .clearColor()
            cell.tableViewController = self
            return cell
        case 3:
            if indexPath.row == self.ingredientsArray.count {
                let cell = tableView.dequeueReusableCellWithIdentifier(AddRecipeButtonsTableViewCellIdentifier, forIndexPath: indexPath) as! AddRecipeButtonsTableViewCell
                cell.tableViewController = self
                cell.addTextButton.setTitle(getLocalizedString("addIngredient"), forState: .Normal)
                cell.addSectionButton.setTitle(getLocalizedString("addSection"), forState: .Normal)
                cell.addTextButton.tag = indexPath.section
                cell.addSectionButton.tag = indexPath.section
                cell.backgroundColor = .clearColor()
                return cell
            } else {
                if self.ingredientsArray[indexPath.row] == "section" {
                    let cell = tableView.dequeueReusableCellWithIdentifier(AddIngredientSectionTableViewCellIdentifier, forIndexPath: indexPath) as! AddIngredientSectionTableViewCell
                    cell.backgroundColor = .clearColor()
                    cell.tableViewController = self
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier(AddIngredientTableViewCellIdentifier, forIndexPath: indexPath) as! AddIngredientTableViewCell
                    cell.backgroundColor = .clearColor()
                    cell.tableViewController = self
                    return cell
                }
            }
            
        case 4:
            if indexPath.row == self.directionsArray.count {
                let cell = tableView.dequeueReusableCellWithIdentifier(AddRecipeButtonsTableViewCellIdentifier, forIndexPath: indexPath) as! AddRecipeButtonsTableViewCell
                cell.tableViewController = self
                cell.addTextButton.setTitle(getLocalizedString("addDirection"), forState: .Normal)
                cell.addSectionButton.setTitle(getLocalizedString("addSection"), forState: .Normal)
                cell.addTextButton.tag = indexPath.section
                cell.addSectionButton.tag = indexPath.section
                cell.backgroundColor = .clearColor()
                return cell
            } else {
                if self.directionsArray[indexPath.row] == "section" {
                    let cell = tableView.dequeueReusableCellWithIdentifier(AddDirectionSectionTableViewCellIdentifier, forIndexPath: indexPath) as! AddDirectionSectionTableViewCell
                    cell.backgroundColor = .clearColor()
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier(AddDirectionTableViewCellIdentifier, forIndexPath: indexPath) as! AddDirectionTableViewCell
                    cell.backgroundColor = .clearColor()
                    return cell
                }
            }
        default:
            return UITableViewCell()
        }
    }

    //--------------------------------------
    // MARK: - Table view delegate
    //--------------------------------------
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 215
        } else if indexPath.section == 1 || indexPath.section == 2 {
            return 65.0
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(TitleTableViewCellIdentifier) as! SectionHeaderTitleTableViewCell
            cell.tableViewController = self
            let view = UIView(frame: cell.frame)
            cell.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            view.addSubview(cell)
            return view
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(AddRecipeSectionHeaderTableViewCellIdentifier) as! AddRecipeSectionHeaderTableViewCell
            
            self.setSectionHeaderElements(cell, FAIconName: FontAwesome.Info, title: "sectionHeaderTitleGeneralInfo")
            
            return cell.contentView
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier(AddRecipeSectionHeaderTableViewCellIdentifier) as! AddRecipeSectionHeaderTableViewCell
            
            self.setSectionHeaderElements(cell, FAIconName: FontAwesome.ClockO, title: "sectionHeaderTitleTime")
            
            return cell.contentView
            
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier(AddRecipeSectionHeaderTableViewCellIdentifier) as! AddRecipeSectionHeaderTableViewCell
            
            self.setSectionHeaderElements(cell, FAIconName: FontAwesome.ShoppingBasket, title: "sectionHeaderTitleIngredients")
            
            return cell.contentView
            
        case 4:
            let cell = tableView.dequeueReusableCellWithIdentifier(AddRecipeSectionHeaderTableViewCellIdentifier) as! AddRecipeSectionHeaderTableViewCell
            
            self.setSectionHeaderElements(cell, FAIconName: FontAwesome.FileTextO, title: "sectionHeaderTitleDirections")
            
            return cell.contentView
        default:
            let dummyViewHeight: CGFloat = 45
            let dummyView: UIView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, dummyViewHeight))
            return dummyView
        }
    }

    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------

    private func setSectionHeaderElements(cell: AddRecipeSectionHeaderTableViewCell, FAIconName: FontAwesome, title: String) {
        cell.sectionImageView.image = UIImage.fontAwesomeIconWithName(FAIconName, textColor: UIColor.blackColor(), size: CGSizeMake(20, 20))
        cell.titleLabel.text = getLocalizedString(title)
    }
    
    private func stopSectionsHeadersFromFloating() {
        let dummyViewHeight: CGFloat = 60
        let dummyView: UIView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, dummyViewHeight))
        tableView.tableHeaderView = dummyView
        tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
    }

    
    //--------------------------------------
    // MARK: - Text Field Delegate
    //--------------------------------------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}
