//
//  PrepTimeTableViewCell.swift
//  Recipes
//
//  Created by Ori Dahan on 31/03/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

class PrepTimeTableViewCell: UITableViewCell {

    @IBOutlet var cookTimeTitleLabel: UILabel!
    @IBOutlet var cookTimeLabel: UILabel!

    let marginRightAfterTitle: CGFloat = 7
    let marginRightFromSection: CGFloat = 15
    let marginRightfromScreen: CGFloat = 46
    let marginTop: CGFloat = 0
    let marginTopLongWidthText: CGFloat = 5

    let shortHeight: CGFloat = 16
    let tallHeight: CGFloat = 32
    
    var recipe: Recipe!

    var prepTimeText: String!
    var cookTimeText: String!
    var prepTimeTitleSize: CGSize!
    var cookTimeTitleSize: CGSize!
    var prepTimeTextSize: CGSize!
    var cookTimeTextSize: CGSize!
    
    var totalWidth: CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func drawRect(rect: CGRect) {
        
        let titleAttributes = self.getTitleTextAttributes()
        let textAttributes = self.getTextAttributes()
        
        // draw prep title
        let prepTitleSize = self.getPrepTimeTitleSize()
        let prepTitleX = self.frame.size.width - marginRightfromScreen - prepTitleSize.width
        self.getPrepTimeTitle().drawInRect(CGRectMake(prepTitleX, marginTop, prepTitleSize.width, prepTitleSize.height), withAttributes: titleAttributes)
        
        // draw prep time
        let prepTimeSize = self.getPrepTimeTextSize()
        let prepTimeX = prepTitleX - marginRightAfterTitle - prepTimeSize.width
        self.getPrepTimeText().drawInRect(CGRectMake(prepTimeX, marginTop, prepTimeSize.width, prepTimeSize.height), withAttributes: textAttributes)

        if recipe.cookTime > 0 {
            let cookTitleSize = self.getCookTimeTitleSize()
            let cookTimeSize = self.getCookTimeTextSize()
            
            // if labels are too long draw in second line
            if self.getHeight() > self.shortHeight {
                let cookTitleX = self.frame.size.width - marginRightfromScreen - cookTitleSize.width
                let cookTextY = prepTitleSize.height + marginTopLongWidthText
                self.getCookTimeTitle().drawInRect(CGRectMake(cookTitleX, cookTextY, cookTitleSize.width, cookTitleSize.height), withAttributes: titleAttributes)
                let cookTimeX = cookTitleX - marginRightAfterTitle - cookTimeSize.width
                self.getCookTimeText().drawInRect(CGRectMake(cookTimeX, cookTextY, cookTimeSize.width, cookTimeSize.height), withAttributes: textAttributes)
            } else {
                let cookTitleX = prepTimeX - marginRightFromSection - cookTitleSize.width
                self.getCookTimeTitle().drawInRect(CGRectMake(cookTitleX, marginTop, cookTitleSize.width, cookTitleSize.height), withAttributes: titleAttributes)
                let cookTimeX = cookTitleX - marginRightAfterTitle - cookTimeSize.width
                self.getCookTimeText().drawInRect(CGRectMake(cookTimeX, marginTop, cookTimeSize.width, cookTimeSize.height), withAttributes: textAttributes)
            }
            
        }
    }
    
    func getHeight() -> CGFloat {
        // if labels are too long make taller cell
        if self.getTotalWidth() > self.frame.size.width - 8 {
            return self.tallHeight
        }
        return self.shortHeight
    }
    
    private func getTitleTextAttributes() -> [String: AnyObject] {
        // set the text color to dark gray
        let fieldColor: UIColor = UIColor.blackColor()
        
        // set the font to Helvetica Neue 18
        let fieldFont = Helpers.sharedInstance.getTitleFont(18)
        
        // set the line spacing to 6
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .Right
        paraStyle.maximumLineHeight = 15.0
        //            paraStyle.lineSpacing = 6.0
        
        // set the Obliqueness to 0.1
        let skew = 0.1
        
        let attributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: fieldColor,
            //            NSBackgroundColorAttributeName: UIColor.yellowColor(),
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,
            NSFontAttributeName: fieldFont
        ]
        
        return attributes
    }
    
    private func getTextAttributes() -> [String: AnyObject] {
        // set the text color to dark gray
        let fieldColor: UIColor = UIColor.grayColor()
        
        // set the font to Helvetica Neue 18
        let fieldFont = Helpers.sharedInstance.getTextFont(16)
        
        // set the line spacing to 6
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .Right
        paraStyle.maximumLineHeight = 15.0
        
        // set the Obliqueness to 0.1
        let skew = 0.1
        
        let attributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: fieldColor,
            //            NSBackgroundColorAttributeName: UIColor.yellowColor(),
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,
            NSFontAttributeName: fieldFont
        ]
        return attributes
    }

    private func getTotalWidth() -> CGFloat {
        if self.totalWidth == nil {
        self.totalWidth =
            marginRightfromScreen +
            self.getPrepTimeTitleSize().width +
            marginRightAfterTitle +
            self.getPrepTimeTextSize().width +
            marginRightFromSection +
            self.getCookTimeTitleSize().width +
            marginRightAfterTitle +
            self.getCookTimeTextSize().width
        }
        return self.totalWidth
    }
    
    //--------------------------------------
    // MARK: - Cache size calculations methods
    //--------------------------------------
    
    private func getPrepTimeTitle() -> String {
        return getLocalizedString("preperation") + ":"
    }
    
    private func getPrepTimeText() -> String {
        if self.prepTimeText == nil {
            self.prepTimeText = recipe.getPreperationTimeText()
        }
        return self.prepTimeText
    }
    
    private func getPrepTimeTitleSize() -> CGSize {
        if self.prepTimeTitleSize == nil {
            self.prepTimeTitleSize = self.getPrepTimeTitle().sizeWithAttributes(self.getTitleTextAttributes())
        }
        return self.prepTimeTitleSize
    }
    
    private func getPrepTimeTextSize() -> CGSize {
        if self.prepTimeTextSize == nil {
            self.prepTimeTextSize = self.getPrepTimeText().sizeWithAttributes(self.getTextAttributes())
        }
        return self.prepTimeTextSize
    }
    
    private func getCookTimeTitle() -> String {
        return getLocalizedString("cook") + ":"
    }
    
    private func getCookTimeText() -> String {
        if self.cookTimeText == nil {
            self.cookTimeText = recipe.getCookTimeText()
        }
        return self.cookTimeText
    }
    
    private func getCookTimeTitleSize() -> CGSize {
        if recipe.cookTime == 0 {
            return CGSize()
        }
        if self.cookTimeTitleSize == nil {
            self.cookTimeTitleSize = self.getCookTimeTitle().sizeWithAttributes(self.getTitleTextAttributes())
        }
        return self.cookTimeTitleSize
    }
    
    private func getCookTimeTextSize() -> CGSize {
        if recipe.cookTime == 0 {
            return CGSize()
        }
        if self.cookTimeTextSize == nil {
            self.cookTimeTextSize = self.getCookTimeText().sizeWithAttributes(self.getTextAttributes())
        }
        return self.cookTimeTextSize
    }
    
}
