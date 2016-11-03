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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)

        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        cell.textLabel?.font = Helpers.sharedInstance.getTextFont(16)
        cell.textLabel?.textAlignment = NSTextAlignment.right
        
        var addCheckMark = false
        
        for selectedCategory in selectedCategories {
            if selectedCategory.name == category.name {
                addCheckMark = true
                break
            }
        }
        
        if addCheckMark {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.tintColor = Helpers.sharedInstance.getRedColor()
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.checkAndDisplayCheckMarkOnCellAtIndexPath(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.checkAndDisplayCheckMarkOnCellAtIndexPath(indexPath)
    }

    //--------------------------------------
    // MARK: - helpers
    //--------------------------------------

    func isCategoryAlreadySelected(_ category: Category) -> Bool {
        for selectedCategory in selectedCategories {
            if selectedCategory.name == category.name {
                return true
            }
        }
        return false
    }
    
    func checkAndDisplayCheckMarkOnCellAtIndexPath(_ indexPath: IndexPath) {
        if self.isCategoryAlreadySelected(categories[indexPath.row]) {
            self.uncheckCategoryAtIndexPath(indexPath)
        } else {
            self.checkCategoryAtIndexPath(indexPath)
        }
    }
    
    func checkCategoryAtIndexPath(_ indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        self.selectedCategories.append(categories[indexPath.row])
    }
    
    func uncheckCategoryAtIndexPath(_ indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        self.selectedCategories.removeObject(categories[indexPath.row])
    }
}
