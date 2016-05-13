//
//  SelectCategoriesTableViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 10/05/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class SelectCategoriesTableViewController: UITableViewController {

    let CellIdentifier = "Cell"
    
    var categories: [Category]!
    var selectedCategories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem?.title = getLocalizedString("done")
        
        self.tableView.allowsMultipleSelection = true
        
        self.title = getLocalizedString("chooseCategories")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--------------------------------------
    // MARK: - Table view data source
    //--------------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)

        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        cell.textLabel?.font = UIFont(name: "Alef-Regular", size: 16)
        cell.textLabel?.textAlignment = NSTextAlignment.Right
        
        var addCheckMark = false
        
        for selectedCategory in selectedCategories {
            if selectedCategory.name == category.name {
                addCheckMark = true
                break
            }
        }
        
        if addCheckMark {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        cell.tintColor = Helpers.getRedColor()
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.checkAndDisplayCheckMarkOnCellAtIndexPath(indexPath)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.checkAndDisplayCheckMarkOnCellAtIndexPath(indexPath)
    }

    //--------------------------------------
    // MARK: - helpers
    //--------------------------------------

    func isCategoryAlreadySelected(category: Category) -> Bool {
        for selectedCategory in selectedCategories {
            if selectedCategory.name == category.name {
                return true
            }
        }
        return false
    }
    
    func checkAndDisplayCheckMarkOnCellAtIndexPath(indexPath: NSIndexPath) {
        if self.isCategoryAlreadySelected(categories[indexPath.row]) {
            self.uncheckCategoryAtIndexPath(indexPath)
        } else {
            self.checkCategoryAtIndexPath(indexPath)
        }
    }
    
    func checkCategoryAtIndexPath(indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        self.selectedCategories.append(categories[indexPath.row])
    }
    
    func uncheckCategoryAtIndexPath(indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        self.selectedCategories.removeObject(categories[indexPath.row])
    }
}
