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
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = getLocalizedString("addRecipe")
        
        // set table view background image
        self.view.backgroundColor = UIColor(patternImage: Helpers().getDeviceSpecificBGImage("tableview-bg"))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
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
            return 1
        default:
            return 0
        }

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(ImageAddTableViewCellIdentifier, forIndexPath: indexPath) as! ImageAddTableViewCell
            cell.parentController = self
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(GeneralInfoTableViewCellIdentifier, forIndexPath: indexPath) as! GeneralInfoTableViewCell
            cell.backgroundColor = .clearColor()
            return cell
        }
        return UITableViewCell()
    }

    //--------------------------------------
    // MARK: - Table view delegate
    //--------------------------------------
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 215
        } else if indexPath.section == 1 {
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
            let view = UIView(frame: cell.frame)
            cell.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            view.addSubview(cell)
            return view
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier(AddRecipeSectionHeaderTableViewCellIdentifier) as! AddRecipeSectionHeaderTableViewCell
            
            self.setSectionHeaderElements(cell, FAIconName: FontAwesome.Info, title: "sectionHeaderTitleGeneralInfo")
            
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
    
    //--------------------------------------
    // MARK: - Text Field Delegate
    //--------------------------------------
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}
