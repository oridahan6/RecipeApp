//
//  ODUIKitExtensions.swift
//  Recipes
//
//  Created by Ori Dahan on 23/05/2016.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit

extension UIView {
    
    func drawRecipeDetails(_ recipe: Recipe, isShowDate: Bool = true) {
        self.drawTitle(recipe)
        if isShowDate {
            self.drawUpdatedAt(recipe)
        }
        self.drawInfo(recipe)
    }
    
    fileprivate func drawTitle(_ recipe: Recipe) {
        let title: NSString = recipe.title as NSString
        let attributes = self.getTitleTextAttributes()
        let titleSize = title.size(attributes: attributes)
        title.draw(in: CGRect(x: self.frame.size.width - 5 - titleSize.width, y: 5, width: titleSize.width, height: titleSize.height), withAttributes: attributes)
    }
    
    fileprivate func drawUpdatedAt(_ recipe: Recipe) {
        let updatedAtText: NSString = recipe.getUpdatedAtDiff() as NSString
        updatedAtText.draw(in: CGRect(x: 5, y: 5, width: 100.0, height: 15.0), withAttributes: self.getInfoTextAttributes(.left))
    }
    
    fileprivate func drawInfo(_ recipe: Recipe) {
        
        // draw chef icon
        let chefIcon = UIImage(named: "chef-icon.png")
        let chefIconLength: CGFloat = 15
        let marginFromRight: CGFloat = 8
        let marginFromBottom: CGFloat = 4
        let chefIconX = self.frame.size.width - marginFromRight - chefIconLength
        chefIcon?.draw(in: CGRect(x: chefIconX, y: self.frame.size.height - marginFromBottom - chefIconLength + 1, width: chefIconLength, height: chefIconLength))
        
        let marginRightAfterIcon: CGFloat = 5
        let marginRightAfterText: CGFloat = 10
        let textNegativeMarginFromButton: CGFloat = 2
        let attributes = self.getInfoTextAttributes(.right)
        
        // draw level text
        let levelText: NSString = recipe.level as NSString
        let levelTextSize = levelText.size(attributes: attributes)
        let levelTextX = chefIconX - marginRightAfterIcon - levelTextSize.width
        levelText.draw(in: CGRect(x: levelTextX, y: self.frame.size.height - marginFromBottom - levelTextSize.height + textNegativeMarginFromButton, width: levelTextSize.width, height: levelTextSize.height), withAttributes: attributes)
        
        // draw type icon
        let typeIcon = recipe.getTypeImage()
        let typeIconLength: CGFloat = 17
        let typeIconX = levelTextX - marginRightAfterText - typeIconLength
        typeIcon.draw(in: CGRect(x: typeIconX, y: self.frame.size.height - marginFromBottom - typeIconLength + 2, width: typeIconLength, height: typeIconLength))
        
        // draw type text
        let typeText: NSString = recipe.type as NSString
        let typeTextSize = typeText.size(attributes: attributes)
        let typeTextX = typeIconX - marginRightAfterIcon - typeTextSize.width
        typeText.draw(in: CGRect(x: typeTextX, y: self.frame.size.height - marginFromBottom - typeTextSize.height + textNegativeMarginFromButton, width: typeTextSize.width, height: typeTextSize.height), withAttributes: attributes)
        
        // draw timer icon
        let timerIcon = UIImage(named: "timer-icon.png")
        let timerIconLength: CGFloat = 15
        let timerIconX = typeTextX - marginRightAfterText - timerIconLength
        timerIcon?.draw(in: CGRect(x: timerIconX, y: self.frame.size.height - marginFromBottom - timerIconLength + 1, width: timerIconLength, height: timerIconLength))
        
        // draw time text
        let timeText: NSString = recipe.getOverallPreperationTimeText() as NSString
        let timeTextSize = timeText.size(attributes: attributes)
        let timeTextX = timerIconX - marginRightAfterIcon - timeTextSize.width
        timeText.draw(in: CGRect(x: timeTextX, y: self.frame.size.height - marginFromBottom - timeTextSize.height + textNegativeMarginFromButton, width: timeTextSize.width, height: timeTextSize.height), withAttributes: attributes)
    }
    
    fileprivate func getTitleTextAttributes() -> [String: AnyObject] {
        // set the text color to dark gray
        let fieldColor: UIColor = UIColor.black
        
        // set the font to Helvetica Neue 18
        let fieldFont = Helpers.sharedInstance.getTitleFont()
        
        // set the line spacing to 6
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.alignment = .right
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
    
    fileprivate func getInfoTextAttributes(_ textAlignment: NSTextAlignment) -> [String: AnyObject] {
        // set the text color to dark gray
        let fieldColor: UIColor = UIColor.gray
        
        // set the font to Helvetica Neue 18
        let fieldFont = Helpers.sharedInstance.getTextFont(12)
        
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
            NSObliquenessAttributeName: skew as AnyObject,
            NSFontAttributeName: fieldFont
        ]
        return attributes
    }

}
