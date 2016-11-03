//
//  ImageAddTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 21/04/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class ImageAddTableViewCell: UITableViewCell, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var parentController: AddRecipeViewController!
    
    @IBOutlet var uploadImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.uploadImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ImageAddTableViewCell.pickImage))
        self.uploadImageView.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ImageAddTableViewCell.uploadRecipeSuccess(_:)), name: NSNotification.Name(rawValue: AddRecipeViewController.NotificationUploadRecipeSuccess), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
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
        self.parentController.present(picker, animated: true, completion: nil)
    }
    
    func uploadRecipeSuccess(_ notification: Notification) {
        self.uploadImageView.image = UIImage(named: "placeholder-w-add.png")
    }
    
    //--------------------------------------
    // MARK: - UIImagePickerControllerDelegate methods
    //--------------------------------------

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parentController.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        self.uploadImageView.image = newImage
        self.parentController.recipeImage = newImage
        
        parentController.dismiss(animated: true, completion: nil)
    }
}
