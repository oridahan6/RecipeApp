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
    
    var ingredientsEndPositionPerSection = ["general": [0,0]]
    var currentIngredientSection = "general"
    
    // Submit parameters
    var recipeTitle: String!
    var recipeImage: UIImage!
    var recipeLevel: String!
    var recipeType: String!
    var recipePrepTime: Int!
    var recipeCookTime: Int!
    var recipeIngredients: [String: [String]] = ["general": []]
    var recipeDirections: [String: [String]] = ["general": []]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = getLocalizedString("addRecipe")
        
        // Make sections headers static and not floating
        self.stopSectionsHeadersFromFloating()

        // set table view background image
        self.view.backgroundColor = UIColor(patternImage: Helpers().getDeviceSpecificBGImage("tableview-bg"))

        // add done button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: getLocalizedString("done"), style: .Done, target: self, action: #selector(AddRecipeViewController.uploadRecipe(_:)))
        
        self.editing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //--------------------------------------
    // MARK: - Table view data source
    //--------------------------------------
    
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
                    cell.tableViewController = self
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCellWithIdentifier(AddDirectionTableViewCellIdentifier, forIndexPath: indexPath) as! AddDirectionTableViewCell
                    cell.backgroundColor = .clearColor()
                    cell.tableViewController = self
                    return cell
                }
            }
        default:
            return UITableViewCell()
        }
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if  indexPath.section == 3 && indexPath.row != self.ingredientsArray.count ||
            indexPath.section == 4 && indexPath.row != self.directionsArray.count {
            return true
        }
        return false
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        if sourceIndexPath.section == 3 {
        
            var sourceSectionName = ""
            var destSectionName = ""
            
            for (sectionName, indexesArray) in self.ingredientsEndPositionPerSection {
                if sourceIndexPath.row <= indexesArray[1] && sourceIndexPath.row >= indexesArray[0] {
                    sourceSectionName = sectionName
                }
                
                if destinationIndexPath.row <= indexesArray[1] && destinationIndexPath.row >= indexesArray[0] {
                    destSectionName = sectionName
                }
            }

            if destSectionName == "" {
                for (sectionName, indexesArray) in self.ingredientsEndPositionPerSection {
                    if destinationIndexPath.row == indexesArray[1] + 1 && sectionName != sourceSectionName ||
                        destinationIndexPath.row == indexesArray[0] - 1 && sectionName != sourceSectionName {
                        destSectionName = sectionName
                    }
                }
            }
            
            if var sourceSection = self.recipeIngredients[sourceSectionName], var destSection = self.recipeIngredients[destSectionName] {
                if var sourceIndexes = self.ingredientsEndPositionPerSection[sourceSectionName], var destIndexes = self.ingredientsEndPositionPerSection[destSectionName]  {
                    if sourceSectionName == destSectionName {
                        
                        let sourceSectionIndex = sourceIndexPath.row - sourceIndexes[0]
                        let destSectionIndex = destinationIndexPath.row - sourceIndexes[0]
                        
                        if !sourceSection.isEmpty {
                        
                            let currentIngredient = sourceSection[sourceSectionIndex]

                            sourceSection.removeAtIndex(sourceSectionIndex)
                            sourceSection.insert(currentIngredient, atIndex: destSectionIndex)
            
                            self.recipeIngredients[sourceSectionName] = sourceSection
                        }
                    
                    } else {
                        // move between sections
                        let sourceSectionIndex = sourceIndexPath.row - sourceIndexes[0]
                        let currentIngredient = sourceSection[sourceSectionIndex]
                        
                        sourceSection.removeAtIndex(sourceSectionIndex)
                        
                        if sourceSectionIndex == 0 && destinationIndexPath.row < sourceIndexPath.row {
                            sourceIndexes[0] += 1
                        } else if sourceSectionIndex == 0 && destinationIndexPath.row > sourceIndexPath.row {
                            sourceIndexes[1] -= 1
                        } else if destinationIndexPath.row < sourceIndexPath.row {
                            sourceIndexes[0] += 1
                        } else if destinationIndexPath.row > sourceIndexPath.row {
                            sourceIndexes[1] -= 1
                        }
                        
                        var destSectionIndex = max(destinationIndexPath.row - destIndexes[0], 0)
                        
                        if destSectionIndex != 0 && destinationIndexPath.row > sourceIndexPath.row {
                            destSectionIndex += 1
                        }
                        
                        destSection.insert(currentIngredient, atIndex: destSectionIndex)
                        
                        if destSectionIndex == 0 && destinationIndexPath.row > sourceIndexPath.row {
                            destIndexes[0] -= 1
                        } else if destSectionIndex == 0 && destinationIndexPath.row < sourceIndexPath.row {
                            destIndexes[1] += 1
                        } else if destinationIndexPath.row > sourceIndexPath.row {
                            destIndexes[0] -= 1
                        } else if destinationIndexPath.row < sourceIndexPath.row {
                            destIndexes[1] += 1
                        }
                        
                        self.recipeIngredients[sourceSectionName] = sourceSection
                        self.ingredientsEndPositionPerSection[sourceSectionName] = sourceIndexes
                        self.recipeIngredients[destSectionName] = destSection
                        self.ingredientsEndPositionPerSection[destSectionName] = destIndexes

                    }
                }
            }
        } else if sourceIndexPath.section == 4 {
            
            let sectionName = "general"
            if var sourceSection = self.recipeDirections[sectionName] {
                if !sourceSection.isEmpty {
                    
                    let currentDirection = sourceSection[sourceIndexPath.row]
                    
                    sourceSection.removeAtIndex(sourceIndexPath.row)
                    sourceSection.insert(currentDirection, atIndex: destinationIndexPath.row)

                    self.recipeDirections[sectionName] = sourceSection
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        }
        
        if sourceIndexPath.section == 3 {
            if proposedDestinationIndexPath.section != 3 || proposedDestinationIndexPath.row == self.ingredientsArray.count {
                return sourceIndexPath
            }
        }
        
        if sourceIndexPath.section == 4 {
            if proposedDestinationIndexPath.section != 4 || proposedDestinationIndexPath.row == self.directionsArray.count {
                return sourceIndexPath
            }
        }

//        if proposedDestinationIndexPath.section != 3 && proposedDestinationIndexPath.section != 4 {
//            return sourceIndexPath
//        } else if proposedDestinationIndexPath.row == self.ingredientsArray.count {
//            return sourceIndexPath
//        }
        return proposedDestinationIndexPath
    }
    
    //--------------------------------------
    // MARK: - Table view delegate
    //--------------------------------------
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 215
        } else if indexPath.section == 1 || indexPath.section == 2 {
            return 65.0
        } else if indexPath.section == 3 && indexPath.row < self.ingredientsArray.count {
            return 38.0
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

    private func getMissingFieldsBeforeSubmit() -> [String] {
        var missingFields: [String] = []
        
        if self.recipeTitle == nil {
            missingFields.append("title")
        }
        if self.recipeImage == nil {
            missingFields.append("image")
        }
        if self.recipeLevel == nil {
            missingFields.append("level")
        }
        if self.recipeType == nil {
            missingFields.append("type")
        }
        if self.recipePrepTime == nil {
            missingFields.append("prepTime")
        }
        if self.recipeCookTime == nil {
            missingFields.append("cookTime")
        }
        if self.recipeIngredients["general"]! == [] {
            missingFields.append("ingredients")
        }
        if self.recipeDirections["general"]! == [] {
            missingFields.append("directions")
        }
        
        print(missingFields)
        
        return missingFields
    }
    
    //--------------------------------------
    // MARK: - actions
    //--------------------------------------

    func uploadRecipe(sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
        
        if self.getMissingFieldsBeforeSubmit().isEmpty {
            
            let recipeData = [
                "title":        self.recipeTitle,
                "image":        self.recipeImage,
                "level":        self.recipeLevel,
                "type":         self.recipeType,
                "prepTime":     self.recipePrepTime,
                "cookTime":     self.recipeCookTime,
                "ingredients":  self.recipeIngredients,
                "directions":   self.recipeDirections
            ]
            
            print(recipeData)
            
            ParseHelper().uploadRecipe(recipeData)
            
        } else {
            print("data missing")
        }
        
    }
    
    //--------------------------------------
    // MARK: - Text Field Delegate
    //--------------------------------------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}
