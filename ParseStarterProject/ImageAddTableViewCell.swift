//
//  ImageAddTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 21/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class ImageAddTableViewCell: UITableViewCell, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var parentController: UITableViewController!
    
    @IBOutlet var uploadImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.uploadImageView.userInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageAddTableViewCell.pickImage))
        self.uploadImageView.addGestureRecognizer(tapGesture)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //--------------------------------------
    // MARK: - Helpers
    //--------------------------------------

    func pickImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        self.parentController.presentViewController(picker, animated: true, completion: nil)
    }
    
    //--------------------------------------
    // MARK: - UIImagePickerControllerDelegate methods
    //--------------------------------------

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        parentController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        self.uploadImageView.image = newImage
        
        parentController.dismissViewControllerAnimated(true, completion: nil)
    }
}