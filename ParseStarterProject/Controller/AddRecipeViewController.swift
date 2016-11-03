//
//  AddRecipeTableViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 20/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AddRecipeViewController: UITableViewController, UITextFieldDelegate {

    // Notifications
    static let NotificationDoneSelectingCategories = "DoneSelectingCategories"
    static let NotificationUploadRecipeSuccess = "UploadRecipeSuccess"
    
    // Segues
    let SegueSelectCategoriesTableViewController = "SelectCategoriesTableViewController"

    // Cell Identifiers
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
    
//    var ingredientsArray: [String] = ["ingredient"]
//    var directionsArray: [String] = ["direction"]
    
    var ingredientsEndPositionPerSection = ["general": [0,0]]
    var currentIngredientSection = "general"
    
    var categories = [Category]()
    
    var isIngredientEditing = false
    var isDirectionEditing = false
    
    // Submit parameters
    var recipeTitle: String!
    var recipeImage: UIImage!
    var recipeLevel: String!
    var recipeType: String!
    var recipeCategories = [Category]()
    var recipePrepTime: Int!
    var recipeCookTime: Int = 0
    var recipeIngredients: [String: [String]] = ["general": ["|"]]
    var recipeDirections: [String: [String]] = ["general": [""]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = getLocalizedString("addRecipe")
        
        // Make sections headers static and not floating
        self.stopSectionsHeadersFromFloating()

        // set table view background image
        self.tableView.backgroundColor = UIColor.clear
        let backgroundImageView = UIImageView( image : Helpers.sharedInstance.getDeviceSpecificBGImage("tableview-bg"));
        backgroundImageView.frame = self.tableView.frame;
        self.tableView.backgroundView = backgroundImageView;
        
        // add done button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: getLocalizedString("done"), style: .done, target: self, action: #selector(AddRecipeViewController.uploadRecipe(_:)))
        
        ParseHelper.sharedInstance.updateCategories(addRecipe: self)
        
        self.isEditing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //--------------------------------------
    // MARK: - Table view data source
    //--------------------------------------
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return self.getRecipeIngredientsCount() + 1
        case 4:
            return self.getRecipeDirectionsCount() + 1
        default:
            return 0
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageAddTableViewCellIdentifier, for: indexPath) as! ImageAddTableViewCell
            cell.parentController = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: GeneralInfoTableViewCellIdentifier, for: indexPath) as! GeneralInfoTableViewCell
            cell.backgroundColor = .clear
            cell.tableViewController = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: TotalTimeTableViewCellIdentifier, for: indexPath) as! TotalTimeTableViewCell
            cell.backgroundColor = .clear
            cell.tableViewController = self
            return cell
        case 3:
            if indexPath.row == self.getRecipeIngredientsCount() {
                let cell = tableView.dequeueReusableCell(withIdentifier: AddRecipeButtonsTableViewCellIdentifier, for: indexPath) as! AddRecipeButtonsTableViewCell
                cell.tableViewController = self
                cell.addTextButton.setTitle(getLocalizedString("addIngredient"), for: UIControlState())
                cell.addSectionButton.setTitle(getLocalizedString("addSection"), for: UIControlState())
                cell.addTextButton.tag = indexPath.section
                cell.addSectionButton.tag = indexPath.section
                cell.editButton.tag = indexPath.section
                self.changeEditButtonAppearance(cell.editButton, isEdit: self.isIngredientEditing)
                
                cell.backgroundColor = .clear
                return cell
            } else {
                if false
//                    && self.ingredientsArray[indexPath.row] == "section"
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: AddIngredientSectionTableViewCellIdentifier, for: indexPath) as! AddIngredientSectionTableViewCell
                    cell.backgroundColor = .clear
                    cell.tableViewController = self
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: AddIngredientTableViewCellIdentifier, for: indexPath) as! AddIngredientTableViewCell
                    cell.backgroundColor = .clear
                    cell.tableViewController = self
                    
                    if let ingredientsArr = self.recipeIngredients["general"] {
                        cell.ingredientAmountTextField.text = self.getAmountFromIngredient(ingredientsArr[indexPath.row])
                        cell.ingredientTextTextView.text = self.getTextFromIngredient(ingredientsArr[indexPath.row])
                    }
                    
                    return cell
                }
            }
            
        case 4:
            if indexPath.row == self.getRecipeDirectionsCount() {
                let cell = tableView.dequeueReusableCell(withIdentifier: AddRecipeButtonsTableViewCellIdentifier, for: indexPath) as! AddRecipeButtonsTableViewCell
                cell.tableViewController = self
                cell.addTextButton.setTitle(getLocalizedString("addDirection"), for: UIControlState())
                cell.addSectionButton.setTitle(getLocalizedString("addSection"), for: UIControlState())
                cell.addTextButton.tag = indexPath.section
                cell.addSectionButton.tag = indexPath.section
                cell.editButton.tag = indexPath.section
                
                self.changeEditButtonAppearance(cell.editButton, isEdit: self.isDirectionEditing)

                cell.backgroundColor = .clear
                return cell
            } else {
                if false
//                    && self.directionsArray[indexPath.row] == "section"
                {
                    let cell = tableView.dequeueReusableCell(withIdentifier: AddDirectionSectionTableViewCellIdentifier, for: indexPath) as! AddDirectionSectionTableViewCell
                    cell.backgroundColor = .clear
                    cell.tableViewController = self
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: AddDirectionTableViewCellIdentifier, for: indexPath) as! AddDirectionTableViewCell
                    cell.backgroundColor = .clear
                    cell.tableViewController = self
                    
                    if let directionsArr = self.recipeDirections["general"] {
                        cell.directionTextView.text = directionsArr[indexPath.row]
                    }
                    
                    return cell
                }
            }
        default:
            return UITableViewCell()
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if  (self.isIngredientEditing && indexPath.section == 3 && indexPath.row != self.getRecipeIngredientsCount()) ||
            (self.isDirectionEditing && indexPath.section == 4 && indexPath.row != self.getRecipeDirectionsCount()) {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if  (self.isIngredientEditing && indexPath.section == 3 && indexPath.row != self.getRecipeIngredientsCount()) ||
            (self.isDirectionEditing && indexPath.section == 4 && indexPath.row != self.getRecipeDirectionsCount()) {
            return true
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 3 {
                self.recipeIngredients["general"]?.remove(at: indexPath.row)
//                self.ingredientsArray.removeAtIndex(indexPath.row)
            } else if indexPath.section == 4 {
                self.recipeDirections["general"]?.remove(at: indexPath.row)
//                self.directionsArray.removeAtIndex(indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if sourceIndexPath.section == 3 {
        
            let sectionName = "general"
            if var sourceSection = self.recipeIngredients[sectionName] {
                if !sourceSection.isEmpty {
                    
                    let currentIngredient = sourceSection[sourceIndexPath.row]
                    
                    sourceSection.remove(at: sourceIndexPath.row)
                    sourceSection.insert(currentIngredient, at: destinationIndexPath.row)
                    
                    self.recipeIngredients[sectionName] = sourceSection
                }
            }

            
            /* option to move sections in the future
 
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
            */
        } else if sourceIndexPath.section == 4 {
            
            let sectionName = "general"
            if var sourceSection = self.recipeDirections[sectionName] {
                if !sourceSection.isEmpty {
                    
                    let currentDirection = sourceSection[sourceIndexPath.row]
                    
                    sourceSection.remove(at: sourceIndexPath.row)
                    sourceSection.insert(currentDirection, at: destinationIndexPath.row)

                    self.recipeDirections[sectionName] = sourceSection
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        }
        
        if sourceIndexPath.section == 3 {
            if proposedDestinationIndexPath.section != 3 || proposedDestinationIndexPath.row == self.getRecipeIngredientsCount() {
                return sourceIndexPath
            }
        }
        
        if sourceIndexPath.section == 4 {
            if proposedDestinationIndexPath.section != 4 || proposedDestinationIndexPath.row == self.getRecipeDirectionsCount() {
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 215
        } else if indexPath.section == 1 || indexPath.section == 2 {
            return 94.0
        } else if indexPath.section == 3 && indexPath.row < self.getRecipeIngredientsCount() {
            return 60.0
        } else if indexPath.section == 4 && indexPath.row < self.getRecipeDirectionsCount() {
            return 84.0
        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCellIdentifier) as! SectionHeaderTitleTableViewCell
            cell.tableViewController = self
            let view = UIView(frame: cell.frame)
            cell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(cell)
            if let title = self.recipeTitle {
                cell.titleTextField.text = title
            }
            return view
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddRecipeSectionHeaderTableViewCellIdentifier) as! AddRecipeSectionHeaderTableViewCell
            
            self.setSectionHeaderElements(cell, FAIconName: FontAwesome.Info, title: "sectionHeaderTitleGeneralInfo")
            
            return cell.contentView
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddRecipeSectionHeaderTableViewCellIdentifier) as! AddRecipeSectionHeaderTableViewCell
            
            self.setSectionHeaderElements(cell, FAIconName: FontAwesome.ClockO, title: "sectionHeaderTitleTime")
            
            return cell.contentView
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddRecipeSectionHeaderTableViewCellIdentifier) as! AddRecipeSectionHeaderTableViewCell
            
            self.setSectionHeaderElements(cell, FAIconName: FontAwesome.ShoppingBasket, title: "sectionHeaderTitleIngredients")
            
            return cell.contentView
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddRecipeSectionHeaderTableViewCellIdentifier) as! AddRecipeSectionHeaderTableViewCell
            
            self.setSectionHeaderElements(cell, FAIconName: FontAwesome.FileTextO, title: "sectionHeaderTitleDirections")
            
            return cell.contentView
        default:
            let dummyViewHeight: CGFloat = 45
            let dummyView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: dummyViewHeight))
            return dummyView
        }
    }

    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------

    fileprivate func setSectionHeaderElements(_ cell: AddRecipeSectionHeaderTableViewCell, FAIconName: FontAwesome, title: String) {
        cell.sectionImageView.image = UIImage.fontAwesomeIcon(name: FAIconName, textColor: UIColor.black, size: CGSize(width: 20, height: 20))
        cell.titleLabel.text = getLocalizedString(title)
    }
    
    fileprivate func stopSectionsHeadersFromFloating() {
        let dummyViewHeight: CGFloat = 60
        let dummyView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: dummyViewHeight))
        tableView.tableHeaderView = dummyView
        tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
    }

    fileprivate func getMissingFieldsBeforeSubmit() -> [String] {
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
    
    fileprivate func hasErrorsInFields() -> Bool {
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
    
    func handlePostSuccess() {
        self.hideActivityIndicator()
        self.showSuccessAlert()
        self.emptyRecipeUploadData()
        NotificationCenter.default.post(name: Notification.Name(rawValue: AddRecipeViewController.NotificationUploadRecipeSuccess), object: self.recipeCategories)
    }
    
    func showSuccessAlert() {
        SCLAlertViewHelper.sharedInstance.showSuccessAlert("uploadSuccess")
    }
    
    func showErrorAlert(_ errorCode: Int = 0) {
        var alertTextType = "generalError"
        switch errorCode {
        case self.ERROR_CODE_MISSING_DATA:
            alertTextType = "uploadErrorMissingData"
        case self.ERROR_CODE_PREP_TIME_ZERO:
            alertTextType = "uploadErrorPrepTimeZero"
        case self.ERROR_CODE_MISSING_INGREDIENT_TEXT:
            alertTextType = "uploadErrorMissingIngredientText"
        case self.ERROR_CODE_INGREDIENT_NUMBER_CONTAINS_TEXT:
            alertTextType = "uploadErrorIngredientNumberContainsText"
        default:
            alertTextType = "generalError"
        }
        
        SCLAlertViewHelper.sharedInstance.showErrorAlert(alertTextType)
    }
    
    func showActivityIndicator() {
        SVProgressHUDHelper.sharedInstance.showPostingHUD()
    }
    
    func hideActivityIndicator() {
        SVProgressHUDHelper.sharedInstance.dissmisHUD()
    }
    
    func getRecipeIngredientsCount() -> Int {
        if let ingredients = self.recipeIngredients["general"] {
            return ingredients.count
        }
        return 0
    }
    
    func getRecipeDirectionsCount() -> Int {
        if let directions = self.recipeDirections["general"] {
            return directions.count
        }
        return 0
    }
    
    fileprivate func changeEditButtonAppearance(_ editButton: UIButton, isEdit: Bool) {
        if isEdit {
            editButton.tintColor = Helpers.sharedInstance.getRedColor()
            editButton.setTitle(getLocalizedString("done"), for: UIControlState())
        } else {
            editButton.tintColor = Helpers.sharedInstance.uicolorFromHex(0x0076ff)
            editButton.setTitle(getLocalizedString("edit"), for: UIControlState())
        }
        
    }
    
    fileprivate func emptyRecipeUploadData() {
        
        self.recipeTitle = nil
        self.recipeImage = nil
        self.recipeLevel = nil
        self.recipeType = nil
        self.recipeCategories = [Category]()
        self.recipePrepTime = nil
        self.recipeCookTime = 0
        self.recipeIngredients = ["general": ["|"]]
        self.recipeDirections = ["general": [""]]
        
//        self.ingredientsArray = ["ingredient"]
//        self.directionsArray = ["direction"]

        self.tableView.reloadData()
    }
    
    fileprivate func getAmountFromIngredient(_ ingredient: String) -> String {
        return ingredient.firstRegexMatches("^(.*)\\|.*$")
    }

    fileprivate func getTextFromIngredient(_ ingredient: String) -> String {
        return ingredient.firstRegexMatches("^.*?\\|(.*)$")
    }
    
    //--------------------------------------
    // MARK: - actions
    //--------------------------------------

    func uploadRecipe(_ sender: UIBarButtonItem) {
        
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
            ] as [String : Any]
            ParseHelper.sharedInstance.uploadRecipe(recipeData, vc: self)
        }
    }
    
    @IBAction func unwindToVC(_ segue: UIStoryboardSegue) {
        if segue.source.isKind(of: SelectCategoriesTableViewController.self) {
            if let sourceVC = segue.source as? SelectCategoriesTableViewController {
                self.recipeCategories = sourceVC.selectedCategories
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: AddRecipeViewController.NotificationDoneSelectingCategories), object: self.recipeCategories)
    }
    
    //--------------------------------------
    // MARK: - Text Field Delegate
    //--------------------------------------
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //--------------------------------------
    // MARK: - navigation
    //--------------------------------------

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueSelectCategoriesTableViewController {
            let destinationNavigationViewController = segue.destination
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
