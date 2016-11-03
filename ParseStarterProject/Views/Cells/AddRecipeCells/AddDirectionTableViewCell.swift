//
//  AddDirectionTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 01/05/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class AddDirectionTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var directionTextView: UITextView!
    
    var tableViewController: AddRecipeViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.directionTextView.delegate = self
        self.directionTextView.textContainerInset = UIEdgeInsetsMake(8, 5, 8, 5); // top, left, bottom, right
        self.directionTextView.backgroundColor = Helpers.sharedInstance.uicolorFromHex(0xF3EEE8)
        
        // delete this line ?
        self.directionTextView.tag = 0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.directionTextView.layer.borderWidth = 0.5
        self.directionTextView.layer.borderColor = UIColor.black.cgColor
        
        if let tableVC = self.tableViewController {
            if tableVC.isDirectionEditing {
                var frame = self.contentView.frame
                frame.size.width = frame.size.width + 40
                self.contentView.frame = frame
            }
        }
        
    }
    
    //--------------------------------------
    // MARK: - Text View Delegate
    //--------------------------------------
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        self.updateDirectionsArray(textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------

    // not supporting sections yet
    func updateDirectionsArray(_ textView: UITextView) {
        
        if let directionText = textView.text, let cell = textView.superview?.superview as? AddDirectionTableViewCell {
            if let indexPath = self.tableViewController.tableView.indexPath(for: cell) {
                let currentRow = indexPath.row
                if var recipeDirections = self.tableViewController.recipeDirections["general"] {
                    if recipeDirections.count <= currentRow {
                        recipeDirections.append(directionText)
                    } else {
                        recipeDirections[currentRow] = directionText
                    }
                    
                    self.tableViewController.recipeDirections["general"] = recipeDirections
                }
            }
        }
    }

}
