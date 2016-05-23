//
//  ODUIKitExtensions.swift
//  Recipes
//
//  Created by Ori Dahan on 23/05/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

extension UIView {
    
    func drawRecipeDetails(recipe: Recipe, isShowDate: Bool = true) {
        self.drawTitle(recipe)
        if isShowDate {
            self.drawUpdatedAt(recipe)
        }
        self.drawInfo(recipe)
    }
    
    private func drawTitle(recipe: Recipe) {
        let title: NSString = recipe.title
        let attributes = self.getTitleTextAttributes()
        let titleSize = title.sizeWithAttributes(attributes)
        title.drawInRect(CGRectMake(self.frame.size.width - 5 - titleSize.width, 5, titleSize.width, titleSize.height), withAttributes: attributes)
    }
    
    private func drawUpdatedAt(recipe: Recipe) {
        let updatedAtText: NSString = recipe.getUpdatedAtDiff()
        updatedAtText.drawInRect(CGRectMake(5, 5, 100.0, 15.0), withAttributes: self.getInfoTextAttributes(.Left))
    }
    
    private func drawInfo(recipe: Recipe) {
        
        // draw chef icon
        let chefIcon = UIImage(named: "chef-icon.png")
        let chefIconLength: CGFloat = 15
        let marginFromRight: CGFloat = 8
        let marginFromBottom: CGFloat = 4
        let chefIconX = self.frame.size.width - marginFromRight - chefIconLength
        chefIcon?.drawInRect(CGRect(x: chefIconX, y: self.frame.size.height - marginFromBottom - chefIconLength + 1, width: chefIconLength, height: chefIconLength))
        
        let marginRightAfterIcon: CGFloat = 5
        let marginRightAfterText: CGFloat = 10
        let textNegativeMarginFromButton: CGFloat = 2
        let attributes = self.getInfoTextAttributes(.Right)
        
        // draw level text
        let levelText: NSString = recipe.level
        let levelTextSize = levelText.sizeWithAttributes(attributes)
        let levelTextX = chefIconX - marginRightAfterIcon - levelTextSize.width
        levelText.drawInRect(CGRectMake(levelTextX, self.frame.size.height - marginFromBottom - levelTextSize.height + textNegativeMarginFromButton, levelTextSize.width, levelTextSize.height), withAttributes: attributes)
        
        // draw type icon
        let typeIcon = recipe.getTypeImage()
        let typeIconLength: CGFloat = 17
        let typeIconX = levelTextX - marginRightAfterText - typeIconLength
        typeIcon.drawInRect(CGRect(x: typeIconX, y: self.frame.size.height - marginFromBottom - typeIconLength + 2, width: typeIconLength, height: typeIconLength))
        
        // draw type text
        let typeText: NSString = recipe.type
        let typeTextSize = typeText.sizeWithAttributes(attributes)
        let typeTextX = typeIconX - marginRightAfterIcon - typeTextSize.width
        typeText.drawInRect(CGRectMake(typeTextX, self.frame.size.height - marginFromBottom - typeTextSize.height + textNegativeMarginFromButton, typeTextSize.width, typeTextSize.height), withAttributes: attributes)
        
        // draw timer icon
        let timerIcon = UIImage(named: "timer-icon.png")
        let timerIconLength: CGFloat = 15
        let timerIconX = typeTextX - marginRightAfterText - timerIconLength
        timerIcon?.drawInRect(CGRect(x: timerIconX, y: self.frame.size.height - marginFromBottom - timerIconLength + 1, width: timerIconLength, height: timerIconLength))
        
        // draw time text
        let timeText: NSString = recipe.getOverallPreperationTimeText()
        let timeTextSize = timeText.sizeWithAttributes(attributes)
        let timeTextX = timerIconX - marginRightAfterIcon - timeTextSize.width
        timeText.drawInRect(CGRectMake(timeTextX, self.frame.size.height - marginFromBottom - timeTextSize.height + textNegativeMarginFromButton, timeTextSize.width, timeTextSize.height), withAttributes: attributes)
    }
    
    private func getTitleTextAttributes() -> [String: AnyObject] {
        // set the text color to dark gray
        let fieldColor: UIColor = UIColor.blackColor()
        
        // set the font to Helvetica Neue 18
        let fieldFont = UIFont(name: "Hillel CLM", size: 26)
        
        // set the line spacing to 6
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .Right
        //            paraStyle.lineSpacing = 6.0
        
        // set the Obliqueness to 0.1
        let skew = 0.1
        
        let attributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: fieldColor,
            //            NSBackgroundColorAttributeName: UIColor.yellowColor(),
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,
            NSFontAttributeName: fieldFont!
        ]
        
        return attributes
    }
    
    private func getInfoTextAttributes(textAlignment: NSTextAlignment) -> [String: AnyObject] {
        // set the text color to dark gray
        let fieldColor: UIColor = UIColor.grayColor()
        
        // set the font to Helvetica Neue 18
        let fieldFont = UIFont(name: "Alef-Regular", size: 12)
        
        // set the line spacing to 6
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = textAlignment
        paraStyle.maximumLineHeight = 15.0
        
        // set the Obliqueness to 0.1
        let skew = 0.1
        
        let attributes: [String: AnyObject] = [
            NSForegroundColorAttributeName: fieldColor,
            //            NSBackgroundColorAttributeName: UIColor.yellowColor(),
            NSParagraphStyleAttributeName: paraStyle,
            NSObliquenessAttributeName: skew,
            NSFontAttributeName: fieldFont!
        ]
        return attributes
    }

}