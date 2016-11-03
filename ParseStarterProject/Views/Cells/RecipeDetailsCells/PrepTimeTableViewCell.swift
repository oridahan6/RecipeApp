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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        
        let titleAttributes = self.getTitleTextAttributes()
        let textAttributes = self.getTextAttributes()
        
        // draw prep title
        let prepTitleSize = self.getPrepTimeTitleSize()
        let prepTitleX = self.frame.size.width - marginRightfromScreen - prepTitleSize.width
        self.getPrepTimeTitle().draw(in: CGRect(x: prepTitleX, y: marginTop, width: prepTitleSize.width, height: prepTitleSize.height), withAttributes: titleAttributes)
        
        // draw prep time
        let prepTimeSize = self.getPrepTimeTextSize()
        let prepTimeX = prepTitleX - marginRightAfterTitle - prepTimeSize.width
        self.getPrepTimeText().draw(in: CGRect(x: prepTimeX, y: marginTop, width: prepTimeSize.width, height: prepTimeSize.height), withAttributes: textAttributes)

        if recipe.cookTime > 0 {
            let cookTitleSize = self.getCookTimeTitleSize()
            let cookTimeSize = self.getCookTimeTextSize()
            
            // if labels are too long draw in second line
            if self.getHeight() > self.shortHeight {
                let cookTitleX = self.frame.size.width - marginRightfromScreen - cookTitleSize.width
                let cookTextY = prepTitleSize.height + marginTopLongWidthText
                self.getCookTimeTitle().draw(in: CGRect(x: cookTitleX, y: cookTextY, width: cookTitleSize.width, height: cookTitleSize.height), withAttributes: titleAttributes)
                let cookTimeX = cookTitleX - marginRightAfterTitle - cookTimeSize.width
                self.getCookTimeText().draw(in: CGRect(x: cookTimeX, y: cookTextY, width: cookTimeSize.width, height: cookTimeSize.height), withAttributes: textAttributes)
            } else {
                let cookTitleX = prepTimeX - marginRightFromSection - cookTitleSize.width
                self.getCookTimeTitle().draw(in: CGRect(x: cookTitleX, y: marginTop, width: cookTitleSize.width, height: cookTitleSize.height), withAttributes: titleAttributes)
                let cookTimeX = cookTitleX - marginRightAfterTitle - cookTimeSize.width
                self.getCookTimeText().draw(in: CGRect(x: cookTimeX, y: marginTop, width: cookTimeSize.width, height: cookTimeSize.height), withAttributes: textAttributes)
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
    
    fileprivate func getTitleTextAttributes() -> [String: AnyObject] {
        // set the text color to dark gray
        let fieldColor: UIColor = UIColor.black
        
        // set the font to Helvetica Neue 18
        let fieldFont = Helpers.sharedInstance.getTitleFont(18)
        
        // set the line spacing to 6
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .right
        paraStyle.maximumLineHeight = 15.0
        //            paraStyle.lineSpacing = 6.0
        
        // set the Obliqueness to 0.1
        let skew = 0.1
        
        let attributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: fieldColor,
            //            NSBackgroundColorAttributeName: UIColor.yellowColor(),
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew as AnyObject,
            NSFontAttributeName: fieldFont
        ]
        
        return attributes
    }
    
    fileprivate func getTextAttributes() -> [String: AnyObject] {
        // set the text color to dark gray
        let fieldColor: UIColor = UIColor.gray
        
        // set the font to Helvetica Neue 18
        let fieldFont = Helpers.sharedInstance.getTextFont(16)
        
        // set the line spacing to 6
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .right
        paraStyle.maximumLineHeight = 15.0
        
        // set the Obliqueness to 0.1
        let skew = 0.1
        
        let attributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: fieldColor,
            //            NSBackgroundColorAttributeName: UIColor.yellowColor(),
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew as AnyObject,
            NSFontAttributeName: fieldFont
        ]
        return attributes
    }

    fileprivate func getTotalWidth() -> CGFloat {
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
    
    fileprivate func getPrepTimeTitle() -> String {
        return getLocalizedString("preperation") + ":"
    }
    
    fileprivate func getPrepTimeText() -> String {
        if self.prepTimeText == nil {
            self.prepTimeText = recipe.getPreperationTimeText()
        }
        return self.prepTimeText
    }
    
    fileprivate func getPrepTimeTitleSize() -> CGSize {
        if self.prepTimeTitleSize == nil {
            self.prepTimeTitleSize = self.getPrepTimeTitle().size(attributes: self.getTitleTextAttributes())
        }
        return self.prepTimeTitleSize
    }
    
    fileprivate func getPrepTimeTextSize() -> CGSize {
        if self.prepTimeTextSize == nil {
            self.prepTimeTextSize = self.getPrepTimeText().size(attributes: self.getTextAttributes())
        }
        return self.prepTimeTextSize
    }
    
    fileprivate func getCookTimeTitle() -> String {
        return getLocalizedString("cook") + ":"
    }
    
    fileprivate func getCookTimeText() -> String {
        if self.cookTimeText == nil {
            self.cookTimeText = recipe.getCookTimeText()
        }
        return self.cookTimeText
    }
    
    fileprivate func getCookTimeTitleSize() -> CGSize {
        if recipe.cookTime == 0 {
            return CGSize()
        }
        if self.cookTimeTitleSize == nil {
            self.cookTimeTitleSize = self.getCookTimeTitle().size(attributes: self.getTitleTextAttributes())
        }
        return self.cookTimeTitleSize
    }
    
    fileprivate func getCookTimeTextSize() -> CGSize {
        if recipe.cookTime == 0 {
            return CGSize()
        }
        if self.cookTimeTextSize == nil {
            self.cookTimeTextSize = self.getCookTimeText().size(attributes: self.getTextAttributes())
        }
        return self.cookTimeTextSize
    }
    
}
