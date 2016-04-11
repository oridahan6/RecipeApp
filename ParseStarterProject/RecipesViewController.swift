//
//  RecipesViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 27/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Kingfisher

class RecipesViewController: UITableViewController {

    let CellIdentifier = "RecipeTableViewCell"
    let SegueRecipeViewController = "RecipeViewController"
    
    var catId: Int?
    var activityIndicator: ActivityIndicator!
    
    var recipes = [Recipe]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: getLocalizedString("Recipes"), image: UIImage.fontAwesomeIconWithName(FontAwesome.Cutlery, textColor: UIColor.grayColor(), size: CGSizeMake(30, 30)), tag: 2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = getLocalizedString("Recipes")
        
        // Activity Indicator
        self.activityIndicator = ActivityIndicator(largeActivityView: self.view)
        
        if let categoryId = self.catId {
            ParseHelper().updateRecipesFromCategoryId(self, catId: categoryId)
        } else {
            ParseHelper().updateRecipes(self)
        }
        
        // Register Class
        // tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--------------------------------------
    // MARK: - Navigation
    //--------------------------------------

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueRecipeViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let recipe = recipes[indexPath.row]
                let destinationViewController = segue.destinationViewController as! RecipeViewController
                destinationViewController.recipe = recipe
            }
        }
    }
    
    //--------------------------------------
    // MARK: - Table view data source
    //--------------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! RecipeTableViewCell

        let recipe = recipes[indexPath.row]

        cell.recipeDetailsView.titleLabel.text = recipe.title
        cell.recipeDetailsView.typeLabel.text = recipe.type
        cell.recipeDetailsView.levelLabel.text = recipe.level
        cell.recipeDetailsView.overallTimeLabel.text = recipe.getOverallPreperationTimeText()
        cell.recipeDetailsView.dateAddedLabel.text = recipe.getDateAddedDiff()
        
        // update image async
        let imageUrlString = Constants.GDRecipesImagesPath + recipe.imageName
        KingfisherHelper.sharedInstance.setImageWithUrl(cell.recipeImageView, url: imageUrlString)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }

}
