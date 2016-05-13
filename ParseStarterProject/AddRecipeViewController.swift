//
//  AddRecipeTableViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 20/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AddRecipeViewController: UITableViewController, UITextFieldDelegate, SwiftPromptsProtocol {

    let SegueSelectCategoriesTableViewController = "SelectCategoriesTableViewController"

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

    // errors
    let ERROR_CODE_MISSING_DATA = 11111
    let ERROR_CODE_PREP_TIME_ZERO = 11112
    let ERROR_CODE_MISSING_INGREDIENT_TEXT = 11113
    let ERROR_CODE_INGREDIENT_NUMBER_CONTAINS_TEXT = 11114
    
    var prompt = SwiftPromptsView()
    var activityIndicator: ActivityIndicator!
    
    var ingredientsArray: [String] = ["ingredient"]
    var directionsArray: [String] = ["direction"]
    
    var ingredientsEndPositionPerSection = ["general": [0,0]]
    var currentIngredientSection = "general"
    
    var categories = [Category]()
    
    // Submit parameters
    var recipeTitle: String!
    var recipeImage: UIImage!
    var recipeLevel: String!
    var recipeType: String!
    var recipeCategories = [Category]()
    var recipePrepTime: Int!
    var recipeCookTime: Int = 0
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
        
        ParseHelper().updateCategories(addRecipe: self)
        
        self.editing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.activityIndicator = ActivityIndicator(largeActivityView: self.tableView.superview!, options: ["labelText": getLocalizedString("submitting")])
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
            return 94.0
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
        if self.recipeCategories.isEmpty {
            missingFields.append("categories")
        }
        if self.recipePrepTime == nil || self.recipePrepTime == 0 {
            missingFields.append("prepTime")
        }
        if self.recipeIngredients["general"]! == [] {
            missingFields.append("ingredients")
        }
        if self.recipeDirections["general"]! == [] {
            missingFields.append("directions")
        }
        
        return missingFields
    }
    
    private func hasErrorsInFields() -> Bool {
        var hasError = false

        if !self.getMissingFieldsBeforeSubmit().isEmpty {
            hasError = true
            self.showErrorAlert(self.ERROR_CODE_MISSING_DATA)
        } else if self.recipePrepTime == 0 {
            hasError = true
            self.showErrorAlert(self.ERROR_CODE_PREP_TIME_ZERO)
        } else {
            
            if let ingredients = self.recipeIngredients["general"] {
                for ingredient in ingredients {
                    // empty second field
                    if ingredient =~ "\\|$" {
                        hasError = true
                        self.showErrorAlert(self.ERROR_CODE_MISSING_INGREDIENT_TEXT)
                    }
                    
                    // non number or \ chars in first field
                    if let ingredients = self.recipeIngredients["general"] {
                        for ingredient in ingredients {
                            if ingredient !=~ "^[\\d|\\\\]*\\|" {
                                hasError = true
                                self.showErrorAlert(self.ERROR_CODE_INGREDIENT_NUMBER_CONTAINS_TEXT)
                            }
                        }
                    }

                }
            }
            
        }
        return hasError
    }
    
    func showSuccessAlert() {
        //Create an instance of SwiftPromptsView and assign its delegate
        prompt = SwiftPromptsView(frame: self.view.frame)
        prompt.delegate = self
        
        SwiftPromptHelper.buildSuccessAlert(prompt, type: "uploadSuccess")
        self.tableView.superview?.addSubview(prompt)
        self.navigationController?.navigationBar.userInteractionEnabled = false
    }
    
    func showErrorAlert(errorCode: Int = 0) {
        var propmptType = "generalError"
        switch errorCode {
        case self.ERROR_CODE_MISSING_DATA:
            propmptType = "uploadErrorMissingData"
        case self.ERROR_CODE_PREP_TIME_ZERO:
            propmptType = "uploadErrorPrepTimeZero"
        case self.ERROR_CODE_MISSING_INGREDIENT_TEXT:
            propmptType = "uploadErrorMissingIngredientText"
        case self.ERROR_CODE_INGREDIENT_NUMBER_CONTAINS_TEXT:
            propmptType = "uploadErrorIngredientNumberContainsText"
        default:
            propmptType = "generalError"
        }
        
        //Create an instance of SwiftPromptsView and assign its delegate
        prompt = SwiftPromptsView(frame: self.view.frame)
        prompt.delegate = self
        
        SwiftPromptHelper.buildErrorAlert(prompt, type: propmptType)
        self.tableView.superview?.addSubview(prompt)
        self.navigationController?.navigationBar.userInteractionEnabled = false
    }
    
    func showActivityIndicator() {
        if let _ = self.activityIndicator {
            self.navigationController?.view.userInteractionEnabled = false
            self.activityIndicator.show()
        } else {
            print("ERROR: self.activityIndicator not set")
        }
    }

    func hideActivityIndicator() {
        if let _ = self.activityIndicator {
            self.navigationController?.view.userInteractionEnabled = true
            self.activityIndicator.hide()
        } else {
            print("ERROR: self.activityIndicator not set")
        }
    }

    //--------------------------------------
    // MARK: - actions
    //--------------------------------------

    func uploadRecipe(sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
        
        if !self.hasErrorsInFields() {
            let recipeData = [
                "title":        self.recipeTitle,
                "image":        self.recipeImage,
                "level":        self.recipeLevel,
                "type":         self.recipeType,
                "categories":   self.recipeCategories,
                "prepTime":     self.recipePrepTime,
                "cookTime":     self.recipeCookTime,
                "ingredients":  self.recipeIngredients,
                "directions":   self.recipeDirections
            ]
            ParseHelper().uploadRecipe(recipeData, vc: self)
        }
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        if segue.sourceViewController.isKindOfClass(SelectCategoriesTableViewController) {
            if let sourceVC = segue.sourceViewController as? SelectCategoriesTableViewController {
                self.recipeCategories = sourceVC.selectedCategories
            }
        }
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.postNotificationName("DoneSelectingCategories", object: self.recipeCategories)
    }
    
    //--------------------------------------
    // MARK: - SwiftPromptsProtocol delegate methods
    //--------------------------------------
    
    func clickedOnTheMainButton() {
        prompt.dismissPrompt()
        self.navigationController?.navigationBar.userInteractionEnabled = true
    }
    
    func clickedOnTheSecondButton() {
        prompt.dismissPrompt()
        self.navigationController?.navigationBar.userInteractionEnabled = true
    }
    
    func promptWasDismissed() {
    }

    //--------------------------------------
    // MARK: - Text Field Delegate
    //--------------------------------------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //--------------------------------------
    // MARK: - navigation
    //--------------------------------------

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueSelectCategoriesTableViewController {
            let destinationNavigationViewController = segue.destinationViewController
            let viewControllers = destinationNavigationViewController.childViewControllers
            for vc in viewControllers {
                if let destinationViewController = vc as? SelectCategoriesTableViewController {
                    destinationViewController.categories = self.categories
                    destinationViewController.selectedCategories = self.recipeCategories
                }
                
            }
        }
    }
}
