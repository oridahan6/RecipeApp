//
//  CategoriesViewController.swift
//  Recipes
//
//  Created by Ori Dahan on 27/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Kingfisher

class CategoriesViewController: UITableViewController, SwiftPromptsProtocol {
    
    let CellIdentifier = "CategoryTableViewCell"
    let SegueRecipesViewController = "RecipesViewController"
    
    var prompt = SwiftPromptsView()
    var activityIndicator: ActivityIndicator!
    
    var categories = [Category]() {
        didSet {
            tableView.reloadData()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: getLocalizedString("Categories"), image: UIImage.fontAwesomeIconWithName(FontAwesome.ThList, textColor: UIColor.grayColor(), size: CGSizeMake(30, 30)), tag: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = getLocalizedString("Categories")
        
        if !Helpers.isInternetConnectionAvailable() {
            self.buildAlert()
            self.showAlert()
        } else {
            // Activity Indicator
            self.activityIndicator = ActivityIndicator(largeActivityView: self.view)
            
            ParseHelper().updateCategories(self)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //--------------------------------------
    // MARK: - Navigation
    //--------------------------------------

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueRecipesViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let category = categories[indexPath.row]
                let destinationViewController = segue.destinationViewController as! RecipesViewController
                destinationViewController.catId = category.catId
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
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! CategoryTableViewCell

        let category = categories[indexPath.row]

        cell.categoryNameLabel.text = category.name
        cell.recipesCountLabel.text = Helpers().getSingularOrPluralForm(category.recipesCount, textToConvert: "recipe")
        
        // update image async
        let imageUrlString = Constants.GDCategoriesImagesPath + category.imageName
        KingfisherHelper.sharedInstance.setImageWithUrl(cell.categoryImage, url: imageUrlString)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        return cell
    }

    //--------------------------------------
    // MARK: - Helpers Methods
    //--------------------------------------

    private func buildAlert() {
        //Create an instance of SwiftPromptsView and assign its delegate
        prompt = SwiftPromptHelper.getSwiftPromptView(self.view.bounds)
        prompt.delegate = self
        
        SwiftPromptHelper.buildErrorAlert(prompt)
        
    }
    
    private func showAlert() {
        self.view.addSubview(prompt)
    }
    
    //--------------------------------------
    // MARK: - SwiftPromptsProtocol delegate methods
    //--------------------------------------

    func clickedOnTheMainButton() {
        print("Clicked on the main button")
        prompt.dismissPrompt()
    }
    
    func clickedOnTheSecondButton() {
        print("Clicked on the second button")
        prompt.dismissPrompt()
        
    }
    
    func promptWasDismissed() {
        print("Dismissed the prompt")
    }

}
